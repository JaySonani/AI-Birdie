import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:package_info/package_info.dart';
import 'package:aibirdie/screens/landing_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:aibirdie/screens/Dashboard/dash.dart';
import 'package:aibirdie/screens/Dashboard/my_notes.dart';
import 'package:aibirdie/screens/Dashboard/checklist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aibirdie/services.dart/authentication.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aibirdie/screens/Dashboard/drawer/v_services.dart';
import 'package:aibirdie/screens/Dashboard/drawer/supported_species.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  TabController tc;
  SharedPreferences prefs;

  bool signedIn = false;
  bool showSpinner = false;

  String version;

  int _selectedPage = 0;
  final _pages = [
    Dash(0),
    MyNotes(),
    CheckList(),
  ];

  var appBarTitle = [
    "",
    "My Notes",
    "Checklist",
  ];

  @override
  void initState() {
    super.initState();
    tc = TabController(length: 3, vsync: this);
    getSignInStatus();
  }

  void setVersionString() async {
    PackageInfo pi = await PackageInfo.fromPlatform();
    setState(() => version = pi.version);
  }

  void getSignInStatus() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      signedIn = prefs.getBool('SignInStatus');
    });
  }

  @override
  void dispose() {
    tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(darkPurple),
          strokeWidth: 2.0,
        ),
        inAsyncCall: showSpinner,
        child: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  signedIn ? signedInWidget() : notSignedInWidget(),
                  signedIn ? Container() : signInWithGoogleButton(),
                  // Above line is temporarily commented
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: darkPurple,
                    ),
                    title: Text(
                      "About AI-Birdie",
                      style: level2softdp,
                    ),
                    onTap: (() => showAboutDialog(
                          context: context,
                          // builder: (context) {
                          //   // File pubspec = File(join(Platform.script.toFilePath(),"../pubspec.yaml"));
                          //   // print(pubspec.readAsStringSync());
                          //   return AboutDialog(
                              applicationIcon: Image.asset(
                                  'images/ornithology.png',
                                  width: 50),
                              applicationName: "AI-Birdie",
                              applicationVersion: version,
                              children: <Widget>[
                                // SizedBox(height: 15),
                                Text(
                                  "LEVERAGING THE POWER OF AI TO DEMOCRATIZE ORNITHOLOGY",
                                  textAlign: TextAlign.center,
                                  style: level2softdp,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "A mobile app for visual and acoustic classification of birds species.",
                                  textAlign: TextAlign.center,
                                  style: level2softdp,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "AI-Birdie is a breakthrough app that helps everyone with a smartphone or tablet to accurately identify birds in their backyard, local park, or nature trail—all with the tap of a button! Just hold up your phone, record the bird singing or capture the bird photo, and AI-Birdie will help you identify the species. The app’s highly sophisticated algorithms helps you accurately identify bird species and help you learn more about them. Thus, AI-Birdie is a one-stop application for all the bird watchers and wildlife enthusiasts out there in India.",
                                  textAlign: TextAlign.justify,
                                  style: level2softdp,
                                ),
                              ],
                            // );
                          // },
                        )),

                    // Alert(
                    //       context: context,
                    //       type: AlertType.info,
                    //       style: AlertStyle(
                    //           animationDuration: Duration(milliseconds: 500),
                    //           animationType: AnimationType.grow,
                    //           descStyle: level2softdp,
                    //           titleStyle: level1dp.copyWith(fontSize: 25)),
                    //       title: "AI-Birdie",
                    //       desc:
                    //           "LEVERAGING THE POWER OF AI TO DEMOCRATIZE ORNITHOLOGY\n\nA mobile app for visual and acoustic classification of birds species.\n\nAI-Birdie is a breakthrough app that helps everyone with a smartphone or tablet to accurately identify birds in their backyard, local park, or nature trail—all with the tap of a button! Just hold up your phone, record the bird singing or capture the bird photo, and AI-Birdie will help you identify the species. The app’s highly sophisticated algorithms helps you accurately identify bird species and help you learn more about them. Thus, AI-Birdie is a one-stop application for all the bird watchers and wildlife enthusiasts out there in India.",
                    //       buttons: [
                    //         DialogButton(
                    //           child: Text(
                    //             "OK",
                    //             style: level1w,
                    //           ),
                    //           color: softGreen,
                    //           onPressed: () => Navigator.pop(context),
                    //           width: 120,
                    //         )
                    //       ],
                    //     ).show()),
                  ),
                  ListTile(
                    leading: Icon(
                      // Icons.share,
                      FontAwesomeIcons.shareSquare,
                      color: darkPurple,
                    ),
                    title: Text(
                      "Tell a friend",
                      style: level2softdp,
                    ),
                    onTap: (() => Share.share(
                        "Hey! Check out this amazing app. It is called AI Birdie.")),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.mail_outline,
                      color: darkPurple,
                    ),
                    title: Text(
                      "Send us feedback",
                      style: level2softdp,
                    ),
                    onTap: () async {
                      final Email email = Email(
                        body: 'Write your feedback here.',
                        subject: 'Feedback for AI Birdie app',
                        recipients: ['jsonani98@gmail.com'],
                        isHTML: false,
                      );

                      await FlutterEmailSender.send(email);
                    },
                  ),
                  ListTile(
                    // enabled: true,
                    leading: Icon(
                      Icons.healing,
                      color: darkPurple,
                    ),
                    title: Text(
                      "Veterinary Services",
                      style: level2softdp,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => VServices()),
                      );
                    },
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SupportedSpecies(),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.format_list_bulleted,
                      color: darkPurple,
                    ),
                    title: Text(
                      "Supported Species",
                      style: level2softdp,
                    ),
                  ),
                  Spacer(),
                  signedIn
                      ? FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          // onPressed: signOut,
                          onPressed: () async {
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult == ConnectivityResult.none) {
                              Alert(
                                  context: context,
                                  title: "Network Error",
                                  type: AlertType.error,
                                  desc:
                                      "Your phone is not connected to the internet.\nCheck your connection and try again",
                                  style: AlertStyle(
                                    descStyle: level2softdp,
                                    isCloseButton: false,
                                    titleStyle: level2softdp.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  closeFunction: () {
                                    Navigator.of(context).pop();
                                  },
                                  buttons: [
                                    DialogButton(
                                      radius: BorderRadius.circular(100),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      color: softGreen,
                                      child: Text(
                                        "OK",
                                        style: level2softw,
                                      ),
                                    ),
                                  ]).show();
                              // Navigator.of(context).pop();
                            } else {
                              setState(() {
                                showSpinner = true;
                              });
                              await signOut();
                              setState(() {
                                showSpinner = false;
                                signedIn = false;
                              });
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  action: SnackBarAction(
                                      label: 'OK', onPressed: () {}),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: darkPurple,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'Signed out.',
                                    style: level2softw,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Sign out",
                            style: level2softw,
                          ),
                          color: softGreen,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: darkPurple,
            leading: _menuButton(),
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            stretch: true,
            bottom: _selectedPage == 0
                ? PreferredSize(
                    preferredSize: Size(100, 60),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      height: 40,
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        labelColor: Colors.white,
                        labelStyle: level2softdp,
                        unselectedLabelColor: Colors.white,
                        unselectedLabelStyle: level2softdp,
                        controller: tc,
                        onTap: (index) {
                          setState(() {
                            _pages[0] = Dash(index);
                          });
                        },
                        tabs: <Widget>[
                          Tab(
                            child: Text("Overview"),
                          ),
                          Tab(
                            child: Text("Image"),
                          ),
                          Tab(
                            child: Text("Audio"),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
            stretchTriggerOffset: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                appBarTitle[_selectedPage],
                style: level2softdp.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'images/5.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.7),
                        end: Alignment(0.0, 0.0),
                        colors: <Color>[
                          darkPurple.withOpacity(0.80),
                          Colors.transparent,
                          // Color(0x60000000),
                          // Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: _pages[_selectedPage],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: darkPurple,
            selectedItemColor: softGreen,
            selectedLabelStyle: level2softg.copyWith(fontSize: 12),
            currentIndex: _selectedPage,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              if (index == 3) {
                LandingPage.controller.animateToPage(1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              } else
                setState(() => _selectedPage = index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                title: Text("Dashboard"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note),
                title: Text("Notes"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.playlist_add_check),
                title: Text("Checklist"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                title: Text("Camera"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signedInWidget() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(),
      accountEmail: Text(
        "${prefs.getString('userEmail')}",
        style: level2softdp,
      ),
      accountName: Text(
        "${prefs.getString('userName')}",
        style: level2softdp.copyWith(fontWeight: FontWeight.bold),
      ),
      currentAccountPicture: Material(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: ClipOval(
              child: signedIn
                  ? Image.network(
                      "${prefs.getString('userPhotoUrl')}",
                      // loadingBuilder: (context, child, loadingProgress) =>
                      //     CircularProgressIndicator(),
                    )
                  : Container())),
    );
  }

  Widget notSignedInWidget() {
    return UserAccountsDrawerHeader(
      // onDetailsPressed: () {
      //   Scaffold.of(context).showSnackBar(SnackBar(
      //       action: SnackBarAction(label: 'OK', onPressed: () {}),
      //       shape:
      //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //       backgroundColor: darkPurple,
      //       behavior: SnackBarBehavior.floating,
      //       content: Text(
      //         'Functionality temporarily disabled. Crowd sourcing module is pending.',
      //         style: level2softw,
      //       )));
      // },
      decoration: BoxDecoration(),
      accountEmail: Text(
        "Use your google account to sign in.",
        style: level2softdp,
      ),
      accountName: Text(
        "Sign In",
        style: level1dp,
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.account_circle, size: 60, color: softGreen),
      ),
    );
  }

  Widget signInWithGoogleButton() {
    return Container(
      width: 220,
      child: RaisedButton(
        elevation: 5.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset(
              'images/google_logo.png',
              width: 25,
            ),
            // SizedBox(width: 10,),
            Text(
              "Sign In with Google",
              style: level2softdp,
            ),
          ],
        ),
        // onPressed: signIn,
        onPressed: () async {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            Alert(
                context: context,
                title: "Network Error",
                type: AlertType.error,
                desc:
                    "Your phone is not connected to the internet.\nCheck your connection and try again",
                style: AlertStyle(
                  descStyle: level2softdp,
                  isCloseButton: false,
                  titleStyle: level2softdp.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                closeFunction: () {
                  Navigator.of(context).pop();
                },
                buttons: [
                  DialogButton(
                    radius: BorderRadius.circular(100),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: softGreen,
                    child: Text(
                      "OK",
                      style: level2softw,
                    ),
                  ),
                ]).show();
            // Navigator.of(context).pop();
          } else {
            setState(() {
              showSpinner = true;
            });
            await signInWithGoogle();
            setState(() {
              showSpinner = false;
              signedIn = true;
            });
            Scaffold.of(context).showSnackBar(
              SnackBar(
                action: SnackBarAction(label: 'OK', onPressed: () {}),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: darkPurple,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  'Signed in successfully.',
                  style: level2softw,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _menuButton() {
    return Padding(
      padding: EdgeInsets.only(
        // top: 15,
        top: 0.0,
      ),
      child: RawMaterialButton(
        onPressed: (() {
          _scaffoldKey.currentState.openDrawer();
          setVersionString();
        }),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 6.0),
                height: 2.00,
                width: 22.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.00),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 6.0),
                height: 2.00,
                width: 15.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.00),
                ),
              ),
              Container(
                height: 2.00,
                // width: 11.00,
                width: 22.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.00),
                ),
              ),
            ]),
      ),
    );
  }
}
