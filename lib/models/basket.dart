import 'package:ephslunch/models/lunch_items.dart';

class Basket {
  static List<MenuItems> basketItems;

  static addBasketItem(MenuItems item) {
    if (Basket.basketItems.contains(item)) {
      return;
    }

    Basket.basketItems.add(item);
  }

  static removeBasketItem(MenuItems item) {
    Basket.basketItems = Basket.basketItems.where((item) => !item.isEqual(item));
  }
}