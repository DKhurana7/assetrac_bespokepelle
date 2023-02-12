import 'dart:core';
import 'package:assetrac_bespokepelle/screens/client.dart';
import 'package:assetrac_bespokepelle/screens/list.dart';
import 'package:assetrac_bespokepelle/screens/sales.dart';
import 'package:assetrac_bespokepelle/screens/stock.dart';
import 'package:assetrac_bespokepelle/screens/vendor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/bottom_nav_bar.dart';
import '../services/category_card.dart';
import 'excel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

var date = DateTime.now();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.currentUser!.reload();
    return Scaffold(
      drawer: const Drawer(
        child: HomePageDrawer(),
      ),
      appBar: AppBar(
        title: const Text('Bespoke Pelle'),
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: const Color(0XFF0A233E),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome \n${user!.displayName}",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
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
                            cardName: "Stock Status",
                            cardIcon: Icons.preview,
                            press: StockStatus()),
                        CategoryCard(
                            cardName: "Transaction History",
                            cardIcon: Icons.history,
                            press: StockMaster()),
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
      backgroundColor: Colors.blue[50],
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20,
            child: Container(
              color: const Color(0XFF0A233E),
            ),
          ),
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0XFF0A233E)),
            child: Text(
              'Asset Tracking',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
          ),
          ListTile(
              title: const Text('Export to Excel'),
              leading: const Icon(
                Icons.dataset_outlined,
                color: Color(0XFF0A233E),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Excel()));
              }),
          const SizedBox(height: 20),
          const ListTile(
              title: Text('Monthly Usage'),
              leading: Icon(
                Icons.data_usage_rounded,
                color: Color(0XFF0A233E),
              )),
          const SizedBox(height: 20),
          const ListTile(
            title: Text('About'),
            leading: Icon(
              Icons.info_outline,
              color: Color(0XFF0A233E),
            ),
          )
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: const Color(0XFF0A233E),
          title: const Text('Bespoke Pelle'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            const SizedBox(height: 25),
            const CircleAvatar(
              radius: 100,
              backgroundColor: Color(0XFF0A233E),
              backgroundImage: AssetImage('images/BespokePelleLogo.png'),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Profile',
                  style: TextStyle(color: Color(0XFF0A233E))),
              leading:
                  const Icon(Icons.person_outline, color: Color(0XFF0A233E)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfoPage()));
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('About Bespoke Pelle',
                  style: TextStyle(color: Color(0XFF0A233E))),
              leading: const Icon(Icons.info_outline, color: Color(0XFF0A233E)),
              onTap: () {},
            ),
            const SizedBox(height: 20),
            ListTile(
                title: const Text('LogOut',
                    style: TextStyle(color: Color(0XFF0A233E))),
                leading: const Icon(Icons.power_settings_new_sharp,
                    color: Color(0XFF0A233E)),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Center(child: logOut(context));
                      });
                }),
          ],
        ));
  }

  logOut(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.all(10.0),
      backgroundColor: const Color(0XFF0A233E),
      title: const Text(
        "Log Out",
        style: TextStyle(color: Colors.white),
      ),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "Are you sure you want to log out?",
              style: TextStyle(color: Colors.white),
            )
          ]),
      actions: [
        OutlinedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text("Log Out", style: TextStyle(color: Colors.white)),
        ),
        OutlinedButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class UserInfoPage extends StatelessWidget {
  UserInfoPage({Key? key}) : super(key: key);

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          backgroundColor: const Color(0XFF0A233E)),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Some Error Occurred"));
            }
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;

              List<Map> items = documents
                  .map((e) => {
                        'id': e.id,
                        'fName': e['fName'],
                        'lName': e['lName'],
                        'contact': e['contact'],
                        'email': e['email'],
                      })
                  .toList();
              return ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, int index) {
                  Map thisItem = items[index];
                  User? user = FirebaseAuth.instance.currentUser;
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 20),
                      ListTile(
                        title: Text(user!.uid.toString().substring(0, 10)),
                        trailing: IconButton(
                          onPressed: () {},
                          icon:
                              const Icon(Icons.edit, color: Color(0XFF0A233E)),
                        ),
                      ),
                      ListTile(
                        title: Text(user.displayName.toString()),
                        trailing: IconButton(
                            onPressed: () {
                            },
                            icon: const Icon(Icons.edit,
                                color: Color(0XFF0A233E))),
                      ),
                      ListTile(
                        title: Text(user.email.toString()),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0XFF0A233E),
                            )),
                      ),
                      TextFormField(
                        controller: nameController,
                      ),
                    ],
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E)));
          }),
    );
  }
}
