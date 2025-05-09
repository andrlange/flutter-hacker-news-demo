import 'package:flutter/material.dart';
import '../../models/item_model.dart';

class ListElement extends StatelessWidget {
  final ItemModel? item;
  final bool isPlaceholder;

  const ListElement({
    super.key,
    required this.item,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: Card(
        color: Colors.white70,
        child: ListTile(
          trailing: Column(
            children: [
              !isPlaceholder
                  ? Icon(Icons.comment)
                  : Container(
                    height: 24.0,
                    width: 24.0,
                    decoration: BoxDecoration(color: Colors.white),
                  ),

              !isPlaceholder
                  ? Text('${item?.descendants}')
                  : Container(
                    margin: EdgeInsets.only(top: 4.0),
                    height: 12.0,
                    width: 16.0,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
            ],
          ),
          title:
              !isPlaceholder
                  ? Text(item?.title ?? 'No title')
                  : Container(
                    margin: const EdgeInsets.all(2.0),
                    height: 24.0,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
          subtitle:
              !isPlaceholder
                  ? Text('${item?.score} votes')
                  : Container(
                    margin: const EdgeInsets.all(2.0),
                    height: 12.0,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
          onTap: () {},
        ),
      ),
    );
  }
}
