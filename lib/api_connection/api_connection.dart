import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> post(String baseUrl, String apiUrl, Map<String, String> body) async {
    var response = await http.post(Uri.https(baseUrl, apiUrl), body: body);
    return response.body;
  }
}
