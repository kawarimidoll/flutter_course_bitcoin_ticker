import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_bitcoin_ticker/coin_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart' show Platform;
import 'dart:convert';

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

Future<dynamic> getCurrencyRate(String cryptoName, String currencyName) async =>
    await NetworkHelper(
      Uri.https(
        'rest.coinapi.io',
        '/v1/exchangerate/$cryptoName/$currencyName',
      ),
    ).getData();

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    getRateData();
  }

  void getRateData() async {
    var data = await getCurrencyRate('BTC', selectedCurrency);
    if (data == null) {
      return;
    }
    print(data);
  }

  void updateCurrency(String? currencyName) {
    if (currencyName == null) {
      return;
    }

    setState(() {
      selectedCurrency = currencyName;
    });
    print(selectedCurrency);
  }

  DropdownButton<String> androidPicker() => DropdownButton<String>(
        value: selectedCurrency,
        items: currenciesList
            .map(
              (entry) => DropdownMenuItem(
                child: Text(entry),
                value: entry,
              ),
            )
            .toList(),
        onChanged: (value) {
          updateCurrency(value);
        },
      );

  CupertinoPicker iOSPicker() => CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          updateCurrency(currenciesList[selectedIndex]);
        },
        children: currenciesList
            .map(
              (entry) => Text(
                entry,
                style: TextStyle(color: Colors.white),
              ),
            )
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: cryptoList
                  .map(
                    (crypto) => Card(
                      color: Colors.lightBlueAccent,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 28.0,
                        ),
                        child: Text(
                          '1 $crypto = ? $selectedCurrency',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? androidPicker() : iOSPicker(),
          ),
        ],
      ),
    );
  }
}
