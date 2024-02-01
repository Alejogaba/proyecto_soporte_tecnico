import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:login2/backend/controlador_chat.dart';
import 'package:login2/model/activo.dart';
import 'package:login2/model/caso.dart';
import 'package:login2/model/chat_mensajes.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:login2/model/room.dart';
import '../auth/firebase_auth/auth_helper.dart';
import '../backend/controlador_caso.dart';
import '../utils/utilidades.dart';
import 'usuario.dart';

class ChatBot {
  List<String> _intents = [
    "pc no enciende",
    "computador no prende",
    "pc no prende",
    "computador no enciende",
    "Gracias",
    "se demora",
    "cuando viene el tecnico",
  ];
  List<String> _responses = [
    "Entiendo que estás experimentando problemas para encender tu computadora. Aquí tienes algunos pasos básicos que puedes seguir para intentar solucionar el problema:\n\n1. ¿Tu computadora está conectada a una toma de corriente que funciona y el cable de alimentación está correctamente enchufado? 🔌",
    "Entiendo que estás experimentando problemas para encender tu computadora. Aquí tienes algunos pasos básicos que puedes seguir para intentar solucionar el problema:\n\n1. ¿Tu computadora está conectada a una toma de corriente que funciona y el cable de alimentación está correctamente enchufado? 🔌",
    "Entiendo que estás experimentando problemas para encender tu computadora. Aquí tienes algunos pasos básicos que puedes seguir para intentar solucionar el problema:\n\n1. ¿Tu computadora está conectada a una toma de corriente que funciona y el cable de alimentación está correctamente enchufado? 🔌",
    "Entiendo que estás experimentando problemas para encender tu computadora. Aquí tienes algunos pasos básicos que puedes seguir para intentar solucionar el problema:\n\n1. ¿Tu computadora está conectada a una toma de corriente que funciona y el cable de alimentación está correctamente enchufado? 🔌",
    "No hay de que. 😉",
    "Lamento escuchar que el técnico se está demorando. A veces, los retrasos pueden ocurrir debido a circunstancias imprevistas.😕",
    "Lamento la demora en la llegada del técnico. ¿Te gustaría que verifique su horario estimado de llegada? 🕒",
  ];
  int id;
  String uid;
  String intent;
  String respuesta;

  ChatBot(
      {this.id = 0,
      this.uid = '',
      this.intent = '',
      this.respuesta = 'Lo siento, no entiendo tu solicitud. 😕'});

