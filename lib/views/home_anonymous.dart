import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeAnonoymous extends StatelessWidget {
  HomeAnonoymous({super.key});
  final Uri _url = Uri.parse('https://www.facebook.com/infspmChlef');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: "Inter", useMaterial3: true),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              leading: const Icon(Icons.face_unlock_rounded),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.flight),
                    text: "Parafacile",
                  ),
                  Tab(
                    icon: Icon(Icons.directions_transit),
                    text: "INFSPM",
                  ),
                  Tab(icon: Icon(Icons.contact_page),text: "Contacter",),
                ],
              ),
              title: const Text('A propos'),
            ),
            body: TabBarView(
              children: [
                const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          "Le rôle du INFSPM est de faciliter l'apprentissage en aidant les étudiants à assimiler de nouvelles connaissances, à les appliquer dans la pratique et à adopter des attitudes qui sont au cœur de la profession infirmière combler les lacunes et assurer des soins conformes aux normes de sécurité et de bien-être des patients Il est fondamental de prendre en compte les préférences des apprenants par rapport aux styles d'apprentissage dans la pratique pédagogique afin de guider les enseignants en soins infirmiers dans leur mission de développer des stratégies d'enseignement efficaces Nous devons obtenir mieux comprendre notre diversité d'étudiants grâce à une description de leurs styles d'apprentissage qui sert à diagnostiquer et à identifier les difficultés d'apprentissage, afin de prévenir davantage l'échec à acquérir et à assimiler les connaissances. Les enseignants en soins infirmiers peuvent aider les étudiants à identifier leurs préférences personnelles en relation avec le style d'apprentissage, créer des activités adaptées aux préférences des élèves en matière de style d'apprentissage et assurer des opportunités d'apprentissage qui correspondent aux styles d'apprentissage préférés."),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          "L’Institut  National de Formation Supérieure Paramédicale De Hay Ben Souna-Chlef a été ouvert depuis 23 mai 2021 se situe à  la commune de Chlef Hay Bensouna nouvelle ville wilaya de Chlef, il contient 21 personnel employé et 53 personnel enseignant"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('images/org.png'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Rester proche de nous , Vous pouvez consultez vos emplois du temps tous les semaines dans notre page Facebook"),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.facebook,
                        size: 300,
                        color: Color(0xff4267B2),
                      ),
                      onPressed: () async {
                        if (!await launchUrl(_url)) {
                          throw Exception('Could not launch $_url');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
