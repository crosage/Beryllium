import 'package:fluent_ui/fluent_ui.dart';

class SearchTool extends StatefulWidget {
  final Function(String) onSelected;
  final List<String> suggestions;

  const SearchTool(
      {Key? key, required this.onSelected, required this.suggestions})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchTool> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredOptions = [];
  OverlayEntry? _overlayEntry;
  List<OverlayEntry> _overlayEntries = [];

  @override
  void initState() {
    super.initState();
  }

  void removeAllOverlays() {
    for (var entry in _overlayEntries) {
      entry.remove();
    }
    _overlayEntries.clear(); // 清空列表
  }

  void _updateFilteredOptions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = [];
        if (_overlayEntry != null) {
          removeAllOverlays();
          _overlayEntry = null;
        }
      } else {
        _filteredOptions = widget.suggestions
            .where(
                (option) => option.toLowerCase().contains(query.toLowerCase()))
            .toList();
        showOverlayFunction(context);
      }
    });
  }

  void showOverlayFunction(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: offset.dy + renderBox.size.height,
          left: offset.dx,
          child: _buildOverlayContent(),
        );
      },
    );
    _overlayEntries.add(_overlayEntry!);
    overlayState.insert(_overlayEntry!);
    // overlayState.insert(_overlayEntry!);
  }

  Widget _buildOverlayContent() {
    return Center(
      child: Container(
        height: 500,
        width: 3000,
        child: Card(
          // elevation: 4,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredOptions.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_filteredOptions[index]),
                onPressed: () {
                  _searchController.text = _filteredOptions[index];
                  widget.onSelected(_filteredOptions[index]);
                  _updateFilteredOptions('');
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 10.0),
            Icon(FluentIcons.search),
            SizedBox(width: 10.0),
            Flexible(
              child: TextBox(
                controller: _searchController,
                placeholder: "在这里进行搜索",
                onChanged: (value) {
                  _updateFilteredOptions(value);
                },
                onSubmitted: (value) {
                  if (_overlayEntry != null) {
                    removeAllOverlays();
                    _overlayEntry = null;
                  }
                  widget.onSelected(value);
                },
              ),
            ),
            IconButton(
              icon: Icon(FluentIcons.clear),
              onPressed: () {
                _searchController.clear();
                _updateFilteredOptions('');
              },
            ),
            SizedBox(width: 10.0),
          ],
        ),
      ],
    );
  }
}
