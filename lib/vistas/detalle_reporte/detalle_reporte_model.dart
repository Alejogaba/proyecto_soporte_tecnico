import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class DetalleReporteModel extends FlutterFlowModel {
  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {}
  TextEditingController? textControllerDescripcionReporte;
  String? Function(BuildContext, String?)? textController10Validator =
      (p0, p1) {
    if (p1 == null || p1.isEmpty) {
      return 'No deje este campo vacío.';
    }
    return null;
  };

  /// Additional helper methods are added here.
}
