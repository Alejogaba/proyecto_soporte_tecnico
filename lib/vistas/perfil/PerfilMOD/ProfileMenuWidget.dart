import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor =
        isDark ? Color.fromARGB(255, 10, 82, 7) : Color.fromARGB(255, 0, 0, 0);
    return Container(
      height: 70,
      width: 380,
      child: Card(
        color: Color.fromARGB(255, 233, 235, 238),
        elevation: 2,
        child: ListTile(
          onTap: onPress,
          onLongPress: () {
            print('Funcionalidad extra');
          },
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: iconColor.withOpacity(0.2),
            ),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.apply(color: Color.fromARGB(255, 0, 0, 0))),
          trailing: endIcon
              ? Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                  ),
                  child: const Icon(LineAwesomeIcons.angle_right,
                      size: 18.0, color: Color.fromARGB(255, 0, 0, 0)))
              : null,
        ),
      ),
    );
  }
}
