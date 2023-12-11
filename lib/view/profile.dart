import 'package:art_catalog_full/models/profile_data.dart';
import 'package:art_catalog_full/view/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:art_catalog_full/viewmodels/fetch_data_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _profileViewModel = ProfileViewModel();
  UserProfile? _userProfile;
  late Future<void> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _userProfile = await _profileViewModel.getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Display the profile information
              return _buildProfile();
            }
          },
        ),
      ),
      bottomNavigationBar: logoutButton(),
    );
  }

  Padding logoutButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100, right: 100, left: 100),
      child: ElevatedButton(
        onPressed: () {
          _confirmLogout();
        },
        child: Text('Logout'),
      ),
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const CircleAvatar(
          radius: 70,
          backgroundImage: AssetImage('assets/icons/man.png'),
        ),
        const SizedBox(height: 20),
        buildProfileItem('First Name', _userProfile?.firstName ?? 'N/A',
            CupertinoIcons.person_circle),
        const SizedBox(height: 10),
        buildProfileItem('Last Name', _userProfile?.lastName ?? 'N/A',
            CupertinoIcons.person_crop_circle),
        const SizedBox(height: 10),
        buildProfileItem('Age', _userProfile?.age.toString() ?? 'N/A',
            CupertinoIcons.calendar),
        const SizedBox(height: 10),
        buildProfileItem('Email', _userProfile?.email.toString() ?? 'N/A',
            CupertinoIcons.mail),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildProfileItem(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14),
        ),
        leading: Icon(
          iconData,
          size: 30,
          color: Colors.blue, // Adjust the color based on your design
        ),
        tileColor: Colors.white,
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        "Profile Page",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/angle-left.svg',
            height: 20,
            width: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
