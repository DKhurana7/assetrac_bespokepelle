import 'dart:core';
import 'package:assetrac_bespokepelle/screens/client.dart';
import 'package:assetrac_bespokepelle/screens/list.dart';
import 'package:assetrac_bespokepelle/screens/sales.dart';
import 'package:assetrac_bespokepelle/screens/stock.dart';
import 'package:assetrac_bespokepelle/screens/vendor.dart';
import 'package:flutter/material.dart';
import '../services/bottom_nav_bar.dart';
import '../services/category_card.dart';
import 'excel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

var date = DateTime.now();

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      drawer: const Drawer(
        child: HomePageDrawer(),
      ),
      appBar: AppBar(
        title: const Text('Bespoke Pelle'),
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: const Color(0xFF0A233E),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserPage()));
            },
            child: CircleAvatar(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0XFF0A233E),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('images/BespokePelleLogo.png'),
                        fit: BoxFit.cover)),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      backgroundColor: Colors.blue[50],
      bottomNavigationBar: const BottomNavBar(),
      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * .45,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              image: const DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("images/bgImage.jpg"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     height: 50,
                  //     width: 50,
                  //     decoration: const BoxDecoration(
                  //         color: Color(0XFF0A233E),
                  //         shape: BoxShape.circle,
                  //         image: DecorationImage(
                  //             image: AssetImage('images/BespokePelleLogo.jpg'),
                  //             fit: BoxFit.cover)),
                  //     // child: Image.asset('images/BespokePelleLogo.jpg'),
                  //   ),
                  // ),
                  // StreamBuilder(
                  //     stream: Stream.periodic(const Duration(seconds: 1)),
                  //     builder: (context, snapshot) {
                  //       if(DateFormat('MM/dd/yyyy hh:mm:ss').format(date) == DateTimeRange ) {
                  //
                  //       }
                  //       return Text(
                  //           DateFormat('MM/dd/yyyy hh:mm:ss').format(date));
                  //     }),
                  Text(
                    "Good Morning \nArjun",
                    style: Theme
                        .of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0XFF0A233E),
                        fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 40,
                      children: <Widget>[
                        CategoryCard(
                            cardName: "Asset Master",
                            cardIcon: FontAwesomeIcons.list,
                            press: AssetList()),
                        // CategoryCard(
                        //     cardName: "Category Master",
                        //     cardIcon: Icons.category,
                        //     press: CategoryFilters()),
                        CategoryCard(
                            cardName: "Vendor Master",
                            cardIcon: FontAwesomeIcons.person,
                            press: VendorMaster()),
                        CategoryCard(
                            cardName: "Client Master",
                            cardIcon: FontAwesomeIcons.user,
                            press: ClientMaster()),
                        CategoryCard(
                            cardName: "Stock Master",
                            cardIcon: Icons.warehouse,
                            press: StockMaster()),
                        CategoryCard(
                            cardName: "Stock Status",
                            cardIcon: Icons.preview,
                            press: StockStatus()),
                        const CategoryCard(
                            cardName: "Sales",
                            cardIcon: FontAwesomeIcons.indianRupeeSign,
                            press: Sales()),
                        // const CategoryCard(
                        //     cardName: "Excel Data",
                        //     cardIcon: Icons.file_copy_outlined,
                        //     press: Excel()),
                      ],
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

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 20, child: Container(color: const Color(0XFF0A233E),),),
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0A233E)),
            child: Text(
              'Asset Tracking',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
            ),
          ),
          ListTile(
              title: const Text('Export to Excel'),
              leading: const Icon(
                Icons.dataset_outlined,
                color: Color(0xFF0A233E),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Excel()));
              }),
          const SizedBox(height: 20),
          const ListTile(
              title: Text('Monthly Usage'),
              leading: Icon(
                Icons.data_usage_rounded,
                color: Color(0xFF0A233E),
              )),
          const SizedBox(height: 20),
          const ListTile(
            title: Text('About'),
            leading: Icon(
              Icons.info_outline,
              color: Color(0xFF0A233E),
            ),
          )
        ],
      ),
    );
  }
}


class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0XFF0A233E),
          title: const Text('Bespoke Pelle'),
          centerTitle: true,
        ),
        body: ListView(
          children: const [
            SizedBox(height: 25),
            CircleAvatar(
              radius: 100,
              backgroundColor: Color(0xFF0A233E),
              backgroundImage: AssetImage('images/BespokePelleLogo.png'),
            ),
            ListTile(title: Text('Users')),
            SizedBox(height: 25),
            ListTile(title: Text('About Bespoke Pelle')),
            SizedBox(height: 25),
            ListTile(title: Text('Logout')),
          ],
        ));
  }
}
