import 'package:contact_app/Model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

class MyScopedModel extends Model {
  bool _isLoading = false;
  bool get isLoading => this._isLoading;

  Future<Map<String, dynamic>> registerUser(UserModel user) async {
    _isLoading = true;
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      User loggedInUser = result.user;
      _isLoading = false;
      return {'success': true, 'message': 'Logged In Success'};
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      return {'success': false, 'message': e.message};
    }
    //      String uid = loggedInUser.uid;
  }
}
