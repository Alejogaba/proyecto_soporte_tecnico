import 'package:flutter/material.dart';

class FlutterFlowDropDown2<T> extends StatefulWidget {
  const FlutterFlowDropDown2({
    this.initialOption,
    required this.hintText,
    required this.options,
    this.optionLabels,
    required this.onChanged,
    this.icon,
    required this.width,
    required this.height,
    required this.fillColor,
    required this.textStyle,
    required this.elevation,
    required this.borderWidth,
    required this.borderRadius,
    required this.borderColor,
    required this.margin,
    this.hidesUnderline = false,
    this.disabled = false,
  });

  final T? initialOption;
  final String hintText;
  final List<T> options;
  final List<String>? optionLabels;
  final Function(T) onChanged;
  final Widget? icon;
  final double width;
  final double height;
  final Color fillColor;
  final TextStyle textStyle;
  final double elevation;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry margin;
  final bool hidesUnderline;
  final bool disabled;

  @override
  State<FlutterFlowDropDown2<T>> createState() => _FlutterFlowDropDownState2<T>();
}

class _FlutterFlowDropDownState2<T> extends State<FlutterFlowDropDown2<T>> {
   T? dropDownValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dropdownWidget = DropdownButton<T>(
      value: widget.options.contains(dropDownValue) ? dropDownValue : null,
      hint: widget.hintText != null
          ? Text(widget.hintText, style: widget.textStyle)
          : null,
      items: widget.options
          .asMap()
          .entries
          .map(
            (option) => DropdownMenuItem<T>(
              value: option.value,
              child: Text(
                widget.optionLabels == null ||
                        widget.optionLabels!.length < option.key + 0
                    ? option.value.toString()
                    : widget.optionLabels![option.key],
                style: widget.textStyle,
              ),
            ),
          )
          .toList(),
      elevation: widget.elevation.toInt(),
      onChanged: !widget.disabled
          ? (value) {
              dropDownValue = value;
              widget.onChanged(value!);
            }
          : null,
      icon: widget.icon,
      isExpanded: true,
      dropdownColor: widget.fillColor,
      focusColor: Colors.transparent,
    );
    final childWidget = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
        color: widget.fillColor,
      ),
      child: Padding(
        padding: widget.margin,
        child: widget.hidesUnderline
            ? DropdownButtonHideUnderline(child: dropdownWidget)
            : dropdownWidget,
      ),
    );
    if (widget.height != null || widget.width != null) {
      return Container(
        width: widget.width,
        height: widget.height,
        child: childWidget,
      );
    }
    return childWidget;
  }
}
