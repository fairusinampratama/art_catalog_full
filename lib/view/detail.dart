import 'package:art_catalog_full/models/catalog_data.dart';
import 'package:art_catalog_full/viewmodels/fetch_data_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Detail extends StatefulWidget {
  final int selectedPaintingId;

  const Detail({Key? key, required this.selectedPaintingId}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    catalogViewModel repo = catalogViewModel();

    return Scaffold(
      appBar: appBar(),
      body: FutureBuilder<List<ArtModel>>(
        builder: (context, AsyncSnapshot<List<ArtModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<ArtModel> data = snapshot.data ?? [];
            final selectedPainting = data.firstWhere(
              (data) => data.id == widget.selectedPaintingId,
              orElse: () => ArtModel(
                id: 0,
                title: 'Not Found',
                date_display: '',
                place_of_origin: '',
                description: '',
                artist_title: '',
                image_id: '',
              ),
            );

            // ignore: unnecessary_null_comparison
            if (selectedPainting != null) {
              return Stack(
                children: [
                  _imageView(selectedPainting),
                  _detailScroll(selectedPainting),
                ],
              );
            } else {
              return Center(child: Text('Painting not found'));
            }
          }
        },
        future: repo
            .fetchArtModel(), // Update this with the actual future to fetch data
      ),
    );
  }

  String combineAndCleanParagraphs(String textWithParagraphs) {
    // Remove HTML tags
    String textWithoutHtml = removeHtmlTags(textWithParagraphs);

    // Remove extra whitespace and newlines
    return textWithoutHtml.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String removeHtmlTags(String input) {
    // Define a regular expression to match HTML tags
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    // Replace all occurrences of HTML tags with an empty string
    return input.replaceAll(exp, '');
  }

  SizedBox _imageView(ArtModel selectedPainting) {
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1, // Replace with the desired aspect ratio
        child: Image.network(
          selectedPainting.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _detailScroll(ArtModel selectedPainting) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 1.0,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 5,
                    width: 35,
                    color: Colors.black12,
                  ),
                ),
                const SizedBox(height: 25),
                ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${selectedPainting.title} (${selectedPainting.date_display})',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        selectedPainting.artist_title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        selectedPainting.place_of_origin,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(combineAndCleanParagraphs(selectedPainting.description),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.justify),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("Detail",
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
    );
  }
}
