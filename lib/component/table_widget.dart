import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Material,InkWell;

class TableWidget extends StatefulWidget {
  final List<dynamic> headers;
  final List<List<dynamic>> data;

  TableWidget({Key? key, required this.headers, required this.data})
      : super(key: key);

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.data.length + 1, // +1 for header row
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          // Header row
          return Material(
              child:InkWell(
            onTap: () {
              // Handle header row click
              print('Header clicked');
            },
            child: Container(
              // color: Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: widget.headers.map((header) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      header,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ));
        } else {
          // Data rows
          final rowData = widget.data[index - 1]; // Subtract 1 to account for header row
          return GestureDetector(
            onTap: () {
              // Handle data row click
              print('Row $index clicked');
            },
            child: Container(
              // color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: rowData.map((item) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}
