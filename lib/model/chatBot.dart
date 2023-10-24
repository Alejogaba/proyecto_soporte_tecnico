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
import '../auth/firebase_auth/auth_helper.dart';
import '../utils/utilidades.dart';
import 'usuario.dart';

class ChatBot {
   List<String> _intents = [
    "pc no enciende",
    "computador no prende",
    "pc no prende",
    "computador no enciende",
    "se demora",
    "cuando viene el tecnico"
  ];
  List<String> _responses = [
    "Entiendo que estás experimentando problemas para encender tu computadora. Aquí tienes algunos pasos básicos que puedes seguir para intentar solucionar el problema:\n\n1. ¿Tu computadora está conectada a una toma de corriente que funciona y el cable de alimentación está correctamente enchufado? 🔌",
    "Entiendo que estás experimentando problemas para encender tu computadora. Aquí tienes algunos pasos básicos que puedes seguir para intentar solucionar el problema:\n\n1. ¿Tu computadora está conectada a una toma de corriente que funciona y el cable de alimentación está correctamente enchufado? 🔌",
    "Entiendo que estás experimentando problemas para encender tu computadora. Aquí tienes algunos pasos básicos que puedes seguir para intentar solucionar el problema:\n\n1. ¿Tu computadora está conectada a una toma de corriente que funciona y el cable de alimentación está correctamente enchufado? 🔌",
    "Entiendo que estás experimentando problemas para encender tu computadora. Aquí tienes algunos pasos básicos que puedes seguir para intentar solucionar el problema:\n\n1. ¿Tu computadora está conectada a una toma de corriente que funciona y el cable de alimentación está correctamente enchufado? 🔌",
    "Lamento escuchar que el técnico se está demorando. A veces, los retrasos pueden ocurrir debido a circunstancias imprevistas.😕",
    "Lamento la demora en la llegada del técnico. ¿Te gustaría que verifique su horario estimado de llegada? 🕒"
  ];
  int id;
  String respuesta;

  ChatBot({this.id=0, this.respuesta='Lo siento, no entiendo tu solicitud.'});

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

  Future<ChatBot> handleMessageChatBot(String message,Activo? activo) async {
    for (int i = 0; i < _intents.length; i++) {
      if (message.toLowerCase().contains(_intents[i].toLowerCase())) {
        return ChatBot(id: i + 1, respuesta: _responses[i]);
      }
    }
    if (activo != null) {
      String mensajeExtendido = "$message ${activo!.nombre.split(' ')[0]}";
      for (int i = 0; i < _intents.length; i++) {
        if (mensajeExtendido.toLowerCase().contains(_intents[i].toLowerCase())) {
          return ChatBot(id: i + 1, respuesta: _responses[i]);
        }
      }
    }

    return ChatBot(id: 0, respuesta: "Lo siento, no entiendo tu solicitud.");
  }

