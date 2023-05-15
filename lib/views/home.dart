import 'package:flutter/material.dart';
import 'package:parafacile/views/home_body.dart';


import '../constants.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: HomeBody(),
    );
  }
}
