import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(MyApp());

//Constant Variables
final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
  fontSize: 18.0
);

final kBoxDecorationStyle = BoxDecoration(
  // color: Color(0xFF6CA8F1),
  color: Colors.green,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: Login.id,
      routes: {
        Login.id: (context) => Login(),
        Chat.id: (context) => Chat()
      },
    );
  }
}


class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  const CustomButton({Key key, this.callback, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: callback,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.green,
        child: Text(
          text,
          style: TextStyle(
              // color: Color(0xFF527DAA),
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
        ),
      ),
    );
  }
}


class Login extends StatefulWidget {
  static const String id = "LOGIN";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;

  //My Code
  Future<void> loginUser() async {
    final String user = email;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user: user,
        ),
      ),
    );
  }

  _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            onChanged: (value) => email = value,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.person, color: Colors.white),
              hintText: 'Enter Your Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            onChanged: (value) => password = value,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Colors.white, fontFamily: 'OpneSans'),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.phone, color: Colors.white),
              hintText: 'Phone Number',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Color(0xFF73AEF5),
            //     Color(0xFF61A4F1),
            //     Color(0xFF4780E0),
            //     Color(0xFF398AE5),
            //   ],
            //   stops: [0.1, 0.4, 0.7, 0.9],
            // )
            color: Colors.green
            ),
          ),
          Container(
            height: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Opensans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(height: 30.0),
                      _buildPasswordTF(),
                      CustomButton(
                        text: 'Get Started',
                        callback: () async {
                          await loginUser();
                        },
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class Chat extends StatefulWidget {
  static const String id = "CHAT";
  final Object user;

  const Chat({Key key, this.user}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  void addToFirebase() {
    _firestore.collection("test").add({
      'text': messageController.text,
      'from': widget.user,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
    });
    messageController.clear();
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _callback() async {
    if (messageController.text.trim().length > 0) {
      await this.addToFirebase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: 'log',
          child: Container(
            height: 40.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () => {
                Navigator.of(context).popUntil((route) => route.isFirst),
              }
            ),
          ),
        ),
        title: Text('Donal Chat'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('test')
                    .orderBy('timestamp', descending: true)
                    .limit(10000)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  List<Widget> messages = docs
                      .map((doc) => Message(
                            from: doc.data['from'],
                            text: doc.data['text'],
                            me: widget.user == doc.data['from'],
                          ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                    reverse: true,
                  );
                },
              ),
            ),
            Container(
              color: Colors.green.withOpacity(0.2),
              child: Row(
                children: <Widget>[
                  
                  new Flexible(
                    child:  Form(
                      // key: _formKey,
                      // This thing goes to the bottom
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 10.0, top: 20.0, bottom: 20.0),
                        child: Material(
                          color: Colors.teal.withBlue(133),
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(25.0),
                          child: TextFormField(
                            validator: (String text) {
                              if (text.isEmpty) {
                                return;
                              }
                            },
                            controller: messageController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 12.0),
                                hintText: 'Type message here...',
                                hintStyle: TextStyle(color: Colors.white70)),
                          ),
                        ),
                      ),
                    )
                  ),
                  new Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FloatingActionButton(
                  mini: true,
                  tooltip: 'Send',
                  backgroundColor: Colors.green,
                  child: Center(
                      child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20.0,
                  )),
                  onPressed: () => _callback(),
                ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String text;
  final String from;

  final bool me;

  const Message({Key key, this.text, this.from, this.me}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.withOpacity(0.2),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Card(
            color: me ? Colors.green.withOpacity(0.9) : Colors.teal.withBlue(133),
            elevation: 6.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      from != null ? from : 'Unkown',
                      textAlign: TextAlign.left,
                      style:TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 200.0,
                    ),
                    child: Text(
                      text,
                      style:TextStyle(
                        fontSize: 18
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
