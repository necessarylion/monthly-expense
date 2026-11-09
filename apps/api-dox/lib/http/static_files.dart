import 'dart:io';

import 'package:api_dox/config/settings.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:dox_core/dox_core.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

final RegExp _compressible = RegExp(
  r'\.(js|mjs|css|html|svg|json|webmanifest|txt)$',
);

/// Serves the built SPA from the public folder. Any other GET that is not
/// an API path gets `index.html`, so client-side routes work on reload.
/// It is the `Route.fallback`, so it only sees GET and HEAD requests that
/// match no route.
@Inject()
class StaticFiles {
  StaticFiles(this.settings);

  final AppSettings settings;

  /// Gzipped files, per isolate.
  // ponytail: in-memory cache, fine because public/ only changes on deploy (a new process).
  final Map<String, List<int>> _gzipCache = <String, List<int>>{};

  String get _root => p.normalize(p.absolute(settings.publicDir));

  Future<dynamic> serve(DoxRequest req) async {
    String pathname = req.uri.path;
    String? filePath = await _findFile(pathname);
    if (filePath != null) return _fileResponse(req, filePath, pathname);

    if (!pathname.startsWith('/api/') && !pathname.startsWith('/mcp/')) {
      String index = p.join(_root, 'index.html');
      if (await _isFile(index)) return _fileResponse(req, index, '/index.html');
    }
    return JsonResponse.error(404, 'Not found');
  }

  /// Sends a file with cache headers, gzipped when the browser accepts it.
  /// Files in `/assets/` have a hash in the name, so they can be cached
  /// forever.
  Future<DoxResponse> _fileResponse(
    DoxRequest req,
    String filePath,
    String pathname,
  ) async {
    String type = lookupMimeType(filePath) ?? 'application/octet-stream';
    if (type.startsWith('text/') ||
        type == 'application/javascript' ||
        type == 'application/json') {
      type = '$type; charset=utf-8';
    }
    Map<String, String> headers = <String, String>{
      'Content-Type': type,
      'Vary': 'Accept-Encoding',
    };
    if (pathname.startsWith('/assets/')) {
      headers['Cache-Control'] = 'public, max-age=31536000, immutable';
    } else if (pathname.endsWith('.html')) {
      headers['Cache-Control'] = 'no-cache';
      // No other site may show our pages in a frame. Without this, a site
      // could hide the OAuth consent page in a frame and trick the user
      // into clicking "Allow" (clickjacking). Dox already sends
      // X-Frame-Options: SAMEORIGIN for older browsers.
      headers['Content-Security-Policy'] = "frame-ancestors 'none'";
    }

    bool acceptsGzip = (req.header('accept-encoding') ?? '').contains('gzip');
    if (!acceptsGzip || !_compressible.hasMatch(filePath)) {
      List<int> bytes = await File(filePath).readAsBytes();
      return response(Stream<List<int>>.value(bytes)).withHeaders(headers);
    }
    headers['Content-Encoding'] = 'gzip';
    List<int> body = await _gzipped(filePath);
    return response(Stream<List<int>>.value(body)).withHeaders(headers);
  }

  Future<List<int>> _gzipped(String filePath) async {
    List<int>? body = _gzipCache[filePath];
    if (body == null) {
      body = gzip.encode(await File(filePath).readAsBytes());
      _gzipCache[filePath] = body;
    }
    return body;
  }

  Future<String?> _findFile(String pathname) async {
    String decoded;
    try {
      decoded = Uri.decodeComponent(pathname);
    } catch (_) {
      return null;
    }
    if (decoded.contains('/.')) return null; // no dot files, no `..`
    String root = _root;
    String full = p.normalize(p.join(root, '.$decoded'));
    if (!p.isWithin(root, full)) return null;
    return await _isFile(full) ? full : null;
  }

  static Future<bool> _isFile(String path) async {
    return FileSystemEntity.type(path)
        .then((FileSystemEntityType type) => type == FileSystemEntityType.file);
  }
}
