import 'package:flutter/material.dart';
// import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('shopping_box');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<Map<String, dynamic>> _items = [];
  final _shoppingBox = Hive.box('shopping_box');
  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _shoppingBox.keys.map((key) {
      final item = _shoppingBox.get(key);
      return {"key": key, "name": item["name"], "quantity": item['quantity']};
    }).toList();
    setState(() {
      _items = data.reversed.toList();
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem);
    _refreshItems();
  }

  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _shoppingBox.put(itemKey, item);
    _refreshItems();
  }

  Future<void> _deleteItem(int itemKey, Map<String, dynamic> item) async {
    await _shoppingBox.delete(itemKey);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An Item has Been Deleted')));
  }

  void _showForm(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _quantityController.text = existingItem['quantity'];
    }
    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Quantity'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (itemKey == null) {
                        _createItem({
                          "name": _nameController.text,
                          "quantity": _quantityController.text
                        });
                        if (itemKey != null) {
                          _updateItem(itemKey, {
                            "name": _nameController.text,
                            "quantity": _quantityController.text.trim()
                          });
                        }
                      }
                      _nameController.text = '';
                      _quantityController.text = '';
                      Navigator.of(context).pop();
                    },
                    child: Text(itemKey == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Local Storage',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color.fromARGB(255, 148, 213, 245),
        ),
        body: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (_, index) {
              final currentItem = _items[index];
              return Card(
                  color: Color.fromARGB(255, 221, 247, 244),
                  margin: EdgeInsets.all(10),
                  elevation: 3,
                  child: ListTile(
                    title: Text(currentItem['name']),
                    subtitle: Text(currentItem['quantity'].toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () =>
                                _showForm(context, currentItem['Key']),
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () => null, icon: Icon(Icons.delete)),
                      ],
                    ),
                  ));
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _showForm(context, null), child: Icon(Icons.add)));
  }
}
