import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateSubscriptionScreen extends StatefulWidget {
  const CreateSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<CreateSubscriptionScreen> createState() =>
      _CreateSubscriptionScreenState();
}

class _CreateSubscriptionScreenState extends State<CreateSubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('coming soon'.tr)));
  }
}
