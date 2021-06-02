import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_bitcoin_ticker/coin_data.dart';
import 'package:throttling/throttling.dart';
import 'package:universal_io/io.dart' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int initialIndex = 0;
  List rateList = [];

  final deb = Debouncing(duration: const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();
    initRateList();
    getRateData();

    initialIndex = currenciesList.indexOf(selectedCurrency);
  }

  void initRateList() {
    rateList = cryptoList
        .map((crypto) => {
              'asset': crypto,
              'rate': '?',
            })
        .toList();
  }

  void getRateData() async {
    rateList = await Future.wait(cryptoList.map((crypto) async {
      var data = await CoinData().getCurrencyRate(crypto, selectedCurrency);
      return {
        'asset': crypto,
        'rate': data == null ? '-' : data['rate'].toStringAsFixed(0),
      };
    }).toList());

    print(rateList);

    // update view
    setState(() {});
  }

  void updateCurrency(String? currencyName) {
    if (currencyName == null) {
      return;
    }

    setState(() {
      selectedCurrency = currencyName;
      initRateList();
    });
    deb.debounce(() {
      print(selectedCurrency);
      getRateData();
    });
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
        scrollController: FixedExtentScrollController(
          initialItem: initialIndex,
        ),
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
              children: rateList
                  .map(
                    (cryptoRate) => Card(
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
                          '1 ${cryptoRate['asset']} = ${cryptoRate['rate']} $selectedCurrency',
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
