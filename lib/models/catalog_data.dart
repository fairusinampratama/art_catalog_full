class ArtModel {
  final int id;
  final String title;
  final String date_display;
  final String place_of_origin;
  final String description;
  final String artist_title;
  final String image_id;
  late String imageUrl;

  ArtModel({
    required this.id,
    required this.title,
    required this.date_display,
    required this.place_of_origin,
    required this.description,
    required this.artist_title,
    required this.image_id,
  });

  factory ArtModel.fromJson(Map<String, dynamic> json) {
    final artModel = ArtModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled',
      date_display: json['date_display'] ?? 'Unknown Date',
      place_of_origin: json['place_of_origin'] ?? 'Unknown Origin',
      description: json['description'] ?? 'No Description',
      artist_title: json['artist_title'] ?? 'Unknown Artist',
      image_id: json['image_id'] ?? '',
    );

    // Set default imageUrl if image_id is not provided
    artModel.imageUrl = artModel.image_id.isNotEmpty
        ? 'https://www.artic.edu/iiif/2/${artModel.image_id}/full/843,/0/default.jpg'
        : 'https://placehold.co/800/png?text=No+Image&font=Montserrat'; // Provide a default placeholder URL

    return artModel;
  }
}
