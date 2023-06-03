// // import 'package:flutter/material.dart';
// // import 'package:hive/hive.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();

//   List<Map<String, dynamic>> _items = [];
//   final _shoppingBox = Hive.box('shopping_box');
//   @override
//   void initState() {
//     super.initState();
//     _refreshItems();
//   }

//   void _refreshItems() {
//     final data = _shoppingBox.keys.map((key) {
//       final item = _shoppingBox.get(key);
//       return {"key": key, "name": item["name"], "quantity": item['quantity']};
//     }).toList();
//     setState(() {
//       _items = data.reversed.toList();
//     });
//   }

//   Future<void> _createItem(Map<String, dynamic> newItem) async {
//     // await Hive.openBox('shopping_box');
//     await _shoppingBox.add(newItem);
//     _refreshItems();
//   }

//   void _showForm(BuildContext ctx, int? itemKey) async {
//     showModalBottomSheet(
//         context: ctx,
//         elevation: 5,
//         isScrollControlled: true,
//         builder: (_) => Container(
//               padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(ctx).viewInsets.bottom,
//                   top: 15,
//                   left: 15,
//                   right: 15),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   TextField(
//                     controller: _nameController,
//                     decoration: InputDecoration(hintText: 'Name'),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextField(
//                     controller: _quantityController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(hintText: 'Quantity'),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   ElevatedButton(
//                       onPressed: () async {
//                         _createItem({
//                           "name": _nameController.text,
//                           "quantity": _quantityController
//                         });
//                         _nameController.text = '';
//                         _quantityController.text = '';
//                         Navigator.of(context).pop();
//                       },
//                       child: Text('Create New'))
//                 ],
//               ),
//             ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Local Storage'),
//         ),
//         body: ListView.builder(
//             itemCount: _items.length,
//             itemBuilder: (_, index) {
//               final currentItem = _items[index];
//               return Card(
//                   color: const Color.fromARGB(255, 156, 233, 225),
//                   margin: EdgeInsets.all(10),
//                   elevation: 3,
//                   child: ListTile(
//                     title: Text(currentItem['name']),
//                     subtitle: Text(currentItem['quantity'].toString()),
//                   ));
//             }),
//         floatingActionButton: FloatingActionButton(
//             onPressed: () => _showForm(context, null), child: Icon(Icons.add)));
//   }
// }
