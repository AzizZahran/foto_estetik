import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Menggunakan CachedNetworkImage untuk memuat gambar dari URL dengan caching
import 'photo_detail_page.dart'; // Mengimpor halaman detail foto
import 'foto.dart'; // Mengimpor model Foto
import 'api_service.dart'; // Mengimpor ApiService untuk mengambil data foto dari API
import 'profil_page.dart'; // Mengimpor halaman profil
import 'user.dart'; // Mengimpor model User

void main() {
  runApp(AplikasiFotoEstetik());
}

class AplikasiFotoEstetik extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Contoh user yang akan digunakan di seluruh aplikasi
    User exampleUser = User(
      name: 'Muhammad Aziz Zahran Ramadhan',
      email: 'aziz@gmail.com',
      phone: '081234567899',
      address: 'Bantul, Yogyakarta',
      job: 'Mahasiswa',
      profileImageUrl: 'foto/20220713_091929.jpg', // Gambar profil dari aset
    );

    return MaterialApp(
      title: 'Estetika Foto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => PhotosPage(user: exampleUser), // Routing halaman utama dengan menyertakan user
        '/profile': (context) => ProfilePage(user: exampleUser), // Routing halaman profil dengan menyertakan user
      },
    );
  }
}

class PhotosPage extends StatefulWidget {
  final User user;

  PhotosPage({required this.user}); // Menerima user sebagai parameter

  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  late Future<List<Photo>> futurePhotos; // Future untuk menyimpan data foto dari ApiService
  List<Photo> photos = []; // List untuk menyimpan semua foto
  List<Photo> filteredPhotos = []; // List untuk menyimpan foto yang sudah difilter
  TextEditingController searchController = TextEditingController(); // Controller untuk field pencarian
  int _selectedIndex = 0; // Indeks untuk BottomNavigationBar

  @override
  void initState() {
    super.initState();
    futurePhotos = ApiService().fetchPhotos(); // Memuat daftar foto dari ApiService
    futurePhotos.then((photoList) {
      setState(() {
        photos = photoList; // Mengisi daftar foto
        filteredPhotos = photoList; // Mengisi daftar foto yang sudah difilter
      });
    });

    searchController.addListener(() {
      filterPhotos(); // Menjalankan fungsi filter saat teks berubah pada pencarian
    });
  }

  void filterPhotos() {
    String query = searchController.text.toLowerCase(); // Mendapatkan teks pencarian dalam lowercase
    setState(() {
      filteredPhotos = photos.where((photo) {
        return photo.author.toLowerCase().contains(query); // Mengecek apakah author foto mengandung teks pencarian
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Memperbarui indeks yang dipilih pada BottomNavigationBar
    });
    if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(user: widget.user), // Navigasi ke halaman profil dengan membawa user
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estetika Foto'), // Judul AppBar
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController, // Menghubungkan controller ke TextField
              decoration: InputDecoration(
                labelText: 'Cari berdasarkan fotografer', // Label untuk TextField
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Mengatur borderRadius untuk TextField
                ),
                prefixIcon: Icon(Icons.search), // Icon di bagian depan TextField
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Photo>>(
                future: futurePhotos, // FutureBuilder untuk menampilkan daftar foto
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); // Menampilkan loading indicator saat data sedang dimuat
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}')); // Menampilkan pesan error jika terjadi kesalahan
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Foto tidak ditemukan!')); // Menampilkan pesan jika tidak ada foto yang ditemukan
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Jumlah kolom dalam GridView
                        crossAxisSpacing: 10, // Spasi antar kolom
                        mainAxisSpacing: 10, // Spasi antar baris
                        childAspectRatio: 0.75, // Rasio aspek setiap item dalam GridView
                      ),
                      itemCount: filteredPhotos.length, // Jumlah item dalam GridView sesuai dengan foto yang sudah difilter
                      itemBuilder: (context, index) {
                        Photo photo = filteredPhotos[index]; // Mengambil foto dari daftar yang sudah difilter
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoDetailPage(photo: photo), // Navigasi ke halaman detail foto saat foto diklik
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0), // Mengatur borderRadius untuk Card
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0), // Mengatur borderRadius untuk ClipRRect
                              child: GridTile(
                                child: CachedNetworkImage(
                                  imageUrl: photo.downloadUrl, // URL gambar untuk CachedNetworkImage
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Placeholder saat gambar sedang dimuat
                                  errorWidget: (context, url, error) => Icon(Icons.error), // Widget untuk menampilkan ikon error jika gambar gagal dimuat
                                  fit: BoxFit.cover, // Mengatur bagaimana gambar menyesuaikan kotak yang tersedia
                                ),
                                footer: GridTileBar(
                                  backgroundColor: Colors.black54, // Warna latar belakang footer
                                  title: Text(
                                    photo.author,
                                    style: TextStyle(fontSize: 14), // Gaya teks untuk nama pengarang foto
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.photo), // Icon untuk item foto
            label: 'Foto', // Label untuk item foto
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icon untuk item profil
            label: 'Profil', // Label untuk item profil
          ),
        ],
        currentIndex: _selectedIndex, // Indeks item yang sedang dipilih di BottomNavigationBar
        selectedItemColor: Colors.blue, // Warna ikon untuk item yang dipilih
        unselectedItemColor: Colors.grey, // Warna ikon untuk item yang tidak dipilih
        onTap: _onItemTapped, // Fungsi yang dipanggil saat item di BottomNavigationBar diklik
      ),
    );
  }
}