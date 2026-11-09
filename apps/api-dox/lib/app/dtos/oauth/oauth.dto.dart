import 'package:dox_core/dox_core.dart';

part 'oauth.dto.g.dart';

/// Query of GET /oauth/client: the OAuth names the client sent
/// (`client_id`, `redirect_uri`), so snake_case keys.
@Dto(source: Source.query)
class OauthClientQuery {
  @Length(min: 1, max: 2000)
  final String clientId;

  @Length(min: 1, max: 2000)
  final String redirectUri;

  const OauthClientQuery({required this.clientId, required this.redirectUri});

  static const DtoSchema<OauthClientQuery> schema = $OauthClientQueryDto;
}

/// Body of POST /oauth/approve: what the consent page read from the query.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class ApproveOauth {
  @Length(min: 1, max: 2000)
  final String clientId;

  @Length(min: 1, max: 2000)
  final String redirectUri;

  @Length(min: 1, max: 2000)
  final String codeChallenge;

  @Length(min: 1, max: 20)
  final String codeChallengeMethod;

  @Length(max: 2000)
  final String? state;

  @Length(max: 2000)
  final String? resource;

  const ApproveOauth({
    required this.clientId,
    required this.redirectUri,
    required this.codeChallenge,
    required this.codeChallengeMethod,
    this.state,
    this.resource,
  });

  static const DtoSchema<ApproveOauth> schema = $ApproveOauthDto;
}

/// Body of POST /oauth/deny.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class DenyOauth {
  @Length(min: 1, max: 2000)
  final String clientId;

  @Length(min: 1, max: 2000)
  final String redirectUri;

  @Length(max: 2000)
  final String? state;

  const DenyOauth({
    required this.clientId,
    required this.redirectUri,
    this.state,
  });

  static const DtoSchema<DenyOauth> schema = $DenyOauthDto;
}
