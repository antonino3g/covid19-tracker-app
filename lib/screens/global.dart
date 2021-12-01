import 'package:flutter/material.dart';
import '../services/covid_service.dart';
import '../models/global_summary.dart';
import '../screens/global_statistics.dart';

CovidService covidService = CovidService();

class Global extends StatefulWidget {
  const Global({Key? key}) : super(key: key);

  @override
  _GlobalState createState() => _GlobalState();
}

class _GlobalState extends State<Global> {
  Future<GlobalSummaryModel>? summary; // summary is nullable

  @override
  void initState() {
    super.initState();
    summary = covidService.getGlobalSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Casos de COVID-19 no Mundo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: summary,
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text('Error'),
              );
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Text('Carregando'),
                );
              default:
                return !snapshot.hasData
                    ? Center(
                        child: Text("Empty"),
                      )
                    : GlobalStatistics(
                        summary: snapshot.data as dynamic,
                      );
            }
          },
        )
      ],
    );
  }
}
