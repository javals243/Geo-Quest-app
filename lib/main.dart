//import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GeoQuest());
}

Color clouds = HexColor("#ecf0f1");
Color was = HexColor("#34495e");
Color nephertis = HexColor('#27ae60');
Color silver = HexColor('#bdc3c7');

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}

class PlayerDatas {
  String name = "";
  int score = 0;
  Exercice currentEx = Exercice(-1, -1, []);

  PlayerDatas(String name, int score) {
    this.name = name;
    this.score = score;
  }
  void changeCurrentEx(Exercice currentEx) {
    this.currentEx = currentEx;
  }
}

class Exercice {
  int typeEx = -1;
  int noEx = -1;
  List<double> datas = <double>[];
  Exercice(typeEx, noEx, List<double> datas) {
    this.typeEx = typeEx;
    this.noEx = noEx;
    this.datas = datas;
  }
}

class Players {
  List<PlayerDatas> players = [];
}

List<Widget> datas(Players list, length) {
  List<Widget> leaderboard = <Widget>[];
  Color col = clouds;
  //i<5, pass your dynamic limit as per your requirment
  for (int i = 0; i < length; i++) {
    int k = i + 1;

    if (i % 2 == 0) {
      col = clouds;
    } else {
      col = silver;
    }
    leaderboard.add(Container(
        color: col,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "#$k",
              style: TextStyle(fontFamily: "Chalk", color: was),
            ),
            Text(
              list.players[i].name,
              style: TextStyle(fontFamily: "Chalk", color: was),
            ),
            Text(
              list.players[i].score.toString(),
              style: TextStyle(fontFamily: "Chalk", color: was),
            )
          ],
        ))); //add any Widget in place of Text("Index $i")
  }
  return leaderboard; // all widget added now retrun the list here
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

class Buttons {
  static Widget PrimaryButton(String text, onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: was,
        onPrimary: was,
        minimumSize: const Size(100, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: clouds),
      ),
    );
  }

  static Widget SecondaryButton(String text, onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: clouds,
        onPrimary: clouds,
        side: BorderSide(color: was, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(100, 50),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: was),
      ),
    );
  }

  static Widget OptionButton(onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.settings),
      foregroundColor: clouds,
      backgroundColor: was,
    );
  }
}

class Fields {
  static Widget CustomTextFormField(label, hint, icon, error, controller) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              filled: true,
              fillColor: clouds,
              suffixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: was,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: was,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              labelText: label,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: TextStyle(
                color: was,
                fontStyle: FontStyle.italic,
              ),
              hintText: hint),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return error;
            }
            return null;
          },
        ));
  }
}

PlayerDatas player = PlayerDatas("", 0);

class GeoQuest extends StatelessWidget {
  const GeoQuest({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoQuest',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: generateMaterialColor(nephertis),
      ),
      home: const SignInPage(),
    );
  }
}

class ExPage extends StatefulWidget {
  const ExPage({Key? key}) : super(key: key);

  @override
  State<ExPage> createState() => _ExPageState();
}

class _ExPageState extends State<ExPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          if (details.delta.dx > 0) {
            Navigator.pop(context, true);
          }
        },
        child: const Ex(),
      ),
      backgroundColor: nephertis,
    );
  }
}

class Ex extends StatefulWidget {
  const Ex({Key? key}) : super(key: key);

  @override
  ExState createState() {
    return ExState();
  }
}

int getNoEx(int typeEx) {
  int max = 0;
  switch (typeEx) {
    case 0:
      max = 9;
      break;
    case 1:
      max = 15;
      break;
    case 2:
      max = 7;
      break;
  }
  int noEx = 0; //Random().nextInt(max);
  return noEx;
}

List<double> generateDatas(int typeEx, int noEx) {
  List<double> res = [];
  if (typeEx == 0) {
    // perimetre
    switch (noEx) {
      case 0:
        res.add(Random().nextInt(100) + 20.0);
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
    }
  } else if (typeEx == 1) {
    // aire/surface
    switch (noEx) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
    }
  } else {
    // volume
    switch (noEx) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
    }
  }
  return res;
}

