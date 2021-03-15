import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:food_card_app/bloc/provider.dart';
import 'package:food_card_app/models/food_item.dart';
import 'package:rxdart/rxdart.dart';


class CartListBloc extends BlocBase{

  CartListBloc();

  var _listControler = BehaviorSubject<List<FoodItem>>.seeded([]);

  CartProvider  provider = CartProvider();
  //output
  Stream<List<FoodItem>> get ListStream => _listControler.stream;

  //input
  Sink<List<FoodItem>> get ListSink => _listControler.sink;

  addToList(FoodItem foodItem) {
    ListSink.add(provider.addToList(foodItem));
  }

  removeFromList (FoodItem foodItem){
    ListSink.add(provider.removeFromList(foodItem));
  }

  @override
  void dispose() {// will be called automatically
    _listControler.close();
    super.dispose();
  }
}