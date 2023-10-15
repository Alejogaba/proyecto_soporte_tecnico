import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:login2/flutter_flow/chat/index.dart';
import 'package:login2/flutter_flow/flutter_flow_theme.dart';
import 'package:login2/model/chatBot.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:login2/model/chat_mensajes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPageFirebase extends StatefulWidget {
  const ChatPageFirebase({
    key,
    required this.room,
    required this.chatUid,
    this.currentUserToken,
    this.otherUserToken,
    required this.nombre,
    this.msjChatBot,
  });
  final String? nombre;
  final String? currentUserToken;
  final String? otherUserToken;
  final types.Room room;
  final String chatUid;
  final String? msjChatBot;

  @override
  State<ChatPageFirebase> createState() => _ChatPageFirebaseState();
}

class _ChatPageFirebaseState extends State<ChatPageFirebase> {
  @override
  void initState() {
    super.initState();
    if (widget.msjChatBot != null) {
      secuenciaChatBot(widget.msjChatBot!);
    }
  }

  List<String> _intents = ["pc no enciende"];
  List<String> _responses = [
    "Entiendo que estás experimentando problemas para encender tu computadora. Aquí tienes algunos pasos básicos que puedes seguir para intentar solucionar el problema:\n\n1. ¿Tu computadora está conectada a una toma de corriente que funciona y el cable de alimentación está correctamente enchufado? 🔌",
  ];
  bool _isAttachmentUploading = false;

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Imagen'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Archivo'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        print('Token otro usuario: ' + widget.otherUserToken.toString());
        await sendNotification(
            widget.otherUserToken!, widget.nombre!, '📎 Archivo adjunto');
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
        if (widget.otherUserToken != null) {
          print('Token otro usuario: ' + widget.otherUserToken.toString());
          await sendNotification(
              widget.otherUserToken!, widget.nombre!, '🖼 Imagen');
        }
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);

          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) async {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
    await secuenciaChatBot(message.text);

    if (widget.otherUserToken != null) {
      print('Token otro usuario: ' + widget.otherUserToken.toString());
      await sendNotification(
          widget.otherUserToken!, widget.nombre!, message.text);
    }
  }

  Future<void> secuenciaChatBot(String message) async {
    final prefs = await SharedPreferences.getInstance();
    FirebaseAuth auth = FirebaseAuth.instance;
    bool chatBot = prefs.getBool('chatBot-${widget.room.id}') ?? true;
    bool esperandoRespuesta =
        prefs.getBool('esperandoRespuesta-${widget.room.id}') ?? false;
    String? codigoRespuestaProceso =
        prefs.getString('codigoProceso-${widget.room.id}');
    log("Esperando respuesta: " + esperandoRespuesta.toString());
    log("codigoRespuesta: " + codigoRespuestaProceso.toString());
    if (esperandoRespuesta && codigoRespuestaProceso != null) {
      if (message.toLowerCase().contains('si') ||
          message.toLowerCase().contains('no')) {
        if (message.toLowerCase().contains('no')) {
          late String respuesta;
          String? img;
          switch (codigoRespuestaProceso) {
            case "1-2":
              respuesta =
                  "2. ¿Tu monitor está encendido y conectado correctamente a la computadora? ¿El cable de video está correctamente conectado? ¿Ves algún indicador de encendido en el monitor? 🖥️🔵";
              img =
                  "https://firebasestorage.googleapis.com/v0/b/proyecto-soporte-tecnico.appspot.com/o/scaled_1000000035.jpg?alt=media&token=91bfcc65-b875-480f-aad6-c2fb130ad611";
              break;
            default:
              respuesta =
                  "Ok, entonces llamare a un técnico para que se haga cargo.";
          }
          if (respuesta !=
              "Ok, entonces llamare a un técnico para que se haga cargo.") {
            Future.delayed(Duration(seconds: 1), () async {
              ChatBot chatBotRespuesta =
                  await handleMessageChatBot(message);
              print("id respuesta: " + chatBotRespuesta.id.toString());
              enviarMensajeChatBot(
                  auth, prefs, codigoRespuestaProceso, respuesta, 0);
              if (img != null) {
                enviarImagenChatBot(auth, img, 1);
              }
              enviarMensajeChatBot(auth, prefs, codigoRespuestaProceso,
                  "¿Soluciono tu problema? (Responde ✅Si/❌No)", 3);
            });
          } else {
            enviarMensajeChatBot(
                auth, prefs, codigoRespuestaProceso, respuesta, 1);
          }
        } else {
          enviarMensajeChatBot(auth, prefs, codigoRespuestaProceso,
              "Ha sido un gusto poder ayudarte 😁", 1);
        }
      } else {
        Future.delayed(Duration(seconds: 2), () async {
          enviarMensajeChatBot(
              auth, prefs, codigoRespuestaProceso, "Responde ✅Si o ❌No", 0);
          await prefs.setBool('esperandoRespuesta-${widget.room.id}', true);
          codigoRespuestaProceso =
              prefs.getString('codigoProceso-${widget.room.id}');
          if (codigoRespuestaProceso != null) {
            await prefs.setString('codigoProceso-${widget.room.id}', "1-3");
          } else {
            await prefs.setString('codigoProceso-${widget.room.id}', "1-2");
          }
        });
      }
    } else {
      Future.delayed(Duration(seconds: 1), () async {
        ChatBot chatBotRespuesta = await handleMessageChatBot(message);
        print("id respuesta: " + chatBotRespuesta.id.toString());
        enviarMensajeChatBot(
            auth, prefs, codigoRespuestaProceso, chatBotRespuesta.respuesta, 0);
        if (chatBotRespuesta.id >= 1 && chatBotRespuesta.id <= 2) {
          //Valida en que rango entra la respuesta
          Future.delayed(Duration(seconds: 1), () async {
            enviarImagenChatBot(
                auth,
                "https://firebasestorage.googleapis.com/v0/b/proyecto-soporte-tecnico.appspot.com/o/scaled_1000000034.jpg?alt=media&token=8d158359-636d-4c92-97e0-8decf0f97061",
                0);

            Future.delayed(Duration(seconds: 3), () async {
              enviarMensajeChatBot(auth, prefs, codigoRespuestaProceso,
                  "¿Soluciono tu problema? (Responde ✅Si/❌No)", 0);

              await prefs.setBool('esperandoRespuesta-${widget.room.id}', true);
              codigoRespuestaProceso =
                  prefs.getString('codigoProceso-${widget.room.id}');
              if (codigoRespuestaProceso != null) {
                await prefs.setString('codigoProceso-${widget.room.id}', "1-3");
              } else {
                await prefs.setString('codigoProceso-${widget.room.id}', "1-2");
              }
            });
          });
        }
      });
    }
  }

  void enviarImagenChatBot(FirebaseAuth auth, String? img, int tiempo) {
    Future.delayed(Duration(seconds: tiempo), () async {
      ChatMensajes mensaje1 = ChatMensajes(
          //envia la imagen
          authorId: auth.currentUser!.uid.trim() ==
                  widget.room.users[0].toString().trim()
              ? widget.room.users[1].toString().trim()
              : widget.room.users[0].toString().trim(),
          updatedAt: DateTime.now().add(Duration(seconds: 1)),
          height: 600,
          width: 600,
          mensaje: "enchufa.jpg",
          uri: img,
          tipo: 'text',
          fechaHora: DateTime.now().add(Duration(seconds: tiempo)));
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.room.id)
          .collection('messages')
          .add(mensaje1.toMapImage());
    });
  }

  void enviarMensajeChatBot(FirebaseAuth auth, SharedPreferences prefs,
      String? codigoRespuestaProceso, String mensaje, int tiempo) {
    Future.delayed(Duration(seconds: tiempo), () async {
      ChatMensajes mensaje1 = ChatMensajes(
          //Pregunta si soluciono su problema
          authorId: auth.currentUser!.uid.trim() ==
                  widget.room.users[0].toString().trim()
              ? widget.room.users[1].toString().trim()
              : widget.room.users[0].toString().trim(),
          updatedAt: DateTime.now().add(Duration(seconds: 1)),
          mensaje: mensaje,
          tipo: 'text',
          fechaHora: DateTime.now().add(Duration(seconds: 1)));
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.room.id)
          .collection('messages')
          .add(mensaje1.toMapText());
      prefs.setBool('esperandoRespuesta-${widget.room.id}', true);
      if (codigoRespuestaProceso != null) {
        prefs.setString('codigoProceso-${widget.room.id}', "1-3");
      } else {
        prefs.setString('codigoProceso-${widget.room.id}', "1-2");
      }
    });
  }

  Future<ChatBot> handleMessageChatBot(String message) async {
    for (int i = 0; i < _intents.length; i++) {
      if (message.toLowerCase().contains(_intents[i].toLowerCase())) {
        return ChatBot(id: i + 1, respuesta: _responses[i]);
      }
    }

    return ChatBot(id: 0, respuesta: "Lo siento, no entiendo tu solicitud.");
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<types.Room>(
          initialData: widget.room,
          stream: FirebaseChatCore.instance.room(widget.room.id),
          builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
            initialData: [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) => Chat(
              theme: DefaultChatTheme(
                inputBackgroundColor:
                    FlutterFlowTheme.of(context).primary.withAlpha(230),
                primaryColor: FlutterFlowTheme.of(context).primary,
                secondaryColor: FlutterFlowTheme.of(context).accent3,
                backgroundColor: Color.fromARGB(255, 176, 199, 184),
              ),
              showUserAvatars: true,
              dateLocale: 'es-CO',
              timeFormat: DateFormat('h:mm a', 'es'),
              dateFormat: DateFormat('EEEE, d ' 'MMMM', 'es'),
              isAttachmentUploading: _isAttachmentUploading,
              messages: snapshot.data ?? [],
              onAttachmentPressed: _handleAtachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              user: types.User(
                id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
              ),
            ),
          ),
        ),
      );

  Future<void> sendNotification(String token, String title, String body) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAJQiQggw:APA91bFOK9ueBLkt_tMxHlbNHo1MyNyuQRWgnOn9OUqPKNawk4cpa3pPE8luKS9wEr2eCiXZc3LFDzwK9R3m2xlBtjtAYmlHQw7uwp4kCnGZ1-GA8E6o0rTqZPQzLVU_GVHTQqGi4XeM',
    };

    final message = {
      'to': token,
      'notification': {
        'title': title,
        'body': body,
      },
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(message),
    );

    if (response.statusCode == 200) {
      print('Notificación enviada correctamente');
    } else {
      print('Error al enviar la notificación');
    }
  }
}
