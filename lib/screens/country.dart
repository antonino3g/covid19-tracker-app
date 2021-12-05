import 'package:app_test/services/covid_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_test/models/country.dart';
import 'package:app_test/models/country_summary.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

CovidService covidService = CovidService();

class Country extends StatefulWidget {
  const Country({Key? key}) : super(key: key);

  @override
  _CountryState createState() => _CountryState();
}

class _CountryState extends State<Country> {
  final TextEditingController _typeAheadController = TextEditingController();
  Future<List<CountryModel>>? countryList;
  Future<List<CountrySummaryModel>>? summaryList;

  @override
  void initState() {
    super.initState();

    countryList = covidService.getCountryList();
    summaryList = covidService.getCountrySummary('brazil');

    this._typeAheadController.text = 'Brazil';
  }

  List<String> _getSuggestions(List<CountryModel> list, String query) {
    List<String> matches = [];

    for (var item in list) {
      matches.add(item.country);
    }

    matches.retainWhere(
        (element) => element.toLowerCase().contains(query.toLowerCase()));

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: countryList,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text('Error'),
          );
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Text('Loading'),
            );
          default:
            return !snapshot.hasData
                ? Center(
                    child: Text('Empty'),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                        child: Text(
                          'Casos de Corona Vírus por País',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _typeAheadController,
                          decoration: InputDecoration(
                            hintText: 'Escreva o nome do país aqui',
                            hintStyle: TextStyle(
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: EdgeInsets.all(20),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 24, right: 16),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return _getSuggestions(
                              snapshot.data as dynamic, pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion as dynamic),
                          );
                        },
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (suggestion) {
                          this._typeAheadController.text =
                              suggestion as dynamic;
                          setState(() {
                            summaryList = covidService.getCountrySummary(
                                (snapshot.data as dynamic)
                                    .firstWhere((element) =>
                                        element.country == suggestion)
                                    .slug);
                          });
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FutureBuilder(
                        future: summaryList,
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return Center(
                              child: Text('Error'),
                            );
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                child: Text('Loading'),
                              );
                            default:
                              return !snapshot.hasData as dynamic
                                  ? Center(
                                      child: Text('Empty'),
                                    )
                                  : Center(
                                      child: Text('Data is here'),
                                    );
                          }
                        },
                      ),
                    ],
                  );
        }
      },
    );
  }
}
