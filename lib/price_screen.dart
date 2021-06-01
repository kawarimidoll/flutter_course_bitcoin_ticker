import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_bitcoin_ticker/coin_data.dart';
import 'package:universal_io/io.dart' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

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
          setState(
            () {
              if (value != null) {
                selectedCurrency = value;
              }
            },
          );
          print(value);
        },
      );

  CupertinoPicker iOSPicker() => CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          print(selectedIndex);
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
