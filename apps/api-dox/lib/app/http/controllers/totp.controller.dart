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
    'Needs one code from the app. Gives a Firebase custom token; the web app calls `signInWithCustomToken` with it.',
  )
  Future<Map<String, dynamic>> enable(DoxRequest req, TotpCode body) async {
    String token = await totp.enable(req.authUser, body.code);
    return JsonResponse.ok(<String, String>{'token': token});
  }

  @Summary('Finish a sign-in with a code')
  @Description(
    'For a user with two-step sign-in on. Gives a Firebase custom token; the web app calls `signInWithCustomToken` with it.',
  )
  Future<Map<String, dynamic>> verify(DoxRequest req, TotpCode body) async {
    String token = await totp.verify(req.authUser, body.code);
    return JsonResponse.ok(<String, String>{'token': token});
  }

  @Summary('Turn off two-step sign-in')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> destroy(DoxRequest req) async {
    await totp.disable(req.authUser);
    return JsonResponse.noContent();
  }
}
