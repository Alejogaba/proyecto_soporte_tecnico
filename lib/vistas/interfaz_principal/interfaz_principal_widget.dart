
import 'package:auto_size_text/auto_size_text.dart';

import '../../auth/firebase_auth/auth_util.dart';
import '../login/login_widget.dart';
import '../../model/dependencias.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'interfaz_principal_model.dart';
export 'interfaz_principal_model.dart';

class InterfazPrincipalWidget extends StatefulWidget {
  const InterfazPrincipalWidget({Key? key}) : super(key: key);

  @override
  _InterfazPrincipalWidgetState createState() =>
      _InterfazPrincipalWidgetState();
}

class _InterfazPrincipalWidgetState extends State<InterfazPrincipalWidget> {
  late InterfazPrincipalModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InterfazPrincipalModel());

    _model.textController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return SafeArea(
      bottom: false,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: 270.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Color(0x39000000),
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:4.0),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          4.0, 4.0, 0.0, 0.0),
                                      child: Image.asset(
                                        'assets/images/chimichagua-removebg-preview-transformed.png',
                                        width: 71.1,
                                        height: 75.0,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 4.0, 0.0, 0.0),
                                      child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          'Alcaldia de Chimichagua',
                                          minFontSize: 18,
                                          maxFontSize: 22,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Urbanist',
                                                color: FlutterFlowTheme.of(context)
                                                    .primaryText,
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        AutoSizeText(
                                          'Servicio técnico',
                                          minFontSize: 14,
                                          maxFontSize: 16,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Urbanist',
                                                color: FlutterFlowTheme.of(context)
                                                    .primaryText,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.person_add,
                                        color: FlutterFlowTheme.of(context).tertiary,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        await authManager.signOut();
                                        await Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginWidget(),
                                          ),
                                          (r) => false,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.logout,
                                        color: FlutterFlowTheme.of(context).tertiary,
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Bienvenido',
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: FlutterFlowTheme.of(context).tertiary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 0.0, 4.0, 0.0),
                                    child: TextFormField(
                                      controller: _model.textController,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Buscar dependencia...',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Urbanist',
                                              color: FlutterFlowTheme.of(context)
                                                  .grayIcon,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search_sharp,
                                          color:
                                              FlutterFlowTheme.of(context).grayIcon,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Urbanist',
                                            color:
                                                FlutterFlowTheme.of(context).tertiary,
                                          ),
                                      validator: _model.textControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 8.0, 0.0),
                                  child: FFButtonWidget(
                                    onPressed: () {
                                      print('Button pressed ...');
                                    },
                                    text: 'Buscar',
                                    options: FFButtonOptions(
                                      width: 100.0,
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Urbanist',
                                            color: Colors.white,
                                          ),
                                      elevation: 2.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                    child: StreamBuilder<List<Dependencia>>(
                      stream: FirebaseFirestore.instance
                          .collection('dependencias')
                          .snapshots()
                          .map((QuerySnapshot querySnapshot) {
                        List<Dependencia> dependencias = [];
                        querySnapshot.docs.forEach((doc) => dependencias.add(
                            Dependencia.fromMap(doc.data() as Map<String, dynamic>)));
                        return dependencias;
                      }),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: CircularProgressIndicator(
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          );
                        }
                        List<Dependencia> listViewPropertiesRecordList =
                            snapshot.data!;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: listViewPropertiesRecordList.length,
                          itemBuilder: (context, listViewIndex) {
                            final listViewPropertiesRecord =
                                listViewPropertiesRecordList[listViewIndex];
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 12.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      color: Color(0x32000000),
                                      offset: Offset(0.0, 2.0),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Hero(
                                        tag: valueOrDefault<String>(
                                          listViewPropertiesRecord.urlImagen,
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/sample-app-property-finder-834ebu/assets/jyeiyll24v90/pixasquare-4ojhpgKpS68-unsplash.jpg' +
                                              '$listViewIndex',
                                        ),
                                        transitionOnUserGestures: true,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0.0),
                                            bottomRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: valueOrDefault<String>(
                                              listViewPropertiesRecord.urlImagen,
                                              'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/sample-app-property-finder-834ebu/assets/jyeiyll24v90/pixasquare-4ojhpgKpS68-unsplash.jpg',
                                            ),
                                            width: double.infinity,
                                            height: 190.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 12.0, 16.0, 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                listViewPropertiesRecord.nombre
                                                    .maybeHandleOverflow(
                                                  maxChars: 36,
                                                  replacement: '…',
                                                ),
                                                style: FlutterFlowTheme.of(context)
                                                    .headlineSmall,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                listViewPropertiesRecord.nombre
                                                    .maybeHandleOverflow(
                                                  maxChars: 90,
                                                  replacement: '…',
                                                ),
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      StreamBuilder<List<ReviewsRecord>>(
                                        stream: queryReviewsRecord(
                                          queryBuilder: (reviewsRecord) =>
                                              reviewsRecord.where('propertyRef',
                                                  isEqualTo: listViewPropertiesRecord
                                                      .nombre),
                                        ),
                                        builder: (context, snapshot) {
                                          // Customize what your widget looks like when it's loading.
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child: CircularProgressIndicator(
                                                  color: FlutterFlowTheme.of(context)
                                                      .primary,
                                                ),
                                              ),
                                            );
                                          }
                                          List<ReviewsRecord>
                                              containerReviewsRecordList =
                                              snapshot.data!;
                                          return Container(
                                            height: 40.0,
                                            decoration: BoxDecoration(),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 24.0, 12.0),
                                              child:
                                                  StreamBuilder<List<ReviewsRecord>>(
                                                stream: queryReviewsRecord(
                                                  queryBuilder: (reviewsRecord) =>
                                                      reviewsRecord.where(
                                                          'propertyRef',
                                                          isEqualTo:
                                                              listViewPropertiesRecord
                                                                  .nombre),
                                                  singleRecord: true,
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<ReviewsRecord>
                                                      ratingBarReviewsRecordList =
                                                      snapshot.data!;
                                                  final ratingBarReviewsRecord =
                                                      ratingBarReviewsRecordList
                                                              .isNotEmpty
                                                          ? ratingBarReviewsRecordList
                                                              .first
                                                          : null;
                                                  return Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [],
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
      
                ],
              ),
            ),
            /*GNav(
    
      haptic: true, // haptic feedback
      tabBorderRadius: 16, 
      tabActiveBorder: Border.all(color:  FlutterFlowTheme.of(context).primary, width: 1), // tab button border
      backgroundColor: FlutterFlowTheme.of(context).primary,
      tabShadow: [BoxShadow(color: FlutterFlowTheme.of(context).primary.withOpacity(0.5), blurRadius: 8)], // tab button shadow
      curve: Curves.easeOutExpo, // tab animation curves
      duration: Duration(milliseconds: 900), // tab animation duration
      gap: 8, // the tab button gap between icon and text 
      color: FlutterFlowTheme.of(context).tertiary.withOpacity(0.7), // unselected icon color
      activeColor: FlutterFlowTheme.of(context).tertiary, // selected icon and text color
      iconSize: 30, // tab button icon size
      tabBackgroundColor: FlutterFlowTheme.of(context).tertiary.withOpacity(0.1), // selected tab background color
      padding: EdgeInsets.symmetric(horizontal: 150, vertical: 10), // navigation bar padding
      tabs: [
      GButton(
        icon: Icons.home,
        text: 'Home',
        onPressed: () async {
           await Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ConversacionesWidget(),
                                        ),
                                       
                                      );
        },
      ),
      GButton(
        icon: Icons.heart_broken,
        text: 'Likes',
      ),
      
      ]
    )*/
          ],
        ),
      ),
    );
  }
}