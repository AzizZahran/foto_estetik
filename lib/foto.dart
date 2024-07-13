class Photo {
  final String id;           // ID unik dari foto
  final String author;       // Nama pengarang atau fotografer
  final String url;          // URL asli foto
  final String downloadUrl;  // URL untuk mengunduh foto

  Photo({
    required this.id,
    required this.author,
    required this.url,
    required this.downloadUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],                   // Mengambil nilai 'id' dari objek JSON
      author: json['author'],           // Mengambil nilai 'author' dari objek JSON
      url: json['url'],                 // Mengambil nilai 'url' dari objek JSON
      downloadUrl: json['download_url'], // Mengambil nilai 'download_url' dari objek JSON
    );
  }
}