import 'package:flutter/material.dart';

class ExpansionList extends StatefulWidget {
  @override
  _ExpansionListState createState() => _ExpansionListState();
}

class _ExpansionListState extends State<ExpansionList> {
  List<Item> _data = generateItems(10);

  Widget _buildListPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.headerValue),
                subtitle: Text(item.orderId),
                contentPadding: EdgeInsets.all(10),
              );
            },

            body: ListTile(
              title: Text(item.expandedValue),
              subtitle: Text("ndjenkjcnjnkjenckjenckjdnkc"),
              trailing: Icon(Icons.unfold_less),
              onTap: () {
                setState(() {
                  _data.removeWhere((currentItem) => item == currentItem);
                });
              },
            ),
            isExpanded: item.isExpanded
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SingleChildScrollView(
        child: Container(
          child: _buildListPanel(),
        ),
      ),

    );
  }
}





class Item {
  String expandedValue;
  String headerValue;
  bool isExpanded;
  String orderId;

  Item({this.expandedValue, this.headerValue, this.isExpanded =
  false, this.orderId});
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (index) {
    return Item(
        headerValue: 'Delivered ',
        expandedValue: 'This is the number $index',
        orderId: 'Oder Id:#$index '
    );
  });

}