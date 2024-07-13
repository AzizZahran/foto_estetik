import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import package url_launcher untuk membuka URL
import 'package:cached_network_image/cached_network_image.dart'; // Import package cached_network_image untuk menampilkan gambar yang di-cache
import 'foto.dart'; // Import model Photo untuk mengakses data foto

class PhotoDetailPage extends StatelessWidget {
  final Photo photo;

  PhotoDetailPage({required this.photo});

  // Fungsi untuk membuka URL, menggunakan Google Chrome jika tersedia, jika tidak, menggunakan browser default
  void _launchURL(String url) async {
    // URL aplikasi Google Chrome
    String chromeUrl = "googlechrome://navigate?url=$url";

    if (await canLaunch(chromeUrl)) {
      await launch(chromeUrl);
    } else {
      // Jika tidak dapat membuka di aplikasi Google Chrome, buka URL di aplikasi browser default
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Tidak dapat menjalankan $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Foto'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                _launchURL(photo.url); // Memanggil fungsi _launchURL ketika gambar ditekan untuk membuka foto dalam browser
              },
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: photo.downloadUrl, // Menggunakan cached_network_image untuk menampilkan gambar dari URL download
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Menampilkan indikator loading ketika gambar sedang dimuat
                    errorWidget: (context, url, error) => Icon(Icons.error), // Menampilkan ikon error jika gagal memuat gambar
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Fotografer:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              photo.author, // Menampilkan nama fotografer dari objek Photo
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _launchURL(photo.url); // Mengubah tombol untuk membuka foto dalam aplikasi Google Chrome jika tersedia
              },
              child: Text('Buka Foto di Google Chrome'),
            ),
          ],
        ),
      ),
    );
  }
}