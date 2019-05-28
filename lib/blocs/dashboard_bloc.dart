import 'package:firebase_auth/firebase_auth.dart';
import 'package:peng_u/resources/repository.dart';

class DashboardBloc {
  final _repository = Repository();

  /// methods checks if the current FirebaseAuthUser is already in FirestoreUserCollection and create a new user if needed

  Future<void> createNewFirestoreCollectionUser() async {
    String firebaseUserId = await _repository.getCurrentFirebaseUserId();
    if (await _repository.checkUserExistInFirestoreCollection(firebaseUserId)) {
      print('user exists already in Firestore Collection');
    } else {
      FirebaseUser firebaseUser = await _repository.getCurrentFirebaseUser();
      await _repository.createUserWithFirebaseUser(firebaseUser);
      print('user added to firestore user collection');
    }
  }


  Stream userEventStream () {

  }
}
