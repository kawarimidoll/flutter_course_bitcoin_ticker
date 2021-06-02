import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class NetworkHelper {
  late Uri url;

  Future<String> loadApiKey() async {
    await dotenv.load();
    return dotenv.env['COINAPI_APIKEY'] ?? '';
  }

  NetworkHelper(this.url);

  Future getData() async {
    String apiKey = await loadApiKey();
    Map<String, String> headers = {'X-CoinAPI-Key': apiKey};
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }
}

class CoinData {
  Future<dynamic> getCurrencyRate(
          String cryptoName, String currencyName) async =>
      await NetworkHelper(
        Uri.https(
          'rest.coinapi.io',
          '/v1/exchangerate/$cryptoName/$currencyName',
        ),
      ).getData();
}
