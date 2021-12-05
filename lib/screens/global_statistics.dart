import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/global_summary.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'global.loading.dart';

class GlobalStatistics extends StatelessWidget {
  final GlobalSummaryModel summary;

  GlobalStatistics({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildCard(
          'CONFIRMADOS',
          summary.totalConfirmed,
          summary.newConfirmed,
          kConfirmedColor,
        ),
        buildCard(
          'ATIVOS',
          summary.totalConfirmed - summary.totalRecovered - summary.totalDeaths,
          summary.newConfirmed - summary.newRecovered - summary.newDeaths,
          kActiveColor,
        ),
        buildCard(
          'CURADOS',
          summary.totalRecovered,
          summary.newRecovered,
          kRecoveredColor,
        ),
        buildCard(
          'MORTES',
          summary.totalDeaths,
          summary.newDeaths,
          kDeathColor,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(
            'Estatísticas atualizadas ' +
                timeago.format(summary.date, locale: 'en_short') +
                ' atrás',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        )
      ],
    );
  }

  Widget buildCard(String title, int totalCount, int todayCount, Color color) {
    return Card(
      elevation: 1,
      child: Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        totalCount
                            .toString()
                            .replaceAllMapped(reg, mathFunc as dynamic),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hoje',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        todayCount
                            .toString()
                            .replaceAllMapped(reg, mathFunc as dynamic),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      )
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
