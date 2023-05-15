import 'package:flutter/material.dart';
import 'package:parafacile/views/login.dart';
import 'package:parafacile/views/register.dart';

import '../widgets/custom_button.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("ParaFacile",
              style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Votre apprentissage est devenu plus facile Accedez aux vos cours et devoirs maintenant",
              style: TextStyle(color: Color(0xffBBBBBB)),
            ),
          ),
          const SizedBox(
            height: (50),
          ),
          CustomButton(
              title: "Commencer",
              textColor: const Color(0xff2F2D52),
              backgroundColor: const Color(0xff8EE5DB),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Register()));
              }),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
              title: "Identifier",
              textColor: Colors.white,
              backgroundColor: const Color(0xff595773),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  Login()));
              }),
        ]);
  }
}
