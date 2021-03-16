import 'package:food_card_app/models/food_item.dart';

class CartProvider {
  List<FoodItem> foodItems = [];

  List<FoodItem> addToList(FoodItem foodItem) {
    bool ispresent = false;
    if (foodItems.length > 0) {
      for (int i = 0; i < foodItems.length; i++) {
        if (foodItems[i].id == foodItem.id) {
          increaseItemQuantity(foodItem);
          ispresent = true;
          break;
        } else {
          ispresent = false;
        }
      }
      if (!ispresent) {
        foodItems.add(foodItem);
      }
    } else {
      foodItems.add(foodItem);
    }

    return foodItems;
  }

  void increaseItemQuantity(FoodItem foodItem) {
    return foodItem.incrementQuantity();
  }

  void decreaseItemQuantity(FoodItem foodItem) {
    return foodItem.decrementQuantity();
  }

  List<FoodItem> removeFromList(FoodItem foodItem) {
    if (foodItem.quantity > 1) {
      decreaseItemQuantity(foodItem);
    } else {
      foodItems.remove(foodItem);
    }

    return foodItems;
  }
}
