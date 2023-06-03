import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NuevoReporteModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for pricePerNight widget.
  TextEditingController? pricePerNightController;
  String? Function(BuildContext, String?)? pricePerNightControllerValidator;
  // State field(s) for notes widget.
  TextEditingController? notesController;
  String? Function(BuildContext, String?)? notesControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    pricePerNightController?.dispose();
    notesController?.dispose();
  }

  /// Additional helper methods are added here.

}
