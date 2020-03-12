import 'package:auto_size_text/auto_size_text.dart';
import 'package:ephslunch/models/lunch_items.dart';
import 'package:flutter/material.dart';

class DayScreen extends StatefulWidget {
  final Days day;
  final Location location;

  DayScreen({
    this.location,
    this.day,
  });

  @override
  _DayScreenState createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {

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
                  tag: widget.location.locationName,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)
                    ),
                    child: Image(
                      image: AssetImage(widget.location.locationImage),
                      fit: BoxFit.cover,
                    ),
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
                      widget.location.locationName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
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
                  Icons.location_on,
                  color: Colors.white70,
                  size: 25.0,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.day.menuItems.length,
                itemBuilder: (BuildContext context, int index) {
                  MenuItems menuItem =
                  widget.day.menuItems[index];

                  return Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                        height: 250.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          menuItem.food.name,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        AutoSizeText(
                                          menuItem.food.description,
                                          maxLines: 8,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 8.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10.0,
                        top: 5.0,
                        bottom: 5.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: getImage(menuItem.food),
                        ),
                      ),
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}