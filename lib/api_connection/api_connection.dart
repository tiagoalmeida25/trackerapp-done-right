import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trackerapp/constants.dart';

class ApiService {
  static Future<String> post(String url, Map<String, String> body) async {
    var response = await http.post(Uri.parse(url), body: body);
    return response.body;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String responseText = 'No response yet';

  void fetchData() async {
    var response = await ApiService.post(APIConstants.loginURL, {
      "user_name": "Tiago",
      "password": "123",
    });

    setState(() {
      responseText = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello World Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              responseText,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Fetch Data from API'),
            ),
            SizedBox(height: 20),
            Text('API Response: $responseText'),
          ],
        ),
      ),
    );
  }
}
