import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'food_stock_screen.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddingFoodScreen extends StatefulWidget {
  @override
  _AddingFoodScreenState createState() => _AddingFoodScreenState();
}

class _AddingFoodScreenState extends State<AddingFoodScreen> {
  final List<Map<String, dynamic>> _foodList = [];
  DateTime? _expirationDate;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // ここでレシート画像を処理し、食品名を認識する
      setState(() {
        _foodList.add({
          'name': '食品名（認識済み）', // レシート画像から取得した食品名
          'expirationDate': _expirationDate,
        });
      });
    }
  }

  void _addFoodToStock() {
    // FoodStockにアイテムを追加
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodStockScreen(foodList: _foodList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('食品追加')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('レシート画像を選択'),
          ),
          TextButton(
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                onConfirm: (date) {
                  setState(() {
                    _expirationDate = date;
                  });
                },
                currentTime: DateTime.now(),
                minTime: DateTime.now(),
              );
            },
            child: Text(
                _expirationDate == null
                    ? '賞味期限を選択'
                    : '選択した賞味期限: ${_expirationDate!.toLocal()}',
                style: TextStyle(color: Colors.blue)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _foodList.length,
              itemBuilder: (context, index) {
                final food = _foodList[index];
                return ListTile(
                  title: Text(food['name']),
                  subtitle: Text(
                      '賞味期限: ${food['expirationDate']?.toLocal().toString()}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _addFoodToStock,
            child: Text('Food Stockに追加'),
          ),
        ],
      ),
    );
  }
}
