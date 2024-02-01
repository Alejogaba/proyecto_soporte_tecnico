import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/main.dart';
import 'package:login2/model/chatBot.dart';
import 'package:login2/model/chat_mensajes.dart';
import 'package:login2/model/usuario.dart';
import 'package:rxdart/rxdart.dart';

import 'schema/chats_record.dart';

class ControladorChat {
  Stream<ChatMensajes?> obtenerUltimoMensajeChat(String uidChat) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(uidChat)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.docs[0].data();
      final result = ChatMensajes.fromMap(data);
      log('ultimo mensaje obtenerUltimoMensajeChat: ${result.mensaje}');
      return result;
    }).doOnError((p0, p1) {
      log('obtenerUltimoMensajeChat Error: ${p0.toString()}');
      p0.printError();
      return null;
    });
  }

  Stream<ChatMensajes?> obtenerRoom(String uidChat) {
    try {
      return FirebaseFirestore.instance
          .collection('rooms')
          .doc(uidChat.trim())
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null) {
            final result = ChatMensajes.fromMap(data);
            debugPrint('ultimo mensaje obtenerRoom: ${result.uidRoom}');
            return result;
          } else {
            return null;
          }
        } else {
          return null;
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      return Stream.value(null);
    }
  }

  Stream<List<ChatsRecord>> obtenerListaChatStream(String uid) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .where('userIds', arrayContains: uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<ChatsRecord> chats = [];
      for (var doc in querySnapshot.docs) {
        var reference = doc.reference;
        var chat = ChatsRecord.collection;
      }
      querySnapshot.docs.forEach((doc) async {});
      log('Chat leght: ' + chats.length.toString());
      return chats;
    });
  }

  Future<List<ChatBot>> obtenerRespuestasChatBotFirebase() async {
    QuerySnapshot querySnapshot;

    querySnapshot =
        await FirebaseFirestore.instance.collection('chatbot').get();

    List<ChatBot> casos = querySnapshot.docs
        .map((doc) => ChatBot.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return casos;
  }

  Future<void> eliminarRespuestaChatBot(String? uid) async {
    CollectionReference usuarios =
        FirebaseFirestore.instance.collection('chatbot');
    return usuarios
        .doc(uid)
        .delete()
        .then((value) => print("Eliminar Respuesta"))
        .catchError(
            (error) => print("Error al eliminar repuesta chatbot: $error"));
  }

  addModChatBotRespuesta(ChatBot chatbotRespuesta) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      if (chatbotRespuesta.uid.trim().isEmpty) {
        await _db
            .collection('chatbot')
            .add(chatbotRespuesta.toMap())
            .then((value) {
          _db.collection('chatbot').doc(value.id).update({'uid': value.id});
        });
        return 'ok';
      } else {
        await _db
            .collection('chatbot')
            .doc(chatbotRespuesta.uid)
            .update(chatbotRespuesta.toMap());
        return 'ok';
      }
    } catch (e) {
      return 'error';
    }
  }

  Future<List<ChatMensajes>> obetnerRoomsPorUID(String uid) async {
    QuerySnapshot querySnapshot;

    querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('userIds', arrayContainsAny: [uid.trim()]).get();

    List<ChatMensajes> rooms = querySnapshot.docs
        .map((doc) => ChatMensajes.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return rooms;
  }

  Future<ChatMensajes?> obtenerUltimoEnCola({String uidTecnico=''}) async {
    try {
      late final snapshot;
      if (uidTecnico.isNotEmpty) {
        snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('uidTecnico',isEqualTo: uidTecnico)
          .where('finalizado', isEqualTo: false)
          .orderBy('turno', descending: true)
          .limit(1)
          .get();
      } else {
        snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('finalizado', isEqualTo: false)
          .orderBy('turno', descending: true)
          .limit(1)
          .get();
      }
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs[0].data();
        final result = ChatMensajes.fromMap(data);
        log('ultimo mensaje ObtenerUltimoenCola: $result');
        return result;
      } else {
        return null; // No se encontraron mensajes
      }
    } catch (e) {
      log('Error al obtener el último mensaje: $e');
      return null;
    }
  }

  Future<ChatMensajes?> obtenerUltimoEnColaUrgente(
      {String uidTecnico = ''}) async {
    try {
      late final snapshot;
      if (uidTecnico.isNotEmpty) {
        snapshot = await FirebaseFirestore.instance
            .collection('rooms')
            .where('uidTecnico', isEqualTo: uidTecnico)
            .where('finalizado', isEqualTo: false)
            .where('prioridad', isEqualTo: true)
            .orderBy('turno', descending: true)
            .limit(1)
            .get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection('rooms')
            .where('finalizado', isEqualTo: false)
            .where('prioridad', isEqualTo: true)
            .orderBy('turno', descending: true)
            .limit(1)
            .get();
      }

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs[0].data();
        final result = ChatMensajes.fromMap(data);
        log('ultimo mensaje obtenerUltimoEnColaUrgente: $result');
        return result;
      } else {
        return null; // No se encontraron mensajes
      }
    } catch (e) {
      log('Error al obtener el último mensaje: $e');
      return null;
    }
  }

  Future<int> primerMensaje(String roomUID) async {
    Usuario? usuarioActual = await AuthHelper().cargarUsuarioDeFirebase();
    if (usuarioActual != null && usuarioActual.role == 'admin') {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomUID.trim())
            .collection('messages')
            .where('authorId', isEqualTo: usuarioActual.uid.toString().trim())
            .get();

        int count = querySnapshot.size;
        print('Cantidad mensajes ' + count.toString());
        return count;
      } catch (e) {
        // Maneja aquí los errores según sea necesario
        print('error al contar mensajes: ' + e.toString());
        return 1;
      }
    } else {
      return 1;
    }
  }

  Stream<ChatMensajes?> obtenerPuestoEnColaById(String uidUsuario) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .where('userIds', arrayContains: uidUsuario.trim())
        .orderBy('turno', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.length > 0) {
        final data = snapshot.docs[0].data();
        final result = ChatMensajes.fromMap(data);
        log('ultimo mensaje obtenerPuestoEnColaById: $result');
        return result;
      } else {
        return null;
      }
    }).doOnError((p0, p1) {
      log('Error obtenerPuestoEnColaById: ${p0.toString()}');
      p0.printError();
      return null;
    });
  }

  Future<ChatMensajes?> obtenerPuestoEnColaByIdFuture(String uidUsuario) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('userIds', arrayContains: uidUsuario.trim())
          .orderBy('turno', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs[0].data();
        final result = ChatMensajes.fromMap(data);
        debugPrint(
            'ultimo mensaje obtenerPuestoEnColaByIdFuture: $result'); // Utiliza debugPrint en lugar de log para imprimir mensajes en la consola durante el desarrollo
        return result;
      } else {
        return null;
      }
    } catch (e) {
      log("Error en obtenerPuestoEnColaByIdFuture: " + e.toString());
      debugPrint(
          'Error: $e'); // Utiliza debugPrint en lugar de log para imprimir mensajes en la consola durante el desarrollo
      return null;
    }
  }

  Future<ChatMensajes?> obtenerImagenCaso(String uidActivo) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('imagenes')
          .doc(uidActivo)
          .get();
      if (snapshot.exists) {
        final result = ChatMensajes.fromMapImage(snapshot.data()!);
        
        return result;
      } else {
        return null;
      }
    } catch (e) {
      // Manejar cualquier excepción potencial aquí
      print('Error: $e');
      return null;
    }
  }

  Future<void> disminuirTurno() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('finalizado', isEqualTo: false)
        .get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      int turno = document.get('turno') ?? 0;
      await document.reference.update({'turno': turno - 1});
    }
  }

  Future<void> aumentarTurno({String uidTecnico = ''}) async {
    late QuerySnapshot querySnapshot;
    if (uidTecnico.isNotEmpty) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('uidTecnico', isEqualTo: uidTecnico)
          .where('finalizado', isEqualTo: false)
          .where('prioridad', isNotEqualTo: true)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('finalizado', isEqualTo: false)
          .where('prioridad', isNotEqualTo: true)
          .get();
    }
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      int turno = document.get('turno') ?? 0;
      await document.reference.update({'turno': turno + 1});
    }
  }

  removeRoom(String uidRoom) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot subcollections = await _db.collection('messages').get();
      // Elimina las subcolecciones de manera recursiva
      for (QueryDocumentSnapshot subcollectionDoc in subcollections.docs) {
        await removeRoom(subcollectionDoc.reference.id);
      }
      await _db.collection("rooms").doc(uidRoom).delete();
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  Future<String?> buscarChat(
      String uidusuarioAdmin, String uidOtroUsuario) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('userIds', isEqualTo: [uidOtroUsuario, uidusuarioAdmin])
          .limit(1)
          .get();

      if (querySnapshot.size > 0) {
        final docSnapshot = querySnapshot.docs[0];
        final uid = docSnapshot.data()['uid'];
        Logger().i('uid de la Room: $uid');
        return uid;
      } else {
        return null;
      }
    } catch (e) {
      print('Error al buscar room: $e');
      return null;
    }
  }

  Future<String?> buscarChatFinalizado(
      String uidusuarioAdmin, String uidOtroUsuario) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('userIds', isEqualTo: [uidOtroUsuario, uidusuarioAdmin])
          .where('finalizado', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.size > 0) {
        final docSnapshot = querySnapshot.docs[0];
        final uid = docSnapshot.data()['uid'];
        Logger().i('uid de la Room: $uid');
        return uid;
      } else {
        return null;
      }
    } catch (e) {
      print('Error al buscar room: $e');
      return null;
    }
  }

  Future<String?> buscarChatAbierto(
      String uidusuarioAdmin, String uidOtroUsuario) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('userIds', isEqualTo: [uidOtroUsuario, uidusuarioAdmin])
          .where('finalizado', isEqualTo: false)
          .limit(1)
          .get();

      if (querySnapshot.size > 0) {
        final docSnapshot = querySnapshot.docs[0];
        final uid = docSnapshot.data()['uid'];
        Logger().i('uid de la Room: $uid');
        return uid;
      } else {
        return null;
      }
    } catch (e) {
      print('Error al buscar room: $e');
      return null;
    }
  }

  Future<List<ChatMensajes>> obetnerRoomsSinFinalizar(
      {String uidSolicitante = ''}) async {
    QuerySnapshot querySnapshot;

    if (uidSolicitante.isEmpty) {
      querySnapshot =
          await FirebaseFirestore.instance.collection('casos').get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('casos')
          .where('finalizado', isEqualTo: false)
          .where('prioridad', isNotEqualTo: true)
          .get();
    }

    List<ChatMensajes> rooms = querySnapshot.docs
        .map((doc) => ChatMensajes.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return rooms;
  }

  Future<String> removerConversacionesRepetidas(
      String roomUID, String userUID) async {
    try {
      ChatMensajes? chatMensajes = await obtenerUltimoEnCola();
      if (chatMensajes != null) {
        FirebaseFirestore _db = FirebaseFirestore.instance;
        await _db
            .collection("rooms")
            .where('uid', isNotEqualTo: roomUID)
            .where('userIds', arrayContains: userUID.trim())
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
        log('Se eliminaron otras conversaciones');
        return 'ok';
      } else {
        return 'No chatMensajes found';
      }
    } catch (e) {
      // Aquí puedes manejar el error según sea necesario
      log('Error eliminando otras conversaciones: $e');
      return 'error';
    }
  }
}
