import 'package:comet/data/auth_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST("auth/signin")
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);

  @POST("auth/signup")
  Future<AuthResponse> signUp(@Body() Map<String, dynamic> body);
}
