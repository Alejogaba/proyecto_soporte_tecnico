import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/backend/backend.dart';
import 'package:stream_transform/stream_transform.dart';
import 'firebase_auth_manager.dart';

export 'firebase_auth_manager.dart';

final _authManager = FirebaseAuthManager();
FirebaseAuthManager get authManager => _authManager;

String get currentUserEmail =>
    currentUserDocument?.email ?? currentUser?.email ?? '';

String get currentUserUid => currentUser?.email ?? '';

String get currentUserDisplayName =>
    currentUserDocument?.displayName ?? currentUser?.displayName ?? '';

String get currentUserPhoto =>
    currentUserDocument?.photoUrl ?? currentUser?.photoURL ?? '';

String get currentPhoneNumber =>
    currentUserDocument?.phoneNumber ?? currentUser?.phoneNumber ?? '';

String get currentJwtToken => _currentJwtToken ?? '';

bool get currentUserEmailVerified => currentUser?.emailVerified ?? false;

/// Create a Stream that listens to the current user's JWT Token, since Firebase
/// generates a new token every hour.
String? _currentJwtToken;
final jwtTokenStream = FirebaseAuth.instance
    .idTokenChanges()
    .map((user) async => _currentJwtToken = await user?.getIdToken())
    .asBroadcastStream();

// ignore: body_might_complete_normally_nullable
DocumentReference? get currentUserReference {
   User? user = FirebaseAuth.instance.currentUser;
  print('loggedIn: $loggedIn');
  print('usuario actual logged:'+(user!=null).toString());
  // ignore: unnecessary_statements
  loggedIn ? UsersRecord.collection.doc(currentUser!.email) : null;
}

UsersRecord? currentUserDocument;
final authenticatedUserStream = FirebaseAuth.instance
    .authStateChanges()
    .map<String>((user) => user?.email ?? '')
    .switchMap(
      (email) => email.isEmpty
          ? Stream.value(null)
          : UsersRecord.getDocument(UsersRecord.collection.doc(email))
              .handleError((_) {}),
    )
    .map((user) => currentUserDocument = user)
    .asBroadcastStream();

class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({Key? key, required this.builder})
      : super(key: key);

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authenticatedUserStream,
        builder: (context, _) => builder(context),
      );
}
