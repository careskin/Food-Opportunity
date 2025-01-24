import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FoodProvider with ChangeNotifier {
  final List<FoodItem> _foodList = [];

  List<FoodItem> get foodList => _foodList;

  void addFood(FoodItem food) {
    _foodList.add(food);
    notifyListeners();
  }

  void updateFood(FoodItem oldFood, String newName, DateTime newDate) {
    final index = _foodList.indexOf(oldFood);
    if (index != -1) {
      _foodList[index] = FoodItem(name: newName, expirationDate: newDate);
      notifyListeners();
    }
  }
}
