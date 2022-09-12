import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:flutter/material.dart';

class CriticalErrorWidget extends StatelessWidget {
  static const _debug = false;
  final String message;
  final Future<dynamic> Function() refresh;
  const CriticalErrorWidget({
    Key? key,
    required this.message,
    required this.refresh,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // это оцентрирует по верикали
        children: <Widget>[
          Text(
            const AppText('Reading data error').local,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 4,),
          TextButton(
            onPressed: () {
              log(_debug, 'Please Implemente the Sending email on critical error');
            }, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mail),
                const SizedBox(width: 4,),
                Text(
                  const AppText('Send error report').local,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              refresh();
            }, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh),
                const SizedBox(width: 4,),
                Text(
                  const AppText('Reload').local,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
