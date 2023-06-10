import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:login2/model/usuario.dart';

import 'index.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FFChatPage extends StatefulWidget {
  final Usuario currentUsuario;

  FFChatPage({
    Key? key,
    required this.currentUsuario,
    required this.chatInfo,
    this.allowImages = false,
    // Theme settings
    this.backgroundColor,
    this.timeDisplaySetting,
    this.currentUserBoxDecoration,
    this.otherUsersBoxDecoration,
    this.currentUserTextStyle,
    this.otherUsersTextStyle,
    this.inputHintTextStyle,
    this.inputTextStyle,
    this.emptyChatWidget,
  }) : super(key: key);

  final FFChatInfo chatInfo;
  final bool allowImages;

  final Color? backgroundColor;
  final TimeDisplaySetting? timeDisplaySetting;
  final BoxDecoration? currentUserBoxDecoration;
  final BoxDecoration? otherUsersBoxDecoration;
  final TextStyle? currentUserTextStyle;
  final TextStyle? otherUsersTextStyle;
  final TextStyle? inputHintTextStyle;
  final TextStyle? inputTextStyle;
  final Widget? emptyChatWidget;

  @override
  _FFChatPageState createState() => _FFChatPageState();
}

class _FFChatPageState extends State<FFChatPage> {
  final scrollController = ScrollController();
  final focusNode = FocusNode();

  DocumentReference get chatReference => widget.chatInfo.chatRecord.reference;
  Usuario get currentUser => widget.currentUsuario;
  

  Map<String, ChatMessagesRecord> allMessages = {};
  List<ChatMessagesRecord> messages = [];
  late StreamSubscription<List<ChatMessagesRecord>> messagesStream;
  bool _initialized = false;

  DateTime? latestMessageTime() =>
      messages.isNotEmpty ? messages.last.timestamp : null;

  Future updateSeenBy() => chatReference.update({
        'last_message_seen_by': FieldValue.arrayUnion([currentUserReference])
      });

  void onNewMessage(DateTime? lastBefore, DateTime? lastAfter) {
    if (!mounted ||
        !_initialized ||
        lastAfter == null ||
        (lastBefore?.isAtSameMomentAs(lastAfter) ?? false)) {
      return;
    }
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => scrollController.jumpTo(0));
      updateSeenBy();
    });
  }

  void updateMessages(List<ChatMessagesRecord> chatMessages) {
    final oldLatestTime = latestMessageTime();
    chatMessages.forEach((m) => allMessages[m.reference.id] = m);
    messages = allMessages.values.toList();
    messages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
    onNewMessage(oldLatestTime, latestMessageTime());
    setState(() {});
  }

  StreamSubscription<List<ChatMessagesRecord>> getMessagesStream(
          DocumentReference chatReference) =>
      FFChatManager.instance.getChatMessages(chatReference).listen((m) {
        if (mounted) {
          updateMessages(m);
          FFChatManager.instance.setLatestMessages(chatReference, messages);
        }
      });

  @override
  void initState() {
    super.initState();
    updateMessages(FFChatManager.instance.getLatestMessages(chatReference));
    messagesStream = getMessagesStream(chatReference);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      updateSeenBy();
      setState(() => _initialized = true);
    });
  }

  Future sendMessage({String? text, String? imageUrl}) async {
    final chatMessagesRecordData = createChatMessagesRecordData(
      user: currentUserReference,
      chat: chatReference,
      text: text,
      image: imageUrl,
      timestamp: getCurrentTimestamp,
    );
    await ChatMessagesRecord.collection.doc().set(chatMessagesRecordData);
    final lastMessage = (text ?? '').isNotEmpty
        ? text
        : (imageUrl ?? '').isNotEmpty
            ? 'Sent an image'
            : '';
    final lastMessageTime = getCurrentTimestamp;
    final chatsRecordData = createChatsRecordData(
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
    );
    await chatReference.update({
      'last_message_seen_by': [currentUserReference],
      'last_message_sent_by': currentUserReference,
      ...chatsRecordData,
    });
  }

  @override
  void dispose() {
    messagesStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          FFChatWidget(
            currentUser: currentUser,
            scrollController: scrollController,
            focusNode: focusNode,
            messages: messages
                .map(
                  (message) => ChatMessage(
        
                    user: currentUser
                      ,
                    text: message.text,
                    createdAt: message.timestamp!,
                  ),
                )
                .toList(),
            onSend: (message) =>
                sendMessage(text: message.text, imageUrl: message.user.profileImage),
            uploadMediaAction: widget.allowImages
                ? () async {
                    final selectedMedia =
                        await selectMediaWithSourceBottomSheet(
                      context: context,
                      allowPhoto: true,
                    ).then((m) => m != null && m.isNotEmpty ? m.first : null);
                    if (selectedMedia == null ||
                        !validateFileFormat(
                            selectedMedia.storagePath, context)) {
                      return;
                    }
                    showUploadMessage(
                      context,
                      'Sending photo',
                      showLoading: true,
                    );
                    final downloadUrl = await uploadData(
                        selectedMedia.storagePath, selectedMedia.bytes);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    await sendMessage(imageUrl: downloadUrl);
                  }
                : null,
            backgroundColor: widget.backgroundColor,
            timeDisplaySetting: widget.timeDisplaySetting,
            currentUserBoxDecoration: widget.currentUserBoxDecoration,
            otherUsersBoxDecoration: widget.otherUsersBoxDecoration,
            currentUserTextStyle: widget.currentUserTextStyle,
            otherUsersTextStyle: widget.otherUsersTextStyle,
            inputHintTextStyle: widget.inputHintTextStyle,
            inputTextStyle: widget.inputTextStyle,
            emptyChatWidget: widget.emptyChatWidget,
          ),
        ],
      );
}

