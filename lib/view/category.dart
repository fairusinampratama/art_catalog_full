import 'package:art_catalog_full/models/catalog_data.dart';
import 'package:art_catalog_full/models/category_model.dart';
import 'package:art_catalog_full/viewmodels/fetch_data_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'detail.dart';

class Category extends StatefulWidget {
  final String selectedCategory;

  Category({Key? key, required this.selectedCategory}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<CategoryModel> categories = [];

  void _getInitialInfo() {
    categories = CategoryModel.getCategories();
  }

  @override
  void initState() {
    super.initState();
    _getInitialInfo();
  }

  @override
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
            return ListView(
              children: [
                const SizedBox(height: 40),
                _listPainting(data),
              ],
            );
          }
        },
      ),
    );
  }

  List<dynamic> filterPaintingsByOrigin(
      List<dynamic> paintingData, String origin) {
    return paintingData.where((art) => art.place_of_origin == origin).toList();
  }

  Column _listPainting(List<dynamic> paintingData) {
    List<dynamic> selectedPaintings =
        filterPaintingsByOrigin(paintingData, widget.selectedCategory);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
        ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          itemCount: selectedPaintings
              .length, // Display only paintings in the selected category
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  // Navigate to the painting detail screen when a painting is tapped
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Detail(
                        selectedPaintingId: selectedPaintings[index].id,
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
                        color: Color(0xff1D1617).withOpacity(0.07),
                        offset: Offset(0, 10),
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
                          borderRadius: BorderRadius.circular(
                              12), // Adjust the radius as needed
                          child: Image.network(
                            selectedPaintings[index].imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                  'https://placehold.co/800?text=Error+Image&font=Montserrat');
                            },
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
                                selectedPaintings[index].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                selectedPaintings[index].artist_title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontSize: 14,
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
                ));
          },
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text("List of " + widget.selectedCategory,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
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
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