class ExState extends State<Ex> {
  // TODO : lire les données de la question
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  String path = 'assets/images/ex1.png';
  Exercice currentEx = player.currentEx;
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  final resController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (currentEx.typeEx == -1) {
      int typeEx = 0; //Random().nextInt(3);
      int noEx = getNoEx(typeEx);
      List<double> datasEx = generateDatas(typeEx, noEx);
      currentEx = Exercice(typeEx, noEx, datasEx);
      player.changeCurrentEx(currentEx);
    }
    String text = "";
    if (currentEx.typeEx == 0) {
      text = "PERIMETRE";
    } else if (currentEx.typeEx == 1) {
      text = "AIRE / SURFACE";
    } else if (currentEx.typeEx == 2) {
      text = "VOLUME";
    }

    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          'SCORE :' + player.score.toString(),
          style: TextStyle(fontFamily: 'Chalk', fontSize: 15, color: clouds),
        ),
        Image.asset('assets/images/logo_s.png'),
      ]),
      Text(text,
          style: TextStyle(fontFamily: "Chalk", color: clouds, fontSize: 30)),
      getEx(player.currentEx),
      Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            Text('REPONSE = ',
                style: TextStyle(fontFamily: "Chalk", color: clouds)),
            Fields.CustomTextFormField(
                'Réponse',
                "Entrez votre réponse",
                Icons.border_color_outlined,
                "Ce n'est pas la bonne réponse !",
                resController),
            Buttons.PrimaryButton('Valider', () {})
          ])),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Buttons.OptionButton(() {
              Navigator.pop(context, true);
            }),
          )
        ],
      )
    ]);
  }
}

String getPath(int typeEx, int noEx) {
  String path = "";
  if (typeEx == 0) {
    if (noEx == 0) {
      path = 'assets/images/ex1.png';
    }
  }
  return path;
}

List<Widget> getDatas(datas) {
  List<Widget> res = [];
  for (var data in datas) {
    res.add(Buttons.SecondaryButton("r : " + data.toString(), () {}));
  }
  return res;
}

String getDescription(datas) {
  String res = "Cercle de " + datas[0].toString() + " de rayon";
  return res;
}

Widget getEx(Exercice ex) {
  return Expanded(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: clouds,
            border: Border.all(
              color: was,
              width: 3,
            ),
          ),
          child: Image.asset(getPath(ex.typeEx, ex.noEx))),
      Text(getDescription(ex.datas)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: getDatas(ex.datas),
      ),
    ],
  ));
}

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          if (details.delta.dx > 0) {
            Navigator.pop(context, true);
          }
        },
        child: const Leaderboard(),
      ),
      backgroundColor: nephertis,
    );
  }
}

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  LeaderboardState createState() {
    return LeaderboardState();
  }
}

class LeaderboardState extends State<Leaderboard> {
  Players players = Players();

