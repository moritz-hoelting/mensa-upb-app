import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'MENSA_API_URL')
  static const String mensaApiUrl = _Env.mensaApiUrl;
}