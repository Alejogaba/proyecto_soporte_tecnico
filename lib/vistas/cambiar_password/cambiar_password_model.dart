import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class CambiarPasswordModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailAddress widget.
  TextEditingController emailAddressController = TextEditingController();
  /// Initialization and disposal methods.
  late bool passwordVisibility;

  void initState(BuildContext context) {
     passwordVisibility = false;
  }

  void dispose() {
    emailAddressController?.dispose();
  }

  /// Additional helper methods are added here.

}
