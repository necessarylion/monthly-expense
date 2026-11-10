import 'package:dox_core/dox_core.dart';

part 'totp_code.dto.g.dart';

/// Body of POST /me/totp/enable and /me/totp/verify: the 6-digit code the
/// authenticator app shows.
@Dto()
class TotpCode {
  @Trim()
  @Length(min: 6, max: 6)
  final String code;

  const TotpCode({required this.code});

  static const DtoSchema<TotpCode> schema = $TotpCodeDto;
}
