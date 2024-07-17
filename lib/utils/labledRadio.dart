import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/customMessage.dart';

class LabledRadio extends StatelessWidget {
  const LabledRadio({
    Key? key,
    required this.customMessage,
    required this.padding,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final CustomMessages customMessage;
  final EdgeInsets padding;
  final int groupValue;
  final int value;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        } else {
          onChanged(-1);
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      dense: true,
      tileColor: const Color(0xffF5F5F5),
      title: Text(
        customMessage.title,
        style: const TextStyle(
            fontSize: 12,
            color: Color(0xff999999),
            fontFamily: 'Helvetica-Neue2'),
      ),
      subtitle: Text(
        customMessage.message,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 14,
            color: Color(0xff333333),
            fontFamily: 'Helvetica-Neue2'),
      ),
      trailing: Radio<int>(
        groupValue: groupValue,
        fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return Theme.of(context).primaryColor;
        }),
        value: value,
        toggleable: true,
        onChanged: (int? newValue) {
          // print(newValue);
          onChanged(newValue!);
        },
      ),
    );
  }
}
