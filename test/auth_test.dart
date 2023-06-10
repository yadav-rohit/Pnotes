import 'package:pnotes/services/auth/auth_exceptions.dart';
import 'package:pnotes/services/auth/auth_provider.dart';
import 'package:pnotes/services/auth/auth_user.dart';
import 'package:test/test.dart';
void main(){
group('Mock_Authentication', ()
{
  final Provider = MockAuthProvider();
  test('should not be initialized to begin with', () {
    expect(Provider.isInitialized, false);
  });
  test('cannot log out if not initialized', () async {
    expect(Provider.signOut(),
    throwsA(const TypeMatcher<NotInitializedAuthException>()),
    );
  });

  test('should be able to be initialized' , () async {
    await Provider.initialize();
    expect(Provider.isInitialized, true);
  });

  test('user should be null after initialization', () {
    expect(Provider.currentUser, null);
  });

  test('should be able to initialize in less than 2 seconds', () async {
    await Provider.initialize();
    expect(Provider.isInitialized, true);
  },
  timeout: const Timeout(Duration(seconds: 2)),
  );
  test('create user should delegate to login function', () async {
    final BadEmailUser  = Provider.createUser(email: 'rohityadav@gmail.com', password: 'anything');
  expect(BadEmailUser,
  throwsA(const TypeMatcher<userNotFoundAuthException>())
  );

  final BadPasswordUseer = Provider.createUser(email: 'anyemail@gmail,com', password: "123456");
  expect(BadPasswordUseer,
  throwsA(const TypeMatcher<WeakPasswordAuthException>())
  );
  
  final user = await Provider.createUser(email: 'rohityadav', password: 'beep');
  expect(Provider.currentUser, user);
  expect(user?.isEmailVerified, false);
  });

  test('Logged in user should be able to get verified', () {
    Provider.sendEmailVerification();
    final user = Provider.currentUser;
    expect(user, isNotNull);
    expect(user!.isEmailVerified, true);
  });


  test('Should be able to log out and log in again', () async {
    await Provider.signOut();
    await Provider.logIn(
      email: 'email',
      password: 'password',
    );
    final user = Provider.currentUser;
    expect(user, isNotNull);
  });

});

}
class NotInitializedAuthException implements Exception{}
class MockAuthProvider implements AuthProvider {
  AuthUser? _user ;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }


  @override
  Future<AuthUser?> createUser({required String email, required String password})
  async{
    if(!isInitialized) throw NotInitializedAuthException();
      await Future.delayed(const Duration(seconds: 1));
      return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser?> logIn({required String email, required String password}) {
 if(!isInitialized) throw NotInitializedAuthException();
 if(email == 'rohityadav@gmail.com') throw userNotFoundAuthException();
 if(password == '123456') throw WeakPasswordAuthException();
 const user = AuthUser(isEmailVerified: false);
 _user = user;
 return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async{
    if(!isInitialized) throw NotInitializedAuthException();
    final user = _user;
    if(user == null) throw userNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
   _user = newUser;
  }


  @override
  Future<void> signOut() async{
    if(!isInitialized) throw NotInitializedAuthException();
    if(_user==null) throw userNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }
}