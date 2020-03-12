import 'package:auto_size_text/auto_size_text.dart';
import 'package:ephslunch/models/lunch_items.dart';
import 'package:flutter/material.dart';

class MenuItemScreen extends StatefulWidget {
  final MenuItems menuItem;

  MenuItemScreen({
    this.menuItem,
  });

  @override
  _MenuItemScreenState createState() => _MenuItemScreenState();
}

class _MenuItemScreenState extends State<MenuItemScreen> {

  Widget getImage(Food foodItem) {
    return foodItem.imageUrl == null
        ? Image(
      image: AssetImage('assets/images/image_not_available.jpeg'),
      width: 110.0,
      fit: BoxFit.cover,
    )
        : Image.network(
      foodItem.imageUrl,
      width: 110.0,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Hero(
                  tag: widget.menuItem.food.name,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)
                    ),
                    child: getImage(widget.menuItem.food),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 30.0,
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.menuItem.food.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20.0,
                bottom: 20.0,
                child: Icon(
                  Icons.fastfood,
                  color: Colors.white70,
                  size: 25.0,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
              height: 250.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Text(
                          widget.menuItem.food.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )
                      ),
                  ),
                  Center(
                    child: Text(
                        widget.menuItem.food.roundedNutritionInfo.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        )
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}