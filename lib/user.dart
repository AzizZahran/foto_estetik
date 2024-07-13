import 'foto.dart'; // Import file yang berisi definisi kelas Photo

class User {
  final String name;           // Nama lengkap pengguna
  final String email;          // Alamat email pengguna
  final String phone;          // Nomor telepon pengguna
  final String address;        // Alamat lengkap pengguna
  final String job;            // Pekerjaan atau profesi pengguna
  final String profileImageUrl;// URL gambar profil pengguna
  List<Photo> favoritePhotos;  // Daftar foto favorit pengguna

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.job,
    required this.profileImageUrl,
    List<Photo>? favoritePhotos, // Parameter opsional untuk daftar favorit
  }) : this.favoritePhotos = favoritePhotos ?? []; // Inisialisasi daftar favorit, jika null, gunakan list kosong
}