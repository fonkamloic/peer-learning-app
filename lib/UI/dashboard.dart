import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peer_learning/UI/chat_forrum.dart';
import 'signup.dart';
import 'signin.dart';
import 'gender_stats.dart';
import 'coding_stats.dart';
import 'find_mentor.dart';
import 'profile.dart';

FirebaseUser loggedUser;

class Dashboard extends StatefulWidget {
  final String username;
  Dashboard({this.username});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getRegisteredUser();
    super.initState();
  }

  void getRegisteredUser() async {
    try {
      final newUser = await _auth.currentUser();
      if (newUser != null) {
        loggedUser = newUser;
        print(loggedUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  var _selectedIndex = 0;
  final _pageController = PageController();

  var currentPage = Container(
    child: SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Text("Test"),
          ],
        ),
      ),
    ),
  );
//  final navBotton = Destination(title: "test", icon: Icons.home, color: Colors.lightBlueAccent)

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
//      bottomNavigationBar: allDestinations,
        body: new Center(
          child: _getWidget(),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;

            //  _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.person),
              title: Text('Chat Area'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.people),
              title: Text('Gender Stats'),
              activeColor: Colors.purpleAccent,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.code),
                title: Text('Coding Stats'),
                activeColor: Colors.pink),
            BottomNavyBarItem(
                icon: Icon(Icons.gps_fixed),
                title: Text('Profile'),
                activeColor: Colors.blue),
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Widget _getWidget() {
    switch (_selectedIndex) {
      case 0:
        return Container(
          child: ChatForrum(),
        );
        break;
      case 1:
        return Container(
          child: GenderStats(),
        );
        break;
      case 2:
        return Container(
          child: CodingStats(),
        );
        break;
      default:
        return Container(
          child: Profile(),
        );
        break;
    }
  }
}

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Recent', Icons.restore, Colors.teal),
  Destination('Favorites', Icons.favorite_border, Colors.cyan),
  Destination('School', Icons.school, Colors.orange),
  Destination('Location', Icons.gps_fixed, Colors.blue)
];
