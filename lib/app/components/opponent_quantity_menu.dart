import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OpponentQuantityMenu extends StatelessWidget {
  const OpponentQuantityMenu({super.key, required this.onChanged, required this.selectedNumber});

  final List<int> _opponentNumber = const [1, 2, 3, 4];
  final int? selectedNumber;

  final void Function(int? numberOfOpponents) onChanged;


  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      value: selectedNumber,
      items: _opponentNumber.map((e) => DropdownMenuItem(value: e, child: Text(AppLocalizations.of(context)!.opponentNumber(e)))).toList(),
      onChanged: onChanged
    );
  }
}
