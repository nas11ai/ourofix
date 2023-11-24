import 'package:dio/dio.dart';
import 'package:mobile/src/constants/api.dart';
import 'package:mobile/src/features/home/domain/order.dart';
import 'package:retrofit/retrofit.dart';

part 'order_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class OrderRepository {
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;

  @POST("/order/create")
  @MultiPart()
  Future<void> submitOrder({
    @Header("Authorization") required String authorizationHeader,
    @Part(name: 'device_type_id') required String deviceTypeId,
    @Part(name: 'complains') required String complains,
    @Part(name: 'images') List<MultipartFile>? images,
  });

  @GET("/order/get")
  Future<Orders> getAllOrders({
    @Header("Authorization") required String authorizationHeader,
  });

  @POST("/order/transaction/create")
  Future<void> submitTransaction({
    @Body() required Map<String, dynamic> requestBody,
  });
}
