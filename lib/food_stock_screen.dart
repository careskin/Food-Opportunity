import 'package:flutter/material.dart';

class FoodStockScreen extends StatefulWidget {
  final List<Map<String, dynamic>> foodList;

  FoodStockScreen({required this.foodList});

  @override
  _FoodStockScreenState createState() => _FoodStockScreenState();
}

class _FoodStockScreenState extends State<FoodStockScreen> {
  @override
  Widget build(BuildContext context) {
    widget.foodList.sort((a, b) {
      if (a['expirationDate'] == null || b['expirationDate'] == null) {
        return 0;
      }
      return a['expirationDate'].compareTo(b['expirationDate']);
    });

    return Scaffold(
      appBar: AppBar(title: Text('Food Stock')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.foodList.length,
              itemBuilder: (context, index) {
                final food = widget.foodList[index];
                return ListTile(
                  title: Text(food['name']),
                  subtitle: Text(
                      '賞味期限: ${food['expirationDate']?.toLocal().toString()}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // 賞味期限を修正する画面を表示
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          setState(() {
                            food['expirationDate'] = date;
                          });
                        },
                        currentTime: food['expirationDate'] ?? DateTime.now(),
                        minTime: DateTime.now(),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
