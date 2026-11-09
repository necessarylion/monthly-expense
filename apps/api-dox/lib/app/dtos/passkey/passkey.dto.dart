import 'package:dox_core/dox_core.dart';

part 'passkey.dto.g.dart';

/// Body of POST /me/passkeys: the answer of `navigator.credentials.create()`.
/// Bytes are base64url.
@Dto(keyCase: KeyCase.field)
class AddPasskey {
  @Length(min: 1, max: 1400)
  final String credentialId;

  @Length(min: 1, max: 10000)
  final String clientDataJson;

  @Length(min: 1, max: 10000)
  final String authenticatorData;

  /// `response.getPublicKey()`: SubjectPublicKeyInfo DER.
  @Length(min: 1, max: 1000)
  final String publicKey;

  /// `response.getPublicKeyAlgorithm()`, a COSE id like -7.
  final int publicKeyAlgorithm;

  @Trim()
  @Length(min: 1, max: 200)
  final String name;

  const AddPasskey({
    required this.credentialId,
    required this.clientDataJson,
    required this.authenticatorData,
    required this.publicKey,
    required this.publicKeyAlgorithm,
    required this.name,
  });

  static const DtoSchema<AddPasskey> schema = $AddPasskeyDto;
}

/// Body of POST /passkeys/login: the answer of `navigator.credentials.get()`.
/// Bytes are base64url.
@Dto(keyCase: KeyCase.field)
class PasskeyLogin {
  @Length(min: 1, max: 1400)
  final String credentialId;

  @Length(min: 1, max: 10000)
  final String clientDataJson;

  @Length(min: 1, max: 10000)
  final String authenticatorData;

  @Length(min: 1, max: 1000)
  final String signature;

  const PasskeyLogin({
    required this.credentialId,
    required this.clientDataJson,
    required this.authenticatorData,
    required this.signature,
  });

  static const DtoSchema<PasskeyLogin> schema = $PasskeyLoginDto;
}
