import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'MENSA_API_URL')
  static const String mensaApiUrl = _Env.mensaApiUrl;
  @EnviedField(varName: 'FUNDING_URL', optional: true)
  static const String? fundingUrl = _Env.fundingUrl;
  @EnviedField(varName: 'APP_AUTHOR', defaultValue: 'Moritz Hölting')
  static const String appAuthor = _Env.appAuthor;
  @EnviedField(
    varName: 'REPOSITORY_URL',
    defaultValue: 'https://github.com/moritz-hoelting/mensa-upb-app',
  )
  static const String repositoryUrl = _Env.repositoryUrl;
}
