import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parafacile/constants.dart';
import 'package:parafacile/views/message_line.dart';


class ChatScreen extends StatefulWidget {
  ChatScreen({required this.id});
  late String? id;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
   late User signedInUser;

  String? messageText;
  String? nomComplet;

  @override
  void initState() {
    getCurrentUser();
    getNomPrenom();
    // getMessages();
    getMessages();
    super.initState();
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<void> getMessages()  async {
  //  final messages = await FirebaseFirestore.instance.collection("messages").get();
  //  for(var message in messages.docs) {
  //    print(message.data());
  //  }
  // }
  var _firestore = FirebaseFirestore.instance;
  getMessages() async {
    await for (var snapshot
        in FirebaseFirestore.instance.collection("messages").snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
      ;
    }
  }

  var CurrentUserId = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .id;

  Future<void> getNomPrenom() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(CurrentUserId)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      String nom = await data['nom'];
      String prenom = await data['prenom'];
      setState(() {
        nomComplet = "$nom $prenom";
        print("le nom complet es $nomComplet");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 25),
            const SizedBox(width: 10),
            const Text('Espace Chat')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("messages")
                    .where("idClassRoom", isEqualTo: widget.id). orderBy('time')
                    .snapshots(),

                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  List<MessageLine> messagesWidgets = [];

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return Center(child: Padding(
                    //   padding: const EdgeInsets.only(top:100),
                    //   child: CircularProgressIndicator(),
                    // ));
                  }

                  if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Handle any error that occurred
                  }

                  if (snapshot.hasData) {
                    final messages = snapshot.data!.docs.reversed.forEach((message) {
                      final messageText = message.get('message');
                      final sender = message.get('sender');
                      final nom = message.get('nomComplet');
                      final currentUser = signedInUser.email;


                      final messageWidget = MessageLine(
                          messageText: messageText,
                          nomComplet: nom,
                          email: sender,
                          isMe:currentUser == sender ? true : false ,);
                      messagesWidgets.add(messageWidget);
                    });

                    // for (var message in messages) {
                    //   final messageText = message.get('message');
                    //   final sender = message.get('sender');
                    //   final nom = message.get('nomComplet');
                    //   final messageWidget = Text("$nom -- $messageText");
                    //   messagesWidgets.add(messageWidget);
                    // }
                  }

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      children: messagesWidgets,
                    ),
                  );
                }),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: kBackgroundColor!,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) async {
                        setState(() {
                          messageText = value;
                        });
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Ecrire votre message ici',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final _firestore = await FirebaseFirestore.instance
                          .collection("messages")
                          .add({
                        'message': messageText,
                        'sender': signedInUser.email,
                        'idClassRoom': widget.id,
                        'nomComplet': nomComplet,
                        'time': FieldValue.serverTimestamp()
                      });
                      messageController.clear();
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: kBackgroundColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageLine extends StatelessWidget {
  MessageLine(
      {required this.nomComplet,
      required this.messageText,
      this.email,
      required this.isMe,
      super.key});
  final String? nomComplet;
  final String? messageText;
  final String? email;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$nomComplet",
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 236, 166, 145),
                fontSize: 12),
          ),
          Material(
              elevation: 6,
              borderRadius:isMe? const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)) :
                  const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30)) ,
              color: isMe ? kBackgroundColor : kGreenColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Text(
                  "$messageText",
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}
