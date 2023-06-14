import 'package:login2/flutter_flow/chat/chat_page_firebase.dart';
import 'package:login2/model/chat_mensajes.dart';

import '../../model/usuario.dart';
import 'index.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

enum TimeDisplaySetting {
  alwaysVisible,
  alwaysInvisible,
  visibleOnTap,
}

class FFChatWidget extends StatelessWidget {
  FFChatWidget({
    Key? key,
    required this.currentUser,
    required this.scrollController,
    required this.focusNode,
    required this.messages,
    this.uploadMediaAction,
    // Theme settings
    this.backgroundColor,
    this.timeDisplaySetting = TimeDisplaySetting.visibleOnTap,
    this.currentUserBoxDecoration,
    this.otherUsersBoxDecoration,
    this.currentUserTextStyle,
    this.otherUsersTextStyle,
    this.inputHintTextStyle,
    this.inputTextStyle,
    this.emptyChatWidget, required this.nombre,
  }) : super(key: key);

  final Usuario currentUser;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final List<ChatMensajes> messages;
  final Function()? uploadMediaAction;
  final String nombre;

  final Color? backgroundColor;
  final TimeDisplaySetting? timeDisplaySetting;
  final BoxDecoration? currentUserBoxDecoration;
  final BoxDecoration? otherUsersBoxDecoration;
  final TextStyle? currentUserTextStyle;
  final TextStyle? otherUsersTextStyle;
  final TextStyle? inputHintTextStyle;
  final TextStyle? inputTextStyle;
  final Widget? emptyChatWidget;
  final List<types.User> users = [
    types.User(id: '1', firstName: 'Nombre 1'),
    types.User(id: '2', firstName: 'Nombre 2')
  ];

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: focusNode.unfocus,
        child: Container(
          color: backgroundColor,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Theme(
                    data: ThemeData(brightness: Brightness.light),
                    child: ChatPageFirebase(
                      nombre: 'Hola',
                        chatUid: 'rEzfeft8TxbyObmY4XLb',
                        room: types.Room(
                            id: 'Llk8BwZJpgM3ORkbk66F',
                            type: types.RoomType.direct,
                            users: users))),
              ),
              if (messages.isEmpty && emptyChatWidget != null)
                Center(child: emptyChatWidget),
            ],
          ),
        ),
      );
}

class FFChatMessage extends StatefulWidget {
  const FFChatMessage({
    Key? key,
    required this.chatMessage,
    required this.isMe,
    this.timeDisplaySetting,
    this.currentUserBoxDecoration,
    this.otherUsersBoxDecoration,
    this.currentUserTextStyle,
    this.otherUsersTextStyle,
  }) : super(key: key);

  final ChatMensajes chatMessage;
  final TimeDisplaySetting? timeDisplaySetting;
  final BoxDecoration? currentUserBoxDecoration;
  final BoxDecoration? otherUsersBoxDecoration;
  final TextStyle? currentUserTextStyle;
  final TextStyle? otherUsersTextStyle;
  final bool isMe;

  @override
  _FFChatMessageState createState() => _FFChatMessageState();
}

class _FFChatMessageState extends State<FFChatMessage> {
  bool _showTime = false;
  bool get showTime {
    switch (widget.timeDisplaySetting) {
      case TimeDisplaySetting.alwaysVisible:
        return true;
      case TimeDisplaySetting.alwaysInvisible:
        return false;
      case TimeDisplaySetting.visibleOnTap:
      default:
        return _showTime;
    }
  }

  BoxDecoration get boxDecoration => ((widget.isMe
                  ? widget.currentUserBoxDecoration
                  : widget.otherUsersBoxDecoration) ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.isMe ? Colors.white : const Color(0xFF4B39EF),
              ))
          .copyWith(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 1),
            blurRadius: 3.0,
          ),
        ],
      );

  TextStyle get textStyle => ((widget.isMe
              ? widget.currentUserTextStyle
              : widget.otherUsersTextStyle) ??
          GoogleFonts.getFont(
            'DM Sans',
            color: widget.isMe ? const Color(0xFF1E2429) : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ))
      .copyWith(height: 1.5);

  bool get hasImage => (widget.chatMessage.tipo == null);

  @override
  Widget build(BuildContext context) => Align(
        alignment: widget.isMe
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: Column(
          crossAxisAlignment:
              widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6.0),
            InkWell(
              onTap: () => setState(() => _showTime = !showTime),
              splashColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65),
                decoration: boxDecoration.copyWith(
                    color: hasImage ? Colors.transparent : null),
                child: hasImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Solid_red.svg/512px-Solid_red.svg.png',
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        child: Text(
                          widget.chatMessage.mensaje,
                          style: textStyle,
                        ),
                      ),
              ),
            ),
            if (showTime)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 5.0, start: 5.0),
                child: Text(
                  widget.chatMessage.fechaHora.isBefore(
                          DateTime.now().subtract(const Duration(minutes: 3)))
                      ? timeago.format(widget.chatMessage.fechaHora)
                      : DateFormat.jm().format(widget.chatMessage.fechaHora),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 2.0),
          ],
        ),
      );
}
