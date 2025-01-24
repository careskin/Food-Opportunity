import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';
import '../models/food_item.dart';

class FoodStockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);

    // 食品を分類し、各カテゴリで賞味期限の短い順にソート
    final today = DateTime.now();
    final soonExpiring = foodProvider.foodList
        .where((food) => food.expirationDate.isBefore(today.add(Duration(days: 3))))
        .toList()
      ..sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
    final others = foodProvider.foodList
        .where((food) => food.expirationDate.isAfter(today.add(Duration(days: 3))))
        .toList()
      ..sort((a, b) => a.expirationDate.compareTo(b.expirationDate));

    return Scaffold(
      appBar: AppBar(title: Text('Food Stock')),
      body: ListView(
        children: [
          if (soonExpiring.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Expiring Soon (within 3 days)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...soonExpiring.map((food) => _buildFoodItem(context, food)).toList(),
          ],
          if (others.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Other Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...others.map((food) => _buildFoodItem(context, food)).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildFoodItem(BuildContext context, FoodItem food) {
    return ListTile(
      title: Text(food.name),
      subtitle: Text(
        'Expires on: ${food.expirationDate.toLocal().toString().split(' ')[0]}',
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _showEditDialog(context, food);
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, FoodItem food) {
    final nameController = TextEditingController(text: food.name);
    DateTime? selectedDate = food.expirationDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Food Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Food Name'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'No date selected'
                        : 'Expires on: ${selectedDate!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      selectedDate = pickedDate;
                    }
                  },
                  child: Text('Select Date'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && selectedDate != null) {
                Provider.of<FoodProvider>(context, listen: false)
                    .updateFood(food, nameController.text, selectedDate!);
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
