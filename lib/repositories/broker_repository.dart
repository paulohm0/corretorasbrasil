import 'package:dio/dio.dart';
import '../models/broker_model.dart';

class BrokerRepository {
  final Dio dio;

  BrokerRepository ({
    required this.dio,
});

  Future<List<BrokerModel>> brokerReposit() async {
    try {
      final apiResponse =
      await dio.get("https://brasilapi.com.br/api/cvm/corretoras/v1");

      return List.from(apiResponse.data)
          .map(
            (broker) => BrokerModel.fromJson(broker),
      ).toList();
    } catch (error, st) {
      rethrow;
    }
  }
}