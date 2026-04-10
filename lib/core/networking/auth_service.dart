import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart'; 

@RestApi(baseUrl: "https://api.comet-app.com/")
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST("auth/login")
  Future<dynamic> login(@Body() Map<String, dynamic> body);
}