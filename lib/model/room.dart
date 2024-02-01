import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String uid;
  DateTime createdAt;
  String type;
  DateTime updatedAt;
  List<String> userIds;

  Room({
    this.uid="reportes",
    required this.createdAt,
    this.type = 'direct',
    required this.updatedAt,
    required this.userIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid' : uid,
      'createdAt': Timestamp.fromDate(DateTime.parse(createdAt.toString())),
      'type': type,
      'updatedAt': Timestamp.fromDate(DateTime.parse(updatedAt.toString())),
      'userIds': userIds,
    };
  }

  static Room fromMap(Map<String, dynamic> map) {
    return Room(
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      type: map['type'] ?? 'direct',
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      userIds: (map['userIds'] as List).cast<String>(),
    );
  }

  Future<void> createRoom() async {
    await FirebaseFirestore.instance.collection('rooms').add(toMap());
  }

  static Stream<List<Room>> getRooms() {
    return FirebaseFirestore.instance.collection('rooms').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
