import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/table/pack.dart';
import 'package:pife_mobile/app/components/table/trash.dart';

class TableCenter extends StatefulWidget {
  const TableCenter({super.key});

  @override
  State<TableCenter> createState() => _TableCenterState();
}

class _TableCenterState extends State<TableCenter> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Pack(),
            Container(width: 10,),
            Trash(),
          ],
        )
      ],
    );
  }  
}