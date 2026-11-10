import 'package:api_dox/app/dtos/passkey/passkey.dto.dart';
import 'package:api_dox/app/serializers/passkey.serializer.dart';
import 'package:api_dox/app/services/passkey/passkey.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

/// Passkeys: add and remove them on the Me page (signed in), and sign in
/// with one on the login page (no token).
@Inject()
@Tags(<String>['Passkeys'])
class PasskeyController {
  PasskeyController(this.passkeys);

  final PasskeyService passkeys;

  @Summary('List my passkeys')
  Future<Map<String, dynamic>> index(DoxRequest req) async {
    return JsonResponse.ok(
      PasskeySerializer(await passkeys.list(req.authUser)).toJson(),
    );
  }

  @Summary('Start adding a passkey')
  @Description(
    'Options for `navigator.credentials.create()`. Bytes are base64url.',
  )
  Future<Map<String, dynamic>> registrationOptions(DoxRequest req) async {
    return JsonResponse.ok(await passkeys.registrationOptions(req.authUser));
  }

  @Summary('Add a passkey')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> store(DoxRequest req, AddPasskey body) async {
    await passkeys.register(
      req.authUser,
      credentialId: body.credentialId,
      clientDataJson: body.clientDataJson,
      authenticatorData: body.authenticatorData,
      publicKey: body.publicKey,
      publicKeyAlgorithm: body.publicKeyAlgorithm,
      name: body.name,
    );
    return JsonResponse.noContent();
  }

  @Summary('Remove a passkey')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> destroy(DoxRequest req, int id) async {
    await passkeys.remove(req.authUser, id);
    return JsonResponse.noContent();
  }

  @Summary('Start a passkey sign-in')
  @Description('Options for `navigator.credentials.get()`. No token needed.')
  Future<Map<String, dynamic>> loginOptions() async {
    return JsonResponse.ok(await passkeys.loginOptions());
  }

  @Summary('Sign in with a passkey')
  @Description(
    'Gives an API token, as `POST /auth/token` does. No token needed.',
  )
  Future<Map<String, dynamic>> login(DoxRequest req, PasskeyLogin body) async {
    String token = await passkeys.login(
      credentialId: body.credentialId,
      clientDataJson: body.clientDataJson,
      authenticatorData: body.authenticatorData,
      signature: body.signature,
      device: req.header('user-agent'),
    );
    return JsonResponse.ok(<String, String>{'token': token});
  }
}
