
import '../../model/chat_mensajes.dart';
import 'index.dart';

const kMaxChatCacheSize = 5;

class FFChatInfo {
  const FFChatInfo(this.chatRecord, [this.groupMembers]);
  final ChatsRecord chatRecord;
  final List<UsersRecord>? groupMembers;

  UsersRecord get currentUser => groupMembers!
      .where((user) => user.reference == currentUserReference)
      .first;
  Map<String, UsersRecord> get otherUsers => Map.fromEntries(
        groupMembers!
            .where((user) => user.reference != currentUserReference)
            .map((user) => MapEntry(user.reference.id, user)),
      );
  List<UsersRecord> get otherUsersList => otherUsers.values.toList();
  bool get isGroupChat => otherUsers.length > 1;

  String chatPreviewTitle() {
    if (groupMembers == null) {
      return '';
    }
    final numOthers = chatRecord.users.length - otherUsersList.length - 1;
    return otherUsersList.map((m) {
          if (m.displayName.isNotEmpty) {
            return m.displayName;
          }
          return 'Friend';
        }).join(', ') +
        (numOthers > 0
            ? ' + $numOthers other]${numOthers > 1 ? 's' : ''}'
            : '');
  }

  String chatPreviewMessage() {
    
    return 'ultimo mensaje va aqui';
  }

  
}

class FFChatManager {
  FFChatManager._();

  // Cache that will ensure chat queries are kept alive. By default we only keep
  // at most 5 chat streams in the cache.
  // ignore: unused_field
  static Map<String, Stream<List<ChatMensajes>>> _chatMessages = {};
  static Map<String, List<ChatMensajes>> _chatMessagesCache = {};
  // Keep a map from user uid to the respective chat document reference.
  static Map<String, DocumentReference> _userChats = {};
  static DocumentReference? _currentUser;

  static FFChatManager? _instance;
  static FFChatManager get instance => _instance ??= FFChatManager._();



  void setLatestMessages(
          DocumentReference chatReference, List<ChatMensajes> messages) =>
      _chatMessagesCache[chatReference.id] = messages;

  List<ChatMensajes> getLatestMessages(DocumentReference chatReference) =>
      _chatMessagesCache[chatReference.id] ?? [];



  Future<DocumentReference> _getChatReference(
    DocumentReference otherUser,
  ) async {
    // Clear the cached user chats in the event of a new user login.
    if (_currentUser != currentUserReference) {
      _userChats.clear();
      _currentUser = currentUserReference;
    }

    var chatRef = _userChats[otherUser.id];
    if (chatRef != null) {
      return chatRef;
    }

    // Determine who is userA and userB deterministically by uid.
    final users = [otherUser, currentUserReference!];
    users.sort((a, b) => a.id.compareTo(b.id));

    var chat = await queryChatsRecord(
            queryBuilder: (q) => q
                .where('user_a', isEqualTo: users.first)
                .where('user_b', isEqualTo: users.last)
                .where('users', arrayContains: currentUserReference),
            singleRecord: true)
        .first;
    // If chat already exists, cache and return it.
    if (chat.isNotEmpty) {
      _userChats[otherUser.id] = chat.first.reference;
      return chat.first.reference;
    }
    // Otherwise, ensure that in the meantime (while checking existence) the
    // chat reference has not already been created by another call. In this
    // case, it's safer to wait a second to ensure the document was created.
    chatRef = _userChats[otherUser.id];
    if (chatRef != null) {
      await Future.delayed(Duration(seconds: 1));
      return chatRef;
    }
    // Finally, create and cache a chat between these two users.
    chatRef = ChatsRecord.collection.doc();
    _userChats[otherUser.id] = chatRef;
    await chatRef.set({
      ...createChatsRecordData(
        userA: users.first,
        userB: users.last,
      ),
      'users': users,
    });
    return chatRef;
  }

  Future<ChatsRecord?> createChat(List<DocumentReference> otherUsers) async {
    final users = {currentUserReference!, ...otherUsers};
    // Group needs to have at least 3 members.
    if (users.length < 3) {
      return null;
    }
    final chatRef = ChatsRecord.collection.doc();
    final chatData = {'users': users.toList()};
    await chatRef.set(chatData);
    return ChatsRecord.getDocumentFromData(chatData, chatRef);
  }

  Future<ChatsRecord?> addGroupMembers(
      ChatsRecord? chat, List<DocumentReference> users) async {
    if (chat == null) {
      return null;
    }
    final newUsers = {...chat.users, ...users}.toList();
    // Cannot add users to a 1:1 chat.
    if (chat.users.isNotEmpty) {
      return chat;
    }
    await chat.reference.update({'users': newUsers});
 
    return chat;
  }

  Future<ChatsRecord> removeGroupMembers(
      ChatsRecord chat, List<DocumentReference> users) async {
    final newUsers = (chat.users.toSet()..removeAll(users)).toList();
    // Can't reduce group chat to fewer than 3 members.
    if (newUsers.length < 3) {
      return chat;
    }
    await chat.reference.update({'users': newUsers});
    chat.users
      ..clear()
      ..addAll(newUsers);
    return chat;
  }
}
