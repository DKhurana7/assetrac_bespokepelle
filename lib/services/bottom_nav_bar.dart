import 'package:flutter/material.dart';

import '../screens/category.dart';
import '../screens/homepage.dart';
import '../screens/sales.dart';


class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      height: 80,
      color: const Color(0XFF0A233E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BottomNavItem(itemName: 'Categories', iconName: Icons.category, press: CategoryFilters()),
          const BottomNavItem(itemName: 'Sale', iconName: Icons.attach_money, press: MakeSale()),
          const BottomNavItem(itemName: 'Settings', iconName: Icons.settings, press: UserPage(),)
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String itemName;
  final IconData iconName;
  final Widget press;

  const BottomNavItem({
    Key? key, required this.itemName, required this.iconName, required this.press
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => press));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            iconName,
            color: Colors.white,
          ),
          Text(
            itemName,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}