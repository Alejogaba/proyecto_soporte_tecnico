import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class NuevoReporteModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for pricePerNight widget.
  TextEditingController? pricePerNightController;
  String? Function(BuildContext, String?)? pricePerNightControllerValidator;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';
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
