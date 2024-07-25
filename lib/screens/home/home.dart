import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/pref_manager.dart';
import 'package:Trako/screens/dasboard/dashboard.dart';
import 'package:Trako/screens/home/client/client.dart';
import 'package:Trako/screens/products/machine.dart';
import 'package:Trako/screens/reports/reports.dart';
import 'package:Trako/screens/supply_chian/supplychain.dart';
import 'package:Trako/screens/users/users.dart';

import '../authFlow/signin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: buildDrawer(context),
      body: WillPopScope(
        onWillPop: () async {
          if (_selectedIndex != 0){
            _onItemTapped(0); // Navigate to Dashboard if not already there
            return false; // Do not pop the current route
          }
          return true; // Allow normal back behavior if already on Dashboard
        },
        child: PageView(
          physics: NeverScrollableScrollPhysics(), // Disable scroll physics
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            const CategoriesDashboard(),
            const ClientModule(),
            SupplyChain(),
            MachineModule(),
            MyReportScreen(),
            const UsersModule(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context){
    return AppBar(
      centerTitle: true,
      title: Image.asset(
        "assets/images/ic_trako.png",
        width: 200,
        height: 60,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading app logo: $error');
          return Text('Error loading logo');
        },
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
              // Navigator.pushNamed(context, '/profile');
            },
          ),
        ),
        SizedBox(width: 7),
      ],
    );
  }




  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [colorFirstGrad, colorSecondGrad],
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder(
          future: Future.wait([
            PrefManager().getMachineModule(),
            PrefManager().getClientModule(),
            PrefManager().getUserModule(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String? machineModule = snapshot.data![0];
              String? clientModule = snapshot.data![1];
              String? userModule = snapshot.data![2];

              bool showMachinesItem = machineModule != "1";
              bool showClientItem = clientModule != "1";
              bool showUserItem = userModule != "1";


              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [Colors.white, Colors.white],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                        child: const Center(child: Text("Trako",style: TextStyle(fontSize: 35,fontFamily:'KalniaGlaze'),)),
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: Icons.dashboard,
                    text: 'Dashboard',
                    index: 0,
                  ),
                  if (showClientItem)
                    _buildDrawerItem(
                      icon: Icons.person,
                      text: 'Clients',
                      index: 1,
                    ),
                  _buildDrawerItem(
                    icon: Icons.account_tree_outlined,
                    text: 'Supply Chain',
                    index: 2,
                  ),
                  if (showMachinesItem)
                    _buildDrawerItem(
                      icon: Icons.add_business,
                      text: 'Machines',
                      index: 3,
                    ),
                  _buildDrawerItem(
                    icon: Icons.report,
                    text: 'Reports',
                    index: 4,
                  ),
                  if (showUserItem)
                    _buildDrawerItem(
                      icon: Icons.add,
                      text: 'Users',
                      index: 5,
                    ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.white),
                    title: const Text('Logout', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmLogoutDialog(
                            onConfirm: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                PrefManager().clear();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AuthProcess()),
                                      (Route<dynamic> route) => false,
                                );
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 30,),
                  const Center(
                    child: Text(
                      'Powered by Tracesci.in',
                      style: TextStyle(
                        fontSize: 12.0, // Adjust the font size as needed
                        color: Colors.white, // Adjust the color to match your app's theme
                        fontStyle: FontStyle.italic, // Optionally italicize the text
                      ),
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon, required String text, required int index}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: TextStyle(color: Colors.white)),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.blueAccent.withOpacity(0.3),
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context);
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index); // Directly jump to the page
    });
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class ConfirmLogoutDialog extends StatelessWidget {

  final VoidCallback onConfirm;

  const ConfirmLogoutDialog({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Confirm Logout',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: colorMixGrad, // Use colorMixGrad as the primary color
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 0.5,
          ),

          SizedBox(height: 14.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  onConfirm(); // Call the callback to submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorMixGrad,
                  // Use colorMixGrad as the primary color
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}