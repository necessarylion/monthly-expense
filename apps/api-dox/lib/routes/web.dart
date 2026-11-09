import 'package:api_dox/http/static_files.dart';
import 'package:dox_core/dox_core.dart';

/// The built SPA. Any GET that no route answers gets a file from
/// `PUBLIC_DIR`, or `index.html` for client-side routes. Unknown `/api/*`
/// and `/mcp/*` paths get a JSON 404.
class WebRouter extends Router {
  @override
  void register() {
    StaticFiles files = Dox().ioc.get<StaticFiles>();
    Route.fallback((DoxRequest req) => files.serve(req));
  }
}
