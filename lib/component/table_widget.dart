import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Material, InkWell;

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
    return Container(
      width: 1000,
      child: ListView.builder(
        itemCount: widget.data.length + 1, // +1 for header row
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            // Header row
            return Column(
              children: [
                Material(
                  child: InkWell(
                    onTap: () {
                      // Handle header row click
                      print('Header clicked');
                    },
                    child: Container(
                      child: Row(
                        children: widget.headers.map((header) {
                          return Container(
                            width: 200,
                            height: 50,
                            child: Center(
                              child: Text(
                                header,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Divider(), // Add a divider below the header row
              ],
            );
          } else {
            // Data rows
            final rowData =
            widget.data[index - 1]; // Subtract 1 to account for header row
            return Column(
              children: [
                Material(
                  child: InkWell(
                    onTap: () {
                      // Handle data row click
                      print('Row $index clicked');
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: rowData.map((item) {
                          return Container(
                            width: 200,
                            height: 50,
                            child: Center(child: Text(item.toString())),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Divider(style: DividerThemeData(thickness: 2),),
              ],
            );
          }
        },
      ),
    );
  }
}
