import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';

enum Place { OLD_COMMONS, NEW_COMMONS }

class Location {
  String locationName;
  String locationImage;
  String apiEndpoint;
  Place place;
  List<Days> days;

  Location({
    this.locationName,
    this.apiEndpoint,
    this.place,
    this.locationImage,
  });

  Future<void> populate(int weeks) async {
    this.days = [];
    var now = new DateTime.now();

    // Cap the weeks
    weeks = max(4, weeks);

    // TODO: get for entire month
    for (var dayId = 0; dayId < weeks; dayId++) {
      var target = new DateTime(now.year, now.month, now.day + (dayId * 7));

      // https://edenpr.nutrislice.com/menu/api/weeks/school/eden-prairie-high-school/menu-type/campus-cuisine/2020/03/07/
      Response res = await get(this.apiEndpoint +
          target.year.toString() +
          '/' +
          target.month.toString() +
          '/' +
          target.day.toString());

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(res.body);

        LunchWeekApiResponse parsedRes = LunchWeekApiResponse.fromJson(body);
        parsedRes.days.forEach((day) => this.days.add(day));
      } else {
        throw 'Failed to get data from API!';
      }
    }

    filterEmptyFoods();
  }

  // Sometimes the API returns foods that are null.. wtf ahaha
  filterEmptyFoods() {
    this.days = this.days.where((day) => day.menuItems != null).toList();
    this.days = this.days.map((day) {
      day.menuItems =
          day.menuItems.where((menuItem) => menuItem.food != null).toList();
      return day;
    }).toList();
  }
}

class LunchWeekApiResponse {
  int menuTypeId;
  List<Days> days;
  DateTime lastUpdated;
  DateTime startDate;

  LunchWeekApiResponse({
    this.menuTypeId,
    this.days,
    this.lastUpdated,
    this.startDate,
  });

  LunchWeekApiResponse.fromJson(Map<String, dynamic> json) {
    menuTypeId = json['menu_type_id'];
    if (json['days'] != null) {
      days = new List<Days>();
      json['days'].forEach((v) {
        days.add(new Days.fromJson(v));
      });
    }
    lastUpdated = DateTime.parse(json['last_updated']);
    startDate = DateTime.parse(json['start_date']);
  }
}

class Days {
  DateTime date;
  List<MenuItems> menuItems;

  Days({this.date, this.menuItems});

  Days.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);

    if (json['menu_items'] != null) {
      menuItems = new List<MenuItems>();
      json['menu_items'].forEach((v) {
        menuItems.add(new MenuItems.fromJson(v));
      });
    }
  }
}

class MenuItems {
  String category;
  bool bold;
  String image;
  String text;
  Food food;

  MenuItems({
    this.category,
    this.bold,
    this.image,
    this.text,
    this.food,
  });

  MenuItems.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    bold = json['bold'];
    image = json['image'];
    text = json['text'];
    food = json['food'] != null ? new Food.fromJson(json['food']) : null;
  }
}

class Food {
  String name;
  String description;
  String imageUrl;

  Food({
    this.name,
    this.description,
    this.imageUrl,
  });

  Food.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

List<Location> unpopulatedLocations = [
  Location(
    locationName: 'Campus Cuisine',
    apiEndpoint:
        'https://edenpr.nutrislice.com/menu/api/weeks/school/eden-prairie-high-school/menu-type/campus-cuisine/',
    place: Place.OLD_COMMONS,
    locationImage: 'assets/images/ephs.jpg',
  ),
  Location(
    locationName: 'West Deli',
    apiEndpoint:
        'https://edenpr.nutrislice.com/menu/api/weeks/school/eden-prairie-high-school/menu-type/west-deli/',
    place: Place.NEW_COMMONS,
    locationImage: 'assets/images/ephs.jpg',
  ),
  Location(
    locationName: 'East Deli',
    apiEndpoint:
        'https://edenpr.nutrislice.com/menu/api/weeks/school/eden-prairie-high-school/menu-type/east-deli/',
    place: Place.OLD_COMMONS,
    locationImage: 'assets/images/ephs.jpg',
  ),
  Location(
    locationName: 'Eagle Grille',
    apiEndpoint:
        'https://edenpr.nutrislice.com/menu/api/weeks/school/eden-prairie-high-school/menu-type/a-la-carte/',
    place: Place.NEW_COMMONS,
    locationImage: 'assets/images/ephs.jpg',
  ),
  Location(
    locationName: 'American Grille',
    apiEndpoint:
        'https://edenpr.nutrislice.com/menu/api/weeks/school/eden-prairie-high-school/menu-type/a-la-carte/',
    place: Place.OLD_COMMONS,
    locationImage: 'assets/images/ephs.jpg',
  ),
  Location(
    locationName: 'Coffee Shop',
    apiEndpoint:
        'https://edenpr.nutrislice.com/menu/api/weeks/school/eden-prairie-high-school/menu-type/coffee-shop/',
    place: Place.NEW_COMMONS,
    locationImage: 'assets/images/ephs.jpg',
  ),
  Location(
    locationName: 'Breakfast',
    apiEndpoint:
    'https://edenpr.nutrislice.com/menu/api/weeks/school/eden-prairie-high-school/menu-type/breakfast/',
    place: Place.NEW_COMMONS,
    locationImage: 'assets/images/ephs.jpg',
  ),
];
