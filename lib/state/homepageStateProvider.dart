
import 'package:flutter/material.dart';


class HomePageStateProvider extends ChangeNotifier
{

  bool showBottomDrawer = true;
 

  void setShowBottomDrawer(bool value){
    this.showBottomDrawer = value;
    print("\n Bottom Scroll State : "+this.showBottomDrawer.toString());
    notifyListeners();
  }

  List<String> kTopListLink = [
    'Portafolio de servicios'
  ];

 

}