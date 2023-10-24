import 'dart:async';

import '../../flutter_flow/chat/index.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';


class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "area" field.
  String? _area;
  String get area => _area ?? '';
  bool hasarea() => _area != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "bio" field.
  String? _bio;
  String get bio => _bio ?? '';
  bool hasBio() => _bio != null;

  // "isHost" field.
  bool? _isHost;
  bool get isHost => _isHost ?? false;
  bool hasIsHost() => _isHost != null;



  // "numberActiveBookings" field.
  int? _numberActiveBookings;
  int get numberActiveBookings => _numberActiveBookings ?? 0;
  bool hasNumberActiveBookings() => _numberActiveBookings != null;

  void _initializeFields() {
    _area = snapshotData['area'] as String?;
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['nombre'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['telefono'] as String?;
    _bio = snapshotData['bio'] as String?;
    _isHost = snapshotData['isHost'] as bool?;

  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  toChatUser(bool bool) {}
}

Map<String, dynamic> createUsersRecordData({
  String? area,
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? bio,
  bool? isHost,

}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'area': area,
      'email': email,
      'nombre': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'telefono': phoneNumber,
      'bio': bio,
      'isHost': isHost,

    }.withoutNulls,
  );

  return firestoreData;
}
