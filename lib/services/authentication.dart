import 'package:aibirdie/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> signInWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

    final FirebaseAuth fbAuth = FirebaseAuth.instance;

    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    final AuthResult authResult = await fbAuth.signInWithCredential(credential);

    final FirebaseUser fbUser = authResult.user;
    if (authResult.additionalUserInfo.isNewUser) {
      await addNewUser(
        {
          'userName': googleUser.displayName,
          'userEmail': googleUser.email,
          'userNotes': [],
        },
        fbUser.uid,
      );
      // print("New users");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('SignInStatus', true);
    prefs.setString('userID', fbUser.uid);
    prefs.setString('userName', googleUser.displayName);
    prefs.setString('userEmail', googleUser.email);
    prefs.setString('userPhotoUrl', googleUser.photoUrl);

    print("Signed in: ${fbUser.displayName}");
    signedIn = true;
  } catch (e) {}
}

Future<void> addNewUser(Map<String, dynamic> userData, String userID) async {
  await Firestore.instance
      .collection('users')
      .document('$userID')
      .setData(userData);
  await Firestore.instance
      .collection('users')
      .document('$userID')
      .collection('userChecklists')
      .document('INIT')
      .setData({});


  //  .add({'birds':[
  //   {
  //     'birdName':'birdName',
  //     'checked':'checked',
  //   }
  // ]});
}

Future<void> signOut() async {
  try {
    GoogleSignIn gsi = GoogleSignIn(scopes: ["email"]);
    await gsi.signOut();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool('SignInStatus', false));
    signedIn = false;
  } catch (e) {
    print("Error: $e");
  }
}
