import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class ExpenseTile extends StatelessWidget {
  final String title;
  final String trailing;
  final void Function(BuildContext)? onEditPressed;
  final void Function(BuildContext)? onDeletePressed;

   ExpenseTile({super.key, required this.title, required this.trailing, this.onEditPressed, this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
          // settings option
           SlidableAction(onPressed: onEditPressed,icon: Icons.settings,backgroundColor: Colors.grey,borderRadius: BorderRadius.circular(4),),
          //delete option
           SlidableAction(onPressed: onDeletePressed,icon: Icons.delete,backgroundColor: Colors.red,borderRadius: BorderRadius.circular(4),)

      ]),
      child: ListTile(
        title: Text(title),
        trailing: Text(trailing),
      ),
    );
  }
}