import 'package:art_catalog_full/models/profile_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel {
  User? _user = null;
  late UserProfile _userProfile;
  bool _isLoading = false; // Add a loading state

  ProfileViewModel() {
    _userProfile = UserProfile(); // Initialize _userProfile in the constructor
  }

  bool get isLoading => _isLoading;

  Future<UserProfile?> getUserData() async {
    try {
      _user = FirebaseAuth.instance.currentUser;
      _isLoading =
          true; // Set loading state to true when starting to fetch data

      if (_user != null) {
        String userEmail = _user?.email ??
            ""; // Get the user email from current user or use an empty string if it's null

        // Fetch user data from firestore
        QuerySnapshot userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();

        if (userQuery.docs.isNotEmpty) {
          DocumentSnapshot userSnapshot = userQuery.docs.first;
          _userProfile =
              UserProfile.fromMap(userSnapshot.data() as Map<String, dynamic>);
          _isLoading =
              false; // Set loading state to false when data is successfully fetched
          return _userProfile; // Return the user data
        } else {
          _isLoading =
              false; // Set loading state to false when no data is found
          return null; // No user data found for the given email
        }
      } else {
        _isLoading =
            false; // Set loading state to false when there is no logged-in user
        return null; // No logged-in user
      }
    } catch (e) {
      _isLoading = false; // Set loading state to false on error
      print("Error fetching user data: $e");
      return null; // Return null on error
    }
  }

  fetchUserData() {}
}