  @override
  Widget build(BuildContext context) {
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    for (int i = 0; i < 500; i++) {
      players.players.add(PlayerDatas("$i", 500 - i));
    }
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    // TODO : Lire le leaderboard ici

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'SCORE :' + player.score.toString(),
              style:
                  TextStyle(fontFamily: 'Chalk', fontSize: 15, color: clouds),
            ),
            Image.asset('assets/images/logo_s.png'),
          ]),
          Center(
            child: Text('LEADERBOARD',
                style: TextStyle(fontFamily: "Chalk", color: clouds)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "RANK",
                style: TextStyle(fontFamily: "Chalk", color: silver),
              ),
              Text(
                "USERNAME",
                style: TextStyle(fontFamily: "Chalk", color: silver),
              ),
              Text(
                "SCORE",
                style: TextStyle(fontFamily: "Chalk", color: silver),
              )
            ],
          ),
          Expanded(
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: was,
                      width: 5,
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: datas(players, 500),
                  ))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Buttons.OptionButton(() {
                  Navigator.pop(context, true);
                }),
              )
            ],
          )
        ]);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          if (details.delta.dx > 0) {
            Navigator.pop(context, true);
          }
        },
        child: const Home(),
      ),
      backgroundColor: nephertis,
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          'SCORE :' + player.score.toString(),
          style: TextStyle(fontFamily: 'Chalk', fontSize: 15, color: clouds),
        ),
        Image.asset('assets/images/logo_s.png'),
      ]),
      Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/images/title.png'),
          Text(
            player.name.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Chalk',
              fontSize: 30,
              color: clouds,
              shadows: <Shadow>[
                Shadow(
                  offset: const Offset(5.0, 5.0),
                  blurRadius: 3.0,
                  color: was,
                ),
              ],
            ),
          ),
          Buttons.PrimaryButton("New Game", () {
            player.currentEx = Exercice(-1, -1, []);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExPage()),
            );
          }),
          Buttons.SecondaryButton("Continue", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExPage()),
            );
          }),
          Buttons.SecondaryButton("Leaderboard", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LeaderboardPage()),
            );
          })
        ],
      )),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Buttons.OptionButton(() {
              Navigator.pop(context, true);
            }),
          )
        ],
      )
    ]);
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    Color nephertis = HexColor('#27ae60');
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          if (details.delta.dx > 0) {
            Navigator.pop(context, true);
          }
        },
        child: const SignUp(),
      ),
      backgroundColor: nephertis,
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  SignUpState createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final cEmail = TextEditingController();
  final cUsername = TextEditingController();
  final cPassword1 = TextEditingController();
  final cPassword2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset('assets/images/logo.png'),
                Fields.CustomTextFormField('Email*', 'Entrez votre Email',
                    Icons.mail, 'Email nécessaire', cEmail),
                Fields.CustomTextFormField(
                    'Username*',
                    "Entrez votre nom d'utilisateur",
                    Icons.person,
                    "Nom d'utilisateur nécessaire",
                    cUsername),
                Fields.CustomTextFormField(
                    'Password*',
                    'Entrez votre mot de passe',
                    Icons.key,
                    'Mot de passe nécessaire',
                    cPassword1),
                Fields.CustomTextFormField(
                    'Password*',
                    'Réentrez votre mot de passe',
                    Icons.key,
                    'Mot de passe nécessaire',
                    cPassword2),
                Buttons.PrimaryButton('Valider', () {
                  if (_formKey.currentState!.validate() &&
                      cPassword1.text == cPassword2.text) {
                    //save the datas
                   FirebaseAuth.instance.createUserWithEmailAndPassword(email: cEmail.text, password: cPassword1.text).then((value){
                   // ignore: avoid_print
                      print("bien ajouter");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('processing datas')),
                      );
                    
            
                    }).onError((error, stackTrace){
                      // ignore: avoid_print
                      print("Error ${error.toString()}");
                    });
                  }
                }),
              ],
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Buttons.OptionButton(() {
                Navigator.pop(context, true);
              }),
            )
          ],
        )
      ],
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    Color nephertis = HexColor('#27ae60');
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: const SignIn(),
      backgroundColor: nephertis,
    );
  }
}

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  SignInState createState() {
    return SignInState();
  }
}

class SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final cUsername = TextEditingController();
  final cPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset('assets/images/logo.png'),
              Fields.CustomTextFormField(
                  'Username*',
                  "Entrez votre nom d'utilisateur",
                  Icons.person,
                  "Nom d'utilisateur nécessaire",
                  cUsername),
              Fields.CustomTextFormField(
                  'Password*',
                  "Entrez votre mot de passe",
                  Icons.key,
                  "Mot de passe nécessaire",
                  cPassword),
              Buttons.PrimaryButton('Valider', () {
                if (_formKey.currentState!.validate()) {
                  //save the datas
                  player.name = cUsername.text;
                  player.score = 1234567;
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: cUsername.text, password: cPassword.text).then((value){
                 // ignore: avoid_print
                 print("bien Ajouter");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                  }).onError((error, stackTrace){
                    // ignore: avoid_print
                    print("Error ${error.toString()}");
                  });
                }
              }),
              Buttons.SecondaryButton('Sign up', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              })
            ],
          ),
        )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Buttons.OptionButton(() {
                Navigator.pop(context, true);
              }),
            )
          ],
        )
      ],
    );
  }
}
