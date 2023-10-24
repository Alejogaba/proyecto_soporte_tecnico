import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class RegistrarEquipoModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  // State field(s) for propertyName widget.
  TextEditingController? nombreController;
  String? Function(BuildContext, String?)? propertyNameControllerValidator;
  // State field(s) for propertyAddress widget.
  TextEditingController? marcaController;
  String? Function(BuildContext, String?)? propertyAddressControllerValidator;
  // State field(s) for propertyNeighborhood widget.
  TextEditingController? dependenciaController;
  TextEditingController? barcodeController;
  String? Function(BuildContext, String?)?
      propertyNeighborhoodControllerValidator;
  // State field(s) for propertyDescription widget.
  TextEditingController? detallesController;
  String? Function(BuildContext, String?)?
      propertyDescriptionControllerValidator;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  PropertiesRecord? newProperty;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AmenititiesRecord? amenitiesRecord;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    nombreController?.dispose();
    marcaController?.dispose();
    dependenciaController?.dispose();
    detallesController?.dispose();
  }

  /// Additional helper methods are added here.
}
