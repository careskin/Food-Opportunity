import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/food_provider.dart';

class AddingFoodScreen extends StatefulWidget {
  @override
  _AddingFoodScreenState createState() => _AddingFoodScreenState();
}

class _AddingFoodScreenState extends State<AddingFoodScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // レシート画像から商品名を認識する機能をここに追加 (仮データを使用)
      _addFoodItem('Sample Food', DateTime.now().add(Duration(days: 7)));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _addFoodItem(String name, DateTime expirationDate) {
    final foodProvider = Provider.of<FoodProvider>(context, listen: false);
    foodProvider.addFood(FoodItem(name: name, expirationDate: expirationDate));
    _nameController.clear();
    _selectedDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adding Food')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Receipt Image'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Food Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No date selected'
                        : 'Expires on: ${_selectedDate!.toLocal()}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty && _selectedDate != null) {
                  _addFoodItem(_nameController.text, _selectedDate!);
                }
              },
              child: Text('Add Food Item'),
            ),
          ],
        ),
      ),
    );
  }
}
