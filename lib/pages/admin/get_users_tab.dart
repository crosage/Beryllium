// import 'dart:convert';
// import 'dart:math';
// import 'package:dio/dio.dart';
// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:blockchain/service/request_with_token.dart';
// import '../../utils/config.dart';
//
// class getUsersTab extends StatefulWidget {
//   final int index;
//   final Function() onClose;
//
//   getUsersTab({required this.index, required this.onClose});
//
//   @override
//   _getUsersTabState createState() => _getUsersTabState();
// }
//
// class _getUsersTabState extends State<getUsersTab> {
//   String data = 'Loading...';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     try {
//       Response getResponse= await httpHelper.postRequest(BaseUrl+"/api/user/login",postData);
//       Map<String, dynamic> responseData = jsonDecode(getResponse.toString());
//       if (response.statusCode == 200) {
//         setState(() {
//           data = response.body;
//         });
//       } else {
//         setState(() {
//           data = 'Failed to load data';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         data = 'Error: $e';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Tab(
//       text: Text('Document ${widget.index}'),
//       semanticLabel: 'Document #${widget.index}',
//       icon: const FlutterLogo(),
//       body: Container(
//         color: Colors.accentColors[Random().nextInt(Colors.accentColors.length)],
//         child: Center(child: Text(data)),
//       ),
//       onClosed: widget.onClose,
//     );
//   }
// }
