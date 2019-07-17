import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peng_u/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class AddFriendsBloc {
  final _repository = Repository();

  BehaviorSubject<List> _tempSearchStore = BehaviorSubject(seedValue: []);
  BehaviorSubject<List> _resultSearchStore = BehaviorSubject(seedValue: []);

  Observable<List> get tempSearchStoreStream => _tempSearchStore.stream;

  List get tempSearchStore => _tempSearchStore.value;

  Observable<List> get resultSearchStoreStream => _resultSearchStore.stream;

  List get resultSearchStore => _resultSearchStore.value;

  void dispose() async {
    await _tempSearchStore.drain();
    _tempSearchStore.close();
    await _resultSearchStore.drain();
    _resultSearchStore.close();
  }

  initiateSearch(value) {
    var list = [];
    if (value.length == 0) {
      _tempSearchStore.add([]);
      _resultSearchStore.add([]);
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (resultSearchStore.length == 0 && value.length == 1) {
      _repository
          .getUserDocumentsFromFirestoreBySearchKey(searchKey: value)
          .then((QuerySnapshot docs) {
        docs.documents.forEach((snap) {
          list.add(snap.data);
          _resultSearchStore.add(list);
        });
      });
    }else{
      _tempSearchStore.add([]);
      var list = [];
      resultSearchStore.forEach((element){
        if(element['firstName'].startsWith(capitalizedValue)) {
          list.add(element);
          _tempSearchStore.add(list);
        }
      });

    }
  }
}