  factory ChatBot.fromJson(Map<String, dynamic> json) {
    return ChatBot(
      id: json['id'] as int,
      respuesta: json['respuesta'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['respuesta'] = this.respuesta;
    return data;
  }

  factory ChatBot.fromMap(Map<String, dynamic> map) {
    return ChatBot(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      intent: map['intent'] ?? '',
      respuesta: map['respuesta'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'intent': intent,
      'respuesta': respuesta,
    };
  }

  Future<ChatBot> handleMessageChatBot(String message, Activo? activo) async {
    for (int i = 0; i < _intents.length; i++) {
      if (message.toLowerCase().contains(_intents[i].toLowerCase())) {
        return ChatBot(id: i + 1, respuesta: _responses[i]);
      }
    }
    if (activo != null) {
      String mensajeExtendido = "$message ${activo!.nombre.split(' ')[0]}";
      for (int i = 0; i < _intents.length; i++) {
        if (mensajeExtendido
            .toLowerCase()
            .contains(_intents[i].toLowerCase())) {
          return ChatBot(id: i + 1, respuesta: _responses[i]);
        }
      }
    }

    List<ChatBot> _intentsFirebase =
        await ControladorChat().obtenerRespuestasChatBotFirebase();

    for (int i = 0; i < _intentsFirebase.length; i++) {
      if (message.toLowerCase().contains(_intentsFirebase[i]
          .intent
          .trim()
          .toLowerCase()
          .replaceAll("¿", "")
          .replaceAll("?", ""))) {
        return ChatBot(id: 22, respuesta: _intentsFirebase[i].respuesta);
      }
    }
    if (activo != null) {
      String mensajeExtendido = "$message ${activo!.nombre.split(' ')[0]}";
      for (int i = 0; i < _intentsFirebase.length; i++) {
        if (mensajeExtendido.toLowerCase().contains(_intentsFirebase[i]
            .intent
            .trim()
            .toLowerCase()
            .replaceAll("¿", "")
            .replaceAll("?", ""))) {
          return ChatBot(id: 22, respuesta: _intentsFirebase[i].respuesta);
        }
      }
    }

    return ChatBot(id: 0, respuesta: "Lo siento, no entiendo tu solicitud.");
  }

  Future abrirConversacionTecnico(Caso caso, String activo, String dependencia,
      {ChatMensajes? imagen}) async {
    List<Usuario> usuariosObtenidos =
        await UserHelper().obtenerUsuarios(); //se obtiene los usuarios

    if (usuariosObtenidos.length > 0) {
      late ChatMensajes? chatTurno;
      if (caso.prioridad) {
        chatTurno = await ControladorChat()
            .obtenerUltimoEnColaUrgente(uidTecnico: caso.uidTecnico.toString());
        await ControladorChat()
            .aumentarTurno(uidTecnico: caso.uidTecnico.toString());
      } else {
        chatTurno = await ControladorChat()
            .obtenerUltimoEnCola(uidTecnico: caso.uidTecnico.toString());
      }
      for (var element in usuariosObtenidos) {
        if (element.uid.toString().trim() ==
            caso.uidTecnico.toString().trim()) {
          log('tecnico: ' + element.nombre.toString());
          types.User otheruser = types.User(id: element.uid!.trim());

          Room room = Room(
              uid: '${caso.uidSolicitante.trim()}${caso.uidActivo.trim()}',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              userIds: [element.uid!.trim(), caso.uidSolicitante.trim()]);
          await FirebaseFirestore.instance
              .collection('rooms')
              .doc(room.uid)
              .set(room.toMap());
          final collectionRef =
              FirebaseFirestore.instance.collection('rooms').doc(room.uid);

          ChatMensajes mensaje1 = ChatMensajes(
              authorId: caso.uidSolicitante.toString().trim(),
              updatedAt: DateTime.now(),
              mensaje: 'Activo afectado:\n$activo',
              tipo: 'text',
              fechaHora: DateTime.now());
          await FirebaseFirestore.instance
              .collection('rooms')
              .doc(room.uid)
              .collection('messages')
              .add(mensaje1.toMapText());

          ChatMensajes mensaje2 = ChatMensajes(
              authorId: caso.uidSolicitante.toString().trim(),
              updatedAt: DateTime.now().add(Duration(seconds: 1)),
              mensaje: 'Descripción del problema:\n${caso.descripcion}',
              tipo: 'text',
              fechaHora: DateTime.now().add(Duration(seconds: 1)));
          await FirebaseFirestore.instance
              .collection('rooms')
              .doc(room.uid)
              .collection('messages')
              .add(mensaje2.toMapText());

          if (imagen != null) {
            ChatMensajes mensaje3 = ChatMensajes(
                height: imagen!.height,
                width: imagen.width,
                size: imagen.size,
                uri: caso.urlAdjunto,
                authorId: caso.uidSolicitante.toString().trim(),
                updatedAt: DateTime.now().add(Duration(seconds: 2)),
                mensaje: 'Archivo_adjunto.jpg',
                fechaHora: DateTime.now().add(Duration(seconds: 2)));
            await FirebaseFirestore.instance
                .collection('rooms')
                .doc(room.uid)
                .collection('messages')
                .add(mensaje3.toMapImage());
          } //Se envia la imagen si la hay
          String? tieneChatAbierto = await ControladorChat().buscarChatAbierto(
              element.uid!, caso.uidSolicitante.toString().trim());
          if (tieneChatAbierto == null) {
            if (caso.prioridad) {
              if (chatTurno == null) {
                await collectionRef.update({
                  'uid': room.uid,
                  'uidTecnico': element.uid.toString().trim(),
                  'sinRespuesta': true,
                  'finalizado': false,
                  'turno': 1,
                  'prioridad': true
                });
              } else {
                await collectionRef.update({
                  'uid': room.uid,
                  'uidTecnico': element.uid.toString().trim(),
                  'sinRespuesta': true,
                  'finalizado': false,
                  'turno': chatTurno.turno! + 1,
                  'prioridad': true
                });
              }
            } else {
              if (chatTurno == null) {
                await collectionRef.update({
                  'uid': room.uid,
                  'uidTecnico': element.uid.toString().trim(),
                  'sinRespuesta': true,
                  'finalizado': false,
                  'turno': 1,
                  'prioridad': false
                });
              } else {
                await collectionRef.update({
                  'uid': room.uid,
                  'uidTecnico': element.uid.toString().trim(),
                  'sinRespuesta': true,
                  'finalizado': false,
                  'turno': chatTurno.turno! + 1,
                  'prioridad': false
                });
              }
            }
          } else {
            if (caso.prioridad) {
              await collectionRef.update({'prioridad': true});
            }
          }

          Usuario? usuarioSolicitante = await AuthHelper()
              .getUsuarioFutureUID(caso.uidSolicitante.toString().trim());

          if (element.fcmToken != null && element.fcmToken!.isNotEmpty) {
            await Utilidades().sendNotification(
                element.fcmToken!,
                'Nuevo reporte',
                'Un equipo en $dependencia requiere servicio técnico');
          }

          if (usuarioSolicitante != null &&
              usuarioSolicitante.fcmToken != null &&
              usuarioSolicitante.fcmToken!.isNotEmpty) {
            await Utilidades().sendNotification(
                element.fcmToken!,
                'Técnico asignado',
                'El técnico ${element.nombre} atendera su solicitud');
          }
        }
      }

      Get.snackbar('Caso asignado',
          'Se ha asignado correctamente el caso y se ha notificado a ambas partes',
          duration: Duration(seconds: 6),
          margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Color.fromARGB(211, 28, 138, 46),
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          colorText: Color.fromARGB(255, 228, 219, 218));
    }
  }

  Future abrirCasoAdmin(
      FirebaseAuth auth, Caso? caso, String activo, String dependencia,
      {ChatMensajes? imagen}) async {
    List<Usuario> usuariosObtenidos =
        await UserHelper().obtenerUsuarios(); //meter usuario casos

    if (usuariosObtenidos.length > 0) {
      late ChatMensajes? chatTurno;
      if (caso != null && caso.prioridad) {
        chatTurno = await ControladorChat().obtenerUltimoEnColaUrgente();
        await ControladorChat().aumentarTurno();
      } else {
        chatTurno = await ControladorChat().obtenerUltimoEnCola();
      }
      for (var element in usuariosObtenidos) {
        if (element.role == 'admin' &&
            element.uid.toString().trim() == "S4AhLGE5jlVQHF020eqwhJeu1R72") {
          log('tecnico: ' + element.nombre.toString());
          Room room1 = Room(
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              userIds: [
                element.uid.toString().trim(),
                'BsgabMF49ifIXBBqN9lXlgAyxPL2'
              ]);
          await FirebaseFirestore.instance
              .collection('rooms')
              .doc(room1.uid)
              .set(room1.toMap());

          int cantidadCasos =
              await CasosController().getTotalCasosCountSinAsignarFuture();

          final collectionRef =
              FirebaseFirestore.instance.collection('rooms').doc(room1.uid);

          ChatMensajes mensaje1 = ChatMensajes(
              authorId: 'BsgabMF49ifIXBBqN9lXlgAyxPL2',
              updatedAt: DateTime.now(),
              mensaje: 'Hay $cantidadCasos pendientes de asignar',
              tipo: 'text',
              fechaHora: DateTime.now());
          await FirebaseFirestore.instance
              .collection('rooms')
              .doc(room1.uid)
              .collection('messages')
              .add(mensaje1.toMapText());

          if (element.fcmToken != null && element.fcmToken!.isNotEmpty) {
            await Utilidades().sendNotification(
                element.fcmToken!,
                'Nuevo reporte',
                'Un equipo en $dependencia requiere servicio técnico');
          }
        }
      }
      int turno = await CasosController().getTotalCasosCountSinAsignarFuture();
      types.User chatBotUser = types.User(id: 'PaAQ6DjhL1Yl45h1bloNerwPFt82');
      types.Room roomChatBot =
          await FirebaseChatCore.instance.createRoom(chatBotUser);
      await chatBotAvisoCasoPendienteAsignar(roomChatBot.id.trim(), turno + 1);
      Get.snackbar('Reporte registrado',
          'Se ha registrado correctamente el reporte y se ha notificado a la oficina de sistemas, en breve te asignaran un técnico',
          duration: Duration(seconds: 6),
          margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Color.fromARGB(211, 28, 138, 46),
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          colorText: Color.fromARGB(255, 228, 219, 218));
    }
  }

  Future abrirConversacionFuncionario(
      String uidFuncionario,
      String uidSolicitante,
      FirebaseAuth auth,
      Caso caso1,
      String activo,
      String dependencia,
      {ChatMensajes? imagen}) async {
    List<Usuario> usuariosObtenidos =
        await UserHelper().obtenerUsuarios(); //meter usuario casos

    if (usuariosObtenidos.length > 0) {
      for (var element in usuariosObtenidos) {
        if (element.role == 'admin' &&
            element.uid.toString().trim() == uidFuncionario.trim()) {
          log('tecnico: ' + element.nombre.toString());
          Room room1 = Room(
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              userIds: [uidFuncionario, uidSolicitante]);
          await FirebaseFirestore.instance
              .collection('rooms')
              .doc(room1.uid)
              .update(room1.toMap());

          Usuario tecnico = element;
          tecnico.ocupado = true;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(tecnico.uid)
              .update(tecnico.toMap());

          Caso caso = caso1;
          caso.asignado = true;
          await FirebaseFirestore.instance
              .collection('casos')
              .doc(caso.uid)
              .update(caso.toMap());

          ChatMensajes mensaje1 = ChatMensajes(
              authorId: '',
              updatedAt: DateTime.now(),
              mensaje: 'Requiero servicio técnico para $activo',
              tipo: 'text',
              fechaHora: DateTime.now());
          await FirebaseFirestore.instance
              .collection('rooms')
              .doc(room1.uid)
              .collection('messages')
              .add(mensaje1.toMapText());

          if (element.fcmToken != null && element.fcmToken!.isNotEmpty) {
            await Utilidades().sendNotification(
                element.fcmToken!,
                'Nuevo reporte',
                'Un equipo en $dependencia requiere servicio técnico');
          }
        }
      }

      Get.snackbar('Reporte registrado',
          'Se ha registrado correctamente el reporte y se ha notificado al, en breve te asignaran un técnico',
          duration: Duration(seconds: 6),
          margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Color.fromARGB(211, 28, 138, 46),
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          colorText: Color.fromARGB(255, 228, 219, 218));
    }
  }

  Future<void> chatBotAdvertencia(String room) async {
    ChatMensajes mensaje1 = ChatMensajes(
        //Pregunta si soluciono su problema
        authorId: 'PaAQ6DjhL1Yl45h1bloNerwPFt82',
        updatedAt: DateTime.now().add(Duration(seconds: 1)),
        mensaje:
            'Disculpa el retraso de 1 turno, este se debe a que surgio un caso urgente. Estamos trabajando para resolverlo lo antes posible. Gracias por tu paciencia',
        tipo: 'text',
        fechaHora: DateTime.now().add(Duration(seconds: 1)));
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(room)
        .collection('messages')
        .add(mensaje1.toMapText());
  }

  Future<void> chatBotAvisoCasoPendienteAsignar(String room, int turno) async {
    ChatMensajes mensaje1 = ChatMensajes(
        //Pregunta si soluciono su problema
        authorId: 'PaAQ6DjhL1Yl45h1bloNerwPFt82',
        updatedAt: DateTime.now().add(Duration(seconds: 1)),
        mensaje:
            'Tu caso se ha notificado a la administración de la oficina de sistemas, en breve te asignaran un técnico',
        tipo: 'text',
        fechaHora: DateTime.now().add(Duration(seconds: 1)));
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(room)
        .collection('messages')
        .add(mensaje1.toMapText());
    if (turno > 2) {
      ChatMensajes mensaje2 = ChatMensajes(
          //Pregunta si soluciono su problema
          authorId: 'PaAQ6DjhL1Yl45h1bloNerwPFt82',
          updatedAt: DateTime.now().add(Duration(seconds: 1)),
          mensaje: 'Hay otros ${turno - 1} casos pendientes antes de ti',
          tipo: 'text',
          fechaHora: DateTime.now().add(Duration(seconds: 1)));
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(room)
          .collection('messages')
          .add(mensaje2.toMapText());
      ChatMensajes mensaje3 = ChatMensajes(
          //Pregunta si soluciono su problema
          authorId: 'PaAQ6DjhL1Yl45h1bloNerwPFt82',
          updatedAt: DateTime.now().add(Duration(seconds: 2)),
          mensaje: 'Tu caso es el #$turno en la cola',
          tipo: 'text',
          fechaHora: DateTime.now().add(Duration(seconds: 2)));
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(room)
          .collection('messages')
          .add(mensaje3.toMapText());
    } else if (turno == 2) {
      ChatMensajes mensaje2 = ChatMensajes(
          //Pregunta si soluciono su problema
          authorId: 'PaAQ6DjhL1Yl45h1bloNerwPFt82',
          updatedAt: DateTime.now().add(Duration(seconds: 1)),
          mensaje: 'Hay otro caso pendiente',
          tipo: 'text',
          fechaHora: DateTime.now().add(Duration(seconds: 1)));
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(room)
          .collection('messages')
          .add(mensaje2.toMapText());
      ChatMensajes mensaje3 = ChatMensajes(
          //Pregunta si soluciono su problema
          authorId: 'PaAQ6DjhL1Yl45h1bloNerwPFt82',
          updatedAt: DateTime.now().add(Duration(seconds: 2)),
          mensaje: 'Tu caso es el segundo en la cola',
          tipo: 'text',
          fechaHora: DateTime.now().add(Duration(seconds: 2)));
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(room)
          .collection('messages')
          .add(mensaje3.toMapText());
    }
  }
}
