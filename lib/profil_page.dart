import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foto_estetik/photo_detail_page.dart'; // Import halaman detail foto
import 'user.dart'; // Import definisi User
import 'foto.dart'; // Import definisi Photo

class ProfilePage extends StatefulWidget {
  final User user; // Properti user yang akan ditampilkan di profil

  ProfilePage({required this.user}); // Konstruktor untuk menerima user

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 1; // Indeks untuk tab "Profile"

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.pop(context); // Kembali ke halaman sebelumnya jika memilih tab "Foto"
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'foto/20220406_063317.jpg', // Gambar latar belakang
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(widget.user.profileImageUrl), // Gambar profil pengguna
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          widget.user.name, // Nama pengguna
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          widget.user.email, // Email pengguna
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Nomor Telepon'),
                        subtitle: Text(widget.user.phone), // Nomor telepon pengguna
                      ),
                      ListTile(
                        leading: Icon(Icons.location_city),
                        title: Text('Alamat'),
                        subtitle: Text(widget.user.address), // Alamat pengguna
                      ),
                      ListTile(
                        leading: Icon(Icons.work),
                        title: Text('Pekerjaan'),
                        subtitle: Text(widget.user.job), // Pekerjaan pengguna
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Foto Favorit', // Judul untuk daftar foto favorit
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 8),
                      if (widget.user.favoritePhotos.isEmpty)
                        Center(child: Text('Belum ada foto favorit')) // Tampilan jika tidak ada foto favorit
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: widget.user.favoritePhotos.length,
                          itemBuilder: (context, index) {
                            Photo photo = widget.user.favoritePhotos[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PhotoDetailPage(photo: photo), // Buka halaman detail foto saat foto favorit diklik
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: GridTile(
                                    child: CachedNetworkImage(
                                      imageUrl: photo.downloadUrl, // Tampilkan gambar dari URL download
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Tampilan placeholder ketika gambar sedang dimuat
                                      errorWidget: (context, url, error) => Icon(Icons.error), // Tampilan jika terjadi error saat memuat gambar
                                      fit: BoxFit.cover,
                                    ),
                                    footer: GridTileBar(
                                      backgroundColor: Colors.black54,
                                      title: Text(
                                        photo.author, // Tampilkan nama pengarang foto
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Foto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Warna untuk item yang dipilih
        unselectedItemColor: Colors.grey, // Warna untuk item yang tidak dipilih
        onTap: _onItemTapped, // Aksi yang dilakukan saat salah satu item navigasi ditekan
      ),
    );
  }
}