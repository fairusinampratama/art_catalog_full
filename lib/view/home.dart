import 'package:art_catalog_full/models/catalog_data.dart';
import 'package:art_catalog_full/models/category_model.dart';
import 'package:art_catalog_full/view/profile.dart';
import 'package:art_catalog_full/view/signin.dart';
import 'package:art_catalog_full/viewmodels/fetch_data_catalog.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'category.dart';
import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];

  void _getInitialInfo() {
    categories = CategoryModel.getCategories();
  }

  @override
  void initState() {
    super.initState();
    _getInitialInfo();
  }

  Widget build(BuildContext context) {
    catalogViewModel repo = catalogViewModel();
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<ArtModel>>(
        future: repo.fetchArtModel(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ArtModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<ArtModel> data = snapshot.data ?? [];

            List<ArtModel> shuffledTodayPaintings = List.from(data)..shuffle();
            List<ArtModel> shuffledPopularPaintings = List.from(data)
              ..shuffle();

            return ListView(
              children: [
                _searchField(data),
                const SizedBox(height: 40),
                _categoriesSection(),
                const SizedBox(height: 40),
                _todayPainting(shuffledTodayPaintings),
                const SizedBox(height: 40),
                _popularPainting(shuffledPopularPaintings),
              ],
            );
          }
        },
      ),
    );
  }

  Column _popularPainting(List<dynamic> paintingData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Popular',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to the painting detail screen when a painting is tapped
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Detail(
                      selectedPaintingId: paintingData[index].id,
                    ),
                  ),
                );
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff1D1617).withOpacity(0.07),
                      offset: const Offset(0, 10),
                      blurRadius: 40,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          paintingData[index].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              paintingData[index].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              paintingData[index].artist_title,
                              style: const TextStyle(
                                fontWeight: FontWeight
                                    .w300, // Use a lighter weight (e.g., FontWeight.w300) for artist name
                                color: Colors.black,
                                fontSize: 14, // Decrease font size
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Column _todayPainting(List<dynamic> paintingData) {
    int colorIndex = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Today's Painting",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          color: Colors.white,
          height: 240,
          child: ListView.separated(
            itemBuilder: (context, index) {
              colorIndex++;
              return GestureDetector(
                onTap: () {
                  // Navigate to the painting detail screen when a painting is tapped
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Detail(
                        selectedPaintingId: paintingData[index].id,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 220, // Adjusted the width for better spacing
                  decoration: BoxDecoration(
                    color: colorIndex % 2 == 0
                        ? Color(0xFFF0A500)
                            .withOpacity(0.3) // Color for even indices
                        : Color(0xFFCF7500)
                            .withOpacity(0.3), // Color for odd indices
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 180,
                        width: 220, // Match the container width
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            paintingData[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.all(10), // Add padding for title
                        child: Text(
                          paintingData[index].title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        )
      ],
    );
  }

  Column _categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Category',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 120,
          color: Colors.white,
          child: ListView.separated(
            itemCount: categories.length, // Replace with your category data
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle category tap here
                  final selectedCategory = categories[index].name;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          Category(selectedCategory: selectedCategory),
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: categories[index].boxColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(categories[index].iconPath),
                        ),
                      ),
                      Text(
                        categories[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14,
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

  Container _searchField(List<ArtModel> data) {
    TextEditingController _searchController = TextEditingController();
    GlobalKey<AutoCompleteTextFieldState<ArtModel>> key = GlobalKey();

    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          )
        ],
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: AutoCompleteTextField<ArtModel>(
        key: key,
        controller: _searchController,
        suggestions: data,
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(suggestion.imageUrl),
              backgroundColor:
                  Colors.transparent, // Set background color to transparent
            ),
            title: Text(suggestion.title),
            subtitle: Text(suggestion.artist_title),
            onTap: () {
              // Navigate to detail screen with the selected art's id
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Detail(
                    selectedPaintingId: suggestion.id,
                  ),
                ),
              );
            },
          );
        },
        itemSorter: (a, b) => a.title.compareTo(b.title),
        itemFilter: (suggestion, input) =>
            suggestion.title.toLowerCase().contains(input.toLowerCase()) ||
            suggestion.artist_title.toLowerCase().contains(input.toLowerCase()),
        itemSubmitted: (suggestion) {
          // Handle when an item is submitted (e.g., navigate to detail screen)
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Detail(
                selectedPaintingId: suggestion.id,
              ),
            ),
          );
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Search Painting',
          hintStyle: const TextStyle(
            color: Color(0xffDDDADA),
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset('assets/icons/search.svg'),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              // Clear the text and reset the state of AutoCompleteTextField
              _searchController.clear();
              key.currentState?.clear();
            },
            child: SizedBox(
              width: 100,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const VerticalDivider(
                      color: Colors.black,
                      indent: 10,
                      endIndent: 10,
                      thickness: 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SvgPicture.asset('assets/icons/cross.svg'),
                    )
                  ],
                ),
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
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

  AppBar appBar() {
    return AppBar(
        title: const Text('Painting',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => _confirmLogout(),
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: SvgPicture.asset(
              'assets/icons/angle-left.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 37,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: SvgPicture.asset(
                'assets/icons/profile-circle.svg',
                height: 30,
                width: 30,
              ),
            ),
          ),
        ]);
  }
}