  Future abrirConversacionesTecnicos(
      FirebaseAuth auth, Caso? caso, String activo, String dependencia,
      {ChatMensajes? imagen}) async {
    List<Usuario> usuariosObtenidos = await UserHelper().obtenerUsuarios();
    log('lista tecnicos: ' + usuariosObtenidos.toString());
    if (usuariosObtenidos.length > 0) {
      for (var element in usuariosObtenidos) {
        if (element.role == 'admin' && element.uid != auth.currentUser!.uid) {
          log('tecnico: ' + element.nombre.toString());
          types.User otheruser = types.User(id: element.uid!.trim());

          types.Room room;
          room = await FirebaseChatCore.instance.createRoom(otheruser);
          String? tieneChatFinalizado = await ControladorChat()
              .buscarChatFinalizado(element.uid!, auth.currentUser!.uid);
          if (tieneChatFinalizado != null) {
            await FirebaseChatCore.instance.deleteRoom(room.id);
            room = await FirebaseChatCore.instance.createRoom(otheruser);
          }

          final collectionRef =
              FirebaseFirestore.instance.collection('rooms').doc(room.id);
          ChatMensajes mensaje1 = ChatMensajes(
              authorId: auth.currentUser!.uid.trim(),
              updatedAt: DateTime.now(),
              mensaje: 'Requiero servicio técnico para $activo',
              tipo: 'text',
              fechaHora: DateTime.now());
          await FirebaseFirestore.instance
              .collection('rooms')
              .doc(room.id)
              .collection('messages')
              .add(mensaje1.toMapText());
          if (caso != null) {
            ChatMensajes mensaje2 = ChatMensajes(
                authorId: auth.currentUser!.uid.trim(),
                updatedAt: DateTime.now().add(Duration(seconds: 1)),
                mensaje: '${caso.descripcion}',
                tipo: 'text',
                fechaHora: DateTime.now().add(Duration(seconds: 1)));
            await FirebaseFirestore.instance
                .collection('rooms')
                .doc(room.id)
                .collection('messages')
                .add(mensaje2.toMapText());
          }
          if (caso != null && caso.urlAdjunto.isNotEmpty) {
            ChatMensajes mensaje3 = ChatMensajes(
                height: imagen!.height,
                width: imagen.width,
                size: imagen.size,
                uri: caso.urlAdjunto,
                authorId: auth.currentUser!.uid.trim(),
                updatedAt: DateTime.now().add(Duration(seconds: 2)),
                mensaje: 'Archivo_adjunto.jpg',
                fechaHora: DateTime.now().add(Duration(seconds: 2)));
            await FirebaseFirestore.instance
                .collection('rooms')
                .doc(room.id)
                .collection('messages')
                .add(mensaje3.toMapImage());
          }
          
                          if(otheruser.id != "PaAQ6DjhL1Yl45h1bloNerwPFt82"){
                            if (caso!=null&&caso.prioridad) {
                            ChatMensajes? chatTurno = await ControladorChat()
                                .obtenerUltimoEnColaUrgente(room.id);
                            await ControladorChat().aumentarTurno();
                           

                            if (chatTurno == null) {
                              await collectionRef.update({
                                'uid': room.id,
                                'sinRespuesta': true,
                                'finalizado': false,
                                'turno': 1,
                                'prioridad': true
                              });
                            } else {
                              await collectionRef.update({
                                'uid': room.id,
                                'sinRespuesta': true,
                                'finalizado': false,
                                'turno': chatTurno.turno!+1,
                                'prioridad': true
                              });
                            }
                          } else {
                            ChatMensajes? chatTurno = await ControladorChat()
                                .obtenerUltimoEnCola(room.id);

                            if (chatTurno == null) {
                              await collectionRef.update({
                                'uid': room.id,
                                'sinRespuesta': true,
                                'finalizado': false,
                                'turno': 1,
                                'prioridad': false
                              });
                            } else {
                              await collectionRef.update({
                                'uid': room.id,
                                'sinRespuesta': true,
                                'finalizado': false,
                                'turno': chatTurno.turno! + 1,
                                'prioridad': false
                              });
                            }
                          }
                          }else{
                            await collectionRef.update({
                                'uid': room.id,
                                'sinRespuesta': true,
                                'finalizado': false,
                              });
                          }
          if (element.fcmToken!.isNotEmpty) {
            Utilidades().sendNotification(element.fcmToken!, 'Nuevo reporte',
                'Un equipo en $dependencia requiere servicio técnico');
          }
        }
      }

      if(caso!=null&&caso.prioridad){
        List<ChatMensajes> listaRooms = await ControladorChat().obetnerRoomsSinFinalizar();
                            for (var element in listaRooms) {
                              await chatBotAdvertencia(element.uidRoom);
                            }
      }

      
      Get.snackbar('Reporte registrado',
          'Se ha registrado correctamente el reporte y se ha notificado a los tecnicos encargados, en breve responderan a su solicitud',
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
}
