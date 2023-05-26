import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parafacile/constants.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({required this.id});
  late String? id;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  String? messageText;

  @override
  void initState() {
    getCurrentUser();
    // getMessages();
    getMessages();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
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
  
  getMessages () async{
     await for ( var snapshot in FirebaseFirestore.instance.collection("messages").snapshots()) {

        for(var message in snapshot.docs) {
            print(message.data());

     };
        
  }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenColor,
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 25),
            const SizedBox(width: 10),
            const Text('MessageMe')
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
              stream: FirebaseFirestore.instance.collection("messages").snapshots(),
            builder: (context,snapshot) {
              List<Text> messagesWigdets = [];
              if(!snapshot.hasData) {
                // mba3d nzid loading
              }
              final messages = snapshot.data!.docs;
              for(var message in messages) {
                message.get('message');
              }
              if (snapshot.hasError) {
                print("error in snapshot");
              }
              return Text("hhhdfs");
            },
            ),
            Container(),
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
                        hintText: 'Write your message here...',
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
                        'idClassRoom': widget.id
                      });
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
