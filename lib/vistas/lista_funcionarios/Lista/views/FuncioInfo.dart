import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../../../backend/controlador_dependencias.dart';
import '../../../../model/dependencias.dart';
import '../../../../model/usuario.dart';

class FuncioInfo extends StatefulWidget {
  const FuncioInfo({Key? key, required this.usuario}) : super(key: key);
  final Usuario usuario;
  @override
  _FuncioInfoState createState() => _FuncioInfoState();
}

final funcionarioReference =
    FirebaseDatabase.instance.reference().child('funcionario');

class _FuncioInfoState extends State<FuncioInfo> {
  late List<Usuario> items;
  bool isMediaUploading1 = false;
  String uploadedFileUrl1 = '';

  bool isMediaUploading2 = false;
  String uploadedFileUrl2 = '';

  late String companySizeValue;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 229, 230),
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 219, 229, 230),
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent, // Navigation bar
          statusBarColor: Color.fromARGB(255, 219, 229, 230), // Status bar
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.network(
                    "${widget.usuario.urlImagen}",
                    width: 135,
                    height: 135,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 222,
                    height: 220,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${widget.usuario.nombre}",
                          style: TextStyle(
                              fontSize: 32,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Text(
                          "${widget.usuario.role}",
                          style: TextStyle(
                              fontSize: 19,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: <Widget>[
                            IconTile(
                              backColor: Color.fromARGB(255, 9, 92, 53),
                              imgAssetPath: "assets/email.png",
                            ),
                            IconTile(
                              backColor: Color.fromARGB(255, 9, 92, 53),
                              imgAssetPath: "assets/call.png",
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              //Lineas
              Container(
                width: MediaQuery.of(context).size.width - 58,
                height: 0.4,
                color: Color.fromARGB(179, 0, 0, 0),
              ),

              Text(
                "Dependencia",
                style: TextStyle(
                    color: Color(0xff242424),
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),
              FutureBuilder<Dependencia?>(
                  future: ControladorDependencias()
                      .cargarDependenciaUID(widget.usuario.area!),
                  builder: (BuildContext context, snapshotDependencia) {
                    if (snapshotDependencia.connectionState ==
                            ConnectionState.done &&
                        snapshotDependencia.data != null) {
                      return Text(
                        snapshotDependencia.data!.nombre.toString(),
                        maxLines: 3,
                        style:
                            TextStyle(color: Color(0xff242424), fontSize: 16),
                      );
                    } else {
                      return Text(
                        '',
                        maxLines: 3,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      );
                    }
                  }),
              SizedBox(
                height: 24,
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.perm_identity,
                            color: Color.fromARGB(255, 9, 92, 53),
                            size: 36,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Datos personales",
                                style: TextStyle(
                                    fontSize: 26,
                                    color: const Color.fromARGB(255, 0, 0, 0)),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "${widget.usuario.email}",
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${widget.usuario.telefono}",
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16),
                              ),
                              Text(
                                "${widget.usuario.fechaNacimiento}",
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              //Lineas
              Container(
                width: MediaQuery.of(context).size.width - 58,
                height: 0.8,
                color: Color.fromARGB(179, 0, 0, 0),
              ),

              Text(
                "Galeria",
                style: TextStyle(
                    color: Color(0xff242424),
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                          color: Color(0xffA5A5A5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Color.fromARGB(255, 119, 119, 119))),
                      child: Image.asset(
                        "assets/interfaz/banner.png",
                        width: 135,
                        height: 135,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconTile extends StatelessWidget {
  final String? imgAssetPath;
  final Color? backColor;

  IconTile({this.imgAssetPath, this.backColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: backColor, borderRadius: BorderRadius.circular(15)),
        child: Image.asset(
          imgAssetPath!,
          width: 20,
        ),
      ),
    );
  }
}
