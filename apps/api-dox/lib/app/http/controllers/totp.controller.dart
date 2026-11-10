import 'package:api_dox/app/dtos/totp_code/totp_code.dto.dart';
import 'package:api_dox/app/services/totp/totp.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

/// Two-step sign-in with an authenticator app (TOTP).
@Inject()
@Tags(<String>['Two-step sign-in'])
class TotpController {
  TotpController(this.totp);

  final TotpService totp;

  @Summary('Start turning on two-step sign-in')
  @Description('Gives the secret, and the `otpauth://` text for the QR code.')
  Future<Map<String, dynamic>> setup(DoxRequest req) async {
    return JsonResponse.ok(await totp.setup(req.authUser));
  }

  @Summary('Turn on two-step sign-in')
  @Description(
    'Needs one code from the app. The API token of this call stays signed in; other browsers are asked for a code.',
  )
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> enable(DoxRequest req, TotpCode body) async {
    await totp.enable(req.authUser, req.authToken, body.code);
    return JsonResponse.noContent();
  }

  @Summary('Finish a sign-in with a code')
  @Description(
    'For a user with two-step sign-in on. After it, the API token of this call passes.',
  )
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> verify(DoxRequest req, TotpCode body) async {
    await totp.verify(req.authUser, req.authToken, body.code);
    return JsonResponse.noContent();
  }

  @Summary('Turn off two-step sign-in')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> destroy(DoxRequest req) async {
    await totp.disable(req.authUser);
    return JsonResponse.noContent();
  }
}
