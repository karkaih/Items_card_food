import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_card_app/bloc/cart_list_bloc.dart';
import 'package:food_card_app/bloc/list_style.dart';
import 'package:food_card_app/models/food_item.dart';

class Cart extends StatelessWidget {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    List<FoodItem> foodItes;
    return StreamBuilder(
        stream: bloc.ListStream,
        builder: (context, snapshot) {
          if (snapshot != null) {
            foodItes = snapshot.data;
            return Scaffold(
              body: SafeArea(
                child: Container(child: CartBody(foodItes)),
              ),
              bottomNavigationBar: BottomBar(foodItes),
            );
          } else {
            return Container();
          }
        });
  }
}

class BottomBar extends StatelessWidget {
  final List<FoodItem> foodItems;

  BottomBar(this.foodItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 35, bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          totalAmount(foodItems),
          Divider(
            height: 1,
            color: Colors.grey[700],
          ),
          person(),
          nextButtonBar(),
        ],
      ),
    );
  }

  Container nextButtonBar() {
    return Container(
      margin: EdgeInsets.only(right: 25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Color(0xfffeb324), borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "15-25 min",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          Text(
            "Next",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Container totalAmount(List<FoodItem> foodItems) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
          ),
          Text(
            "\$${returnTotalAmount(foodItems)}",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }

  String returnTotalAmount(List<FoodItem> foodItems) {
    double totalAmount = 0;
    for (int i = 0; i < foodItems.length; i++) {
      totalAmount = totalAmount + foodItems[i].price * foodItems[i].quantity;
    }
    return totalAmount.toStringAsFixed(2);
  }
}

Container person() {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.symmetric(vertical: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Persons",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        CustomPersonWidget()
      ],
    ),
  );
}

class CartBody extends StatelessWidget {
  final List<FoodItem> foodItems;

  CartBody(this.foodItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(35, 40, 25, 0),
      child: Column(
        children: [
          CustomAppBar(),
          title(),
          Expanded(
            child: foodItems.length > 0 ? foodItemsList() : noItemsContainer(),
            flex: 1,
          )
        ],
      ),
    );
  }

  Container noItemsContainer() {
    return Container(
      child: Center(
        child: Text(
          "No more items in the cart",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              fontSize: 20),
        ),
      ),
    );
  }

  ListView foodItemsList() {
    return ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (builder, index) {
          return CartListItem(foodItem: foodItems[index]);
        });
  }

  Widget title() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 35),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 35),
              ),
              Text(
                "Order",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 35),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CartListItem extends StatelessWidget {
  final FoodItem foodItem;

  CartListItem({@required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: foodItem,
      maxSimultaneousDrags: 1,
      child: DraggableChild(foodItem: foodItem),
      feedback: DraggableChildFeddBack(foodItem: foodItem),
      childWhenDragging: foodItem.quantity > 1
          ? DraggableChild(foodItem: foodItem)
          : Container(),
    );
  }
}

class DraggableChildFeddBack extends StatelessWidget {
  final FoodItem foodItem;

  const DraggableChildFeddBack({Key key, this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();
    return Opacity(
      opacity: 0.7,
      child: Material(
        child: StreamBuilder(
          stream: colorBloc.colorStream,
          builder: (context, snaphot) {
            return Container(
              margin: EdgeInsets.only(bottom: 25),
              child: ItemContent(foodItem: foodItem),
              decoration: BoxDecoration(
                  color: snaphot.data != null ? snaphot.data : Colors.white),
            );
          },
        ),
      ),
    );
  }
}

class DraggableChild extends StatelessWidget {
  final FoodItem foodItem;

  const DraggableChild({Key key, this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: ItemContent(foodItem: foodItem),
    );
  }
}

class CustomPersonWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomPersonWidget();
  }
}

class _CustomPersonWidget extends State<CustomPersonWidget> {
  int noOfPersons = 1;

  double buttonWidth = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 50),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300], width: 2),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(vertical: 5),
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ignore: deprecated_member_use
          SizedBox(
            width: buttonWidth,
            height: buttonWidth,
            // ignore: deprecated_member_use
            child: FlatButton(
              child: Text(
                "-",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              onPressed: () {
                setState(() {
                  noOfPersons--;
                });
              },
            ),
          ),
          Text(
            noOfPersons.toString(),
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          // ignore: deprecated_member_use
          SizedBox(
            width: buttonWidth,
            height: buttonWidth,
            // ignore: deprecated_member_use
            child: FlatButton(
              child: Text(
                "+",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              onPressed: () {
                setState(() {
                  noOfPersons++;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItemContent extends StatelessWidget {
  final FoodItem foodItem;

  const ItemContent({Key key, this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              foodItem.imgUrl,
              fit: BoxFit.fitHeight,
              height: 55,
              width: 80,
            ),
          ),
          RichText(
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                  children: [
                TextSpan(text: foodItem.quantity.toString()),
                TextSpan(text: "X"),
                TextSpan(text: foodItem.title),
              ])),
          Text(
            "\$${foodItem.quantity * foodItem.price}",
            style:
                TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              CupertinoIcons.back,
              size: 30,
            ),
          ),
        ),
        DragTagetWidget()
      ],
    );
  }
}

class DragTagetWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DragTagetWidget();
  }
}

class _DragTagetWidget extends State<DragTagetWidget> {
  final CartListBloc listBloc = BlocProvider.getBloc<CartListBloc>();
  final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();

  @override
  Widget build(BuildContext context) {
    return DragTarget<FoodItem>(onLeave: (_) {
      colorBloc.setColor(Colors.white);
    }, onWillAccept: (FoodItem foodItem) {
      colorBloc.setColor(Colors.red);

      return true;
    }, onAccept: (FoodItem foodItem) {
      listBloc.removeFromList(foodItem);
      colorBloc.setColor(Colors.white);
    }, builder: (contex, incoming, rejected) {
      return GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Icon(
            CupertinoIcons.delete,
            size: 35,
          ),
        ),
      );
    });
  }
}
