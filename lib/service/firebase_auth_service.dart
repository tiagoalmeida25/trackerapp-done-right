import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> login(String email, String password) {
    return _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) => user.user);
  }

  Future<User?> signUp(String email, String password, String username) async {
    final user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.user!.uid)
        .set({'username': username});
    return user.user;
  }

  Future<String> getUsername(User user) async {
    final docs =
        await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
    return docs.data()?['username'];
  }

  Future<void> sendEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
