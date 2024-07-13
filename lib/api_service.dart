import 'dart:convert';
import 'package:http/http.dart' as http;
import 'foto.dart'; // Import model Photo untuk melakukan mapping data JSON

class ApiService {
  Future<List<Photo>> fetchPhotos() async {
    final response = await http.get(Uri.parse('https://picsum.photos/v2/list?page=2&limit=100'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body); // Mendekode respons JSON menjadi list dinamis
      return data.map((json) => Photo.fromJson(json)).toList(); // Mengubah setiap objek JSON menjadi objek Photo menggunakan metode fromJson dari model Photo
    } else {
      throw Exception('Gagal memuat foto!'); // Melempar exception jika gagal mengambil data (status code bukan 200)
    }
  }
}