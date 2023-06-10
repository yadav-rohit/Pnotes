import 'package:firebase_core/firebase_core.dart';
import 'package:pnotes/firebase_options.dart';
import 'package:pnotes/services/auth/auth_user.dart';
import 'package:pnotes/services/auth/auth_provider.dart';
import 'package:pnotes/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser?> createUser({required String email, required String password}) async {
    try{
     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    final user = currentUser;
    if(user!= null){
      return user;
    }
    else {
      throw userNotFoundAuthException();
    }
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
         throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
         throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
          throw InvalidEmailAuthException();
        }
      else {
        throw GenericAuthException();
      }
    }catch (_){
      throw GenericAuthException();
    }
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser  {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    } else {
      return AuthUser.fromFirebaseUser(user);
    }
  }

  @override
  Future<AuthUser?> logIn({required String email, required String password}) async {
    try{
     await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
     final user = currentUser;
     if(user!= null){
       return user;
     }
     else {
       throw userNotFoundAuthException();
     }
    }on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
         throw userNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
         throw WrongPasswordAuthException();
      } else if (e.code == 'invalid-email') {
          throw InvalidEmailAuthException();
        }
      else {
        throw GenericAuthException();
      }
    }
    catch(_){}
  }

  @override
  Future<void> sendEmailVerification() {
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null) {
        return user.sendEmailVerification();
    }
    else{
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> signOut() async{
   final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      await FirebaseAuth.instance.signOut();
    }
    else{
      throw UserNotLoggedInAuthException();
    }
  }



}