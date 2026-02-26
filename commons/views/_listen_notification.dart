import 'package:flutter/material.dart';

class ListenNotification extends StatefulWidget {
  const ListenNotification(this.payload, {Key? key}) : super(key: key);

  final String payload;

  @override
  State<StatefulWidget> createState() => ListenNotificationState();
}

class ListenNotificationState extends State<ListenNotification> {
  late String _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listen Notificaiton Screen with payload: ${(_payload)}'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
