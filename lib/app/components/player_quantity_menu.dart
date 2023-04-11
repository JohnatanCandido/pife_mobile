import 'package:flutter/material.dart';

class PlayerQuantityMenu extends StatelessWidget {

  const PlayerQuantityMenu({super.key, required this.onChanged, required this.selectedNumber});

  final List<int> opponentNumber = const [1, 2, 3, 4];
  final int? selectedNumber;

  final void Function(int? numberOfOpponents) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
            isExpanded: true,
            value: selectedNumber,
            items: opponentNumber.map((e) => DropdownMenuItem(value: e, child: Text('$e Oponentes'))).toList(),
            onChanged: onChanged
          );
  }
}
