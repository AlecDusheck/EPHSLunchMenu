import 'package:auto_size_text/auto_size_text.dart';
import 'package:ephslunch/models/lunch_items.dart';
import 'package:ephslunch/screens/day_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  final DateTime dayToView;

  HomeScreen({
    this.dayToView,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedType = 0;
  Future<List<Location>> currentLocations;

  List<String> _menuItems = [
    'West',
    'East',
  ];

  String limitTitle(String desc, int limit) {
    return desc.length > limit ? desc.substring(0, limit) + '...' : desc;
  }

  Widget getImage(Food foodItem) {
    return foodItem.imageUrl == null
        ? Image(
            image: AssetImage('assets/images/image_not_available.jpeg'),
            height: 200.0,
            width: 200.0,
            fit: BoxFit.cover,
          )
        : Image.network(
            foodItem.imageUrl,
            height: 200.0,
            width: 200.0,
            fit: BoxFit.cover,
          );
  }

  Days getCurrentDay(Location location) {
    return location.days.firstWhere((day) =>
    day.date.day == widget.dayToView.day
        && day.date.year == widget.dayToView.year
        && day.date.month == widget.dayToView.month);
  }

  Future<List<Location>> getLocations(Place place) async {
    var locations = unpopulatedLocations
        .where((location) => location.place == place)
        .toList();

    await Future.wait(
        locations.map((location) => location.populate(1)).toList());

    return locations;
  }

  Widget _buildLocations(Location location) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                location.locationName,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => DayScreen(
                      location: location,
                      day: getCurrentDay(location),
                    )
                )),
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 300.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: getCurrentDay(location).menuItems.length,
            itemBuilder: (BuildContext context, int index) {
              MenuItems menuItem = getCurrentDay(location).menuItems[index];
              return GestureDetector(
                onTap: () => {},
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 210.0,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned(
                        bottom: 15.0,
                        child: Container(
                          height: 120.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AutoSizeText(
                                  limitTitle(menuItem.food.name, 14),
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                AutoSizeText(
                                  limitTitle(menuItem.food.description, 20),
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Hero(
                              tag: location.locationName + '-' + menuItem.food.name,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: getImage(menuItem.food),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenu(int index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            this._selectedType = index;

            if (index == 0) {
              this.currentLocations = this.getLocations(Place.NEW_COMMONS);
            } else {
              this.currentLocations = this.getLocations(Place.OLD_COMMONS);
            }
          });
        },
        child: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
              color: this._selectedType == index
                  ? Theme.of(context).accentColor
                  : Color(0xFFE7EBEE),
              borderRadius: BorderRadius.circular(30.0)),
          child: Center(
            child: Text(
              _menuItems[index],
              style: TextStyle(
                color: this._selectedType == index
                    ? Colors.black
                    : Color(0xFFB4C1C4),
                fontSize: 15.0,
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();

    this.currentLocations = this.getLocations(Place.NEW_COMMONS);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.black, // Color for Android
      systemNavigationBarIconBrightness: Brightness.light, // iOS
    ));

    return Scaffold(
        body: SafeArea(
            child: ListView(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 120.0),
          child: Text(
            "Today's EPHS Menu",
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _menuItems
              .asMap()
              .entries
              .map((MapEntry f) => _buildMenu(f.key))
              .toList(),
        ),
        Column(
          children: <Widget>[
            FutureBuilder<List<Location>>(
              future: currentLocations,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  // Needed to hide the data while loading
                  return Column(
                      children: snapshot.data
                          .map((location) => _buildLocations(location))
                          .toList());
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            )
          ],
        ),
      ],
    )));
  }
}
