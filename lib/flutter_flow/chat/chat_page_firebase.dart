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
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:login2/backend/controlador_caso.dart';
import 'package:login2/backend/controlador_chat.dart';
import 'package:login2/flutter_flow/chat/index.dart';
import 'package:login2/flutter_flow/flutter_flow_theme.dart';
import 'package:login2/main.dart';
import 'package:login2/model/chatBot.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:login2/model/chat_mensajes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/activo.dart';
import '../../model/caso.dart';
import '../../model/dependencias.dart';
import '../../model/usuario.dart';

class ChatPageFirebase extends StatefulWidget {
  const ChatPageFirebase(
      {key,
      required this.room,
      required this.chatUid,
      this.currentUserToken,
      this.otherUserToken,
      required this.nombre,
      this.msjChatBot,
      required this.otroUsuario,
      this.caso,
      this.mensajeImagen,
      this.activo,
      this.dependencia});
  final String? nombre;
  final String? currentUserToken;
  final String? otherUserToken;
  final types.Room room;
  final String chatUid;
  final String? msjChatBot;
  final Usuario otroUsuario;
  final Caso? caso;
  final ChatMensajes? mensajeImagen;
  final Activo? activo;
  final Dependencia? dependencia;

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
    int countMensajes = await ControladorChat().primerMensaje(widget.room.id);
    if (countMensajes == 0) {
      ControladorChat().removerConversacionesRepetidas(
          widget.room.id, widget.otroUsuario.uid!);
    }
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );

    if (widget.otroUsuario.uid.toString().trim() ==
        'PaAQ6DjhL1Yl45h1bloNerwPFt82') {
      await secuenciaChatBot(message.text);
    }

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
    if (esperandoRespuesta) {
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
              await prefs.setString('codigoProceso-${widget.room.id}', "1-3");
              break;
            default:
              respuesta =
                  "Ok, entonces llamare a un técnico para que se haga cargo.";
          }
          if (respuesta !=
              "Ok, entonces llamare a un técnico para que se haga cargo.") {
            //Respuesta de secuencia
            Future.delayed(Duration(seconds: 1), () async {
              ChatBot chatBotRespuesta = await ChatBot().handleMessageChatBot(message,widget.activo);
              print("id respuesta: " + chatBotRespuesta.id.toString());
              enviarMensajeChatBot(
                  auth, prefs, codigoRespuestaProceso, respuesta, 1);
              if (img != null) {
                enviarImagenChatBot(auth, img, 1);
              }
              enviarMensajeChatBot(auth, prefs, codigoRespuestaProceso,
                  "¿Soluciono tu problema? (Responde ✅Si/❌No)", 3);
            });
          } else {
            //No solucionado - Finaliza solicitando técnico
            if (codigoRespuestaProceso != '6-2') {
              prefs.clear();
              enviarMensajeChatBot(
                  auth, prefs, codigoRespuestaProceso, respuesta, 2);
              if (widget.mensajeImagen != null) {
                await ChatBot().abrirConversacionesTecnicos(auth, widget.caso,
                    widget.activo!.nombre, widget.dependencia!.nombre,
                    imagen: widget.mensajeImagen);
              } else if (widget.activo != null) {
                await ChatBot().abrirConversacionesTecnicos(auth, widget.caso,
                    widget.activo!.nombre, widget.dependencia!.nombre);
              }

              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NuevaNavBarFuncionario(),
                ),
              );
            } else {
              enviarMensajeChatBot(
                  auth, prefs, codigoRespuestaProceso, 'Ok', 2);
            }
            prefs.clear();
          }
        } else {
          //Solucionado - Finaliza cerrando la conversacion y el caso
          if (codigoRespuestaProceso != '6-2') {
            enviarMensajeChatBot(auth, prefs, codigoRespuestaProceso,
                "Ha sido un gusto poder ayudarte 😁", 1);
            if (widget.caso != null) {
              widget.caso!.finalizadoPor = 'PaAQ6DjhL1Yl45h1bloNerwPFt82';
              CasosController().marcarCasoComoresuelto(
                  widget.caso!, 'PaAQ6DjhL1Yl45h1bloNerwPFt82');
              int totalCasos = await CasosController()
                                .getTotalCasosCountSolicitanteFuture(
                                    widget.caso!.uidSolicitante.trim());
                            log('TotalCasos: $totalCasos');
                            if (totalCasos == 0) {
                              ChatMensajes mensaje1 = ChatMensajes(
                                  authorId: auth.currentUser!.uid.trim(),
                                  updatedAt: DateTime.now(),
                                  mensaje:
                                      'No se han encontrado más casos abiertos, el chat se cerrara a continuación',
                                  tipo: 'text',
                                  fechaHora: DateTime.now());
                              await FirebaseFirestore.instance
                                  .collection('rooms')
                                  .doc(widget.room.id)
                                  .collection('messages')
                                  .add(mensaje1.toMapText());
                              await FirebaseFirestore.instance
                                  .collection('rooms')
                                  .doc(widget.room.id)
                                  .update({'finalizado': true});
                              await FirebaseFirestore.instance
                                  .collection('rooms')
                                  .doc(widget.room.id)
                                  .update({
                                'sinRespuesta': false,
                                'finalizado': true,
                              });
                            }
                            Navigator.pop(context);
            }
          } else {
            secuenciaConsultarTiempoEspera(auth, prefs, codigoRespuestaProceso??'');
          }

          prefs.clear();
        }
      } else {
        //Respuesta de dos opciones
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
      //Primera respuesta chat bot
      Future.delayed(Duration(seconds: 1), () async {
        ChatBot chatBotRespuesta = await ChatBot().handleMessageChatBot(message,widget.activo);;
        log("id respuesta: " + chatBotRespuesta.id.toString());
        enviarMensajeChatBot(
            auth, prefs, codigoRespuestaProceso, chatBotRespuesta.respuesta, 0);

        if (chatBotRespuesta.id >= 1 && chatBotRespuesta.id <= 4) {
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
              //Define el código de proceso
              if (codigoRespuestaProceso != null) {
                await prefs.setString('codigoProceso-${widget.room.id}', "1-3");
              } else {
                await prefs.setString('codigoProceso-${widget.room.id}', "1-2");
              }
            });
          });
        } else if (chatBotRespuesta.id > 5) {
          enviarMensajeChatBot(
              auth, prefs, codigoRespuestaProceso, "Responde ✅Si/❌No", 2);
          await prefs.setBool('esperandoRespuesta-${widget.room.id}', true);
          await prefs.setString('codigoProceso-${widget.room.id}', "6-2");
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
          authorId: 'PaAQ6DjhL1Yl45h1bloNerwPFt82',
          updatedAt: DateTime.now().add(Duration(seconds: 1)),
          mensaje: mensaje,
          tipo: 'text',
          fechaHora: DateTime.now().add(Duration(seconds: 1)));
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.room.id)
          .collection('messages')
          .add(mensaje1.toMapText());
    });
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

  secuenciaConsultarTiempoEspera(FirebaseAuth auth, SharedPreferences prefs,
      String codigoRespuestaProceso) {
    enviarMensajeChatBot(
        auth,
        prefs,
        codigoRespuestaProceso,
        "De acuerdo, voy a calcular el tiempo estimado de llegada del técnico.",
        1);
    Future.delayed(Duration(seconds: 1), () async {
      enviarMensajeChatBot(
          auth,
          prefs,
          codigoRespuestaProceso,
          "Recuerda que esta es solo una estimación aproximada basada en lo que les ha tomado resolver otros casos a los técnicos y el tiempo real puede variar dependiendo de varios factores.",
          1);
      Future.delayed(Duration(seconds: 2), () async {
        enviarMensajeChatBot(
            auth, prefs, codigoRespuestaProceso, "Calculando...", 1);

        Future.delayed(Duration(seconds: 1), () async {
          ChatMensajes? chatMensajes = await ControladorChat()
              .obtenerPuestoEnColaByIdFuture(auth.currentUser!.uid);
          // Calcular el tiempo promedio
          if (chatMensajes != null) {
            await atenderCaso(
                auth, prefs, codigoRespuestaProceso, chatMensajes.turno);
          } else {
            enviarMensajeChatBot(auth, prefs, codigoRespuestaProceso,
                "Ha ocurrido un error en el proceso", 1);
          }
        });
      });
    });
  }

  Future<void> atenderCaso(FirebaseAuth auth, SharedPreferences prefs,
      String codigoRespuestaProceso, int? turno) async {
    Duration tiempoPromedio = await CasosController().calcularTiempoPromedio();
    if (tiempoPromedio.inHours > 1) {
      enviarMensajeChatBot(
          auth,
          prefs,
          codigoRespuestaProceso,
          "El tiempo promedio de atención es: ${tiempoPromedio.inHours} horas",
          1);
    } else {
      enviarMensajeChatBot(
          auth,
          prefs,
          codigoRespuestaProceso,
          "El tiempo promedio de atención es: ${tiempoPromedio.inMinutes} minutos",
          1);
    }

    DateTime horaActual = DateTime.now();
    DateTime horaCierre = DateTime(horaActual.year, horaActual.month,
        horaActual.day, 18); // Asumiendo que la hora de cierre es 6 PM.

    if (turno != null) {
      enviarMensajeChatBot(auth, prefs, codigoRespuestaProceso,
          "Usted es el número $turno en la cola", 2);
      if (turno == 1) {
        enviarMensajeChatBot(auth, prefs, codigoRespuestaProceso,
            "El técnico llegara en breve", 2);
      } else {
        DateTime horaEstimadaLlegada =
            horaActual.add(tiempoPromedio * (turno - 1));
        String formattedEstimadaLlegada = horaEstimadaLlegada.day ==
                DateTime.now().day
            ? "a las ${DateFormat('hh:mm a').format(horaEstimadaLlegada)}"
            : "el ${DateFormat('EEEE').format(horaEstimadaLlegada)} a las ${DateFormat('hh:mm a').format(horaEstimadaLlegada)}";

        enviarMensajeChatBot(
            auth,
            prefs,
            codigoRespuestaProceso,
            "El técnico llegará aproximadamente $formattedEstimadaLlegada",
            3); /*
        if (horaActual
            .isAfter(horaCierre.subtract(tiempoPromedio * (turno - 1)))) {
          DateTime proximaJornada = DateTime(horaActual.year, horaActual.month,
              horaActual.day + 1, 8); // Próxima jornada a las 8 AM.

          String formattedDate =
              DateFormat('EEEE – hh:mm a', 'es_CO').format(proximaJornada);

          String fechaFutura = DateFormat('EEEE – hh:mm a', 'es_CO')
              .format(DateTime.now().add(tiempoPromedio));

          enviarMensajeChatBot(
              auth,
              prefs,
              codigoRespuestaProceso,
              "Dado que eso supera la jornada de hoy, posiblemente lo atienda el $fechaFutura",
              4);
        }*/
      }
    } else {
      enviarMensajeChatBot(auth, prefs, codigoRespuestaProceso,
          "Error: Usted no está en la cola", 2);
    }
    prefs.clear();
  }

  
  
}
