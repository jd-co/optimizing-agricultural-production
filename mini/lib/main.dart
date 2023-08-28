import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crop Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CropPredictionScreen(),
    );
  }
}

class CropPredictionScreen extends StatefulWidget {
  @override
  _CropPredictionScreenState createState() => _CropPredictionScreenState();
}

class _CropPredictionScreenState extends State<CropPredictionScreen> {
  TextEditingController nitrogenController = TextEditingController();
  TextEditingController potassiumController = TextEditingController();
  TextEditingController phosphorusController = TextEditingController();
  TextEditingController humidityController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  TextEditingController rainfallController = TextEditingController();
  TextEditingController phController = TextEditingController();
  FocusNode nitrogenFocusNode = FocusNode();
  FocusNode potassiumFocusNode = FocusNode();
  FocusNode phosphorusFocusNode = FocusNode();
  FocusNode humidityFocusNode = FocusNode();
  FocusNode temperatureFocusNode = FocusNode();
  FocusNode rainfallFocusNode = FocusNode();
  FocusNode phFocusNode = FocusNode();

  String predictedCrop = '';

  Future<String> predictCrop({
    required double nitrogen,
    required double potassium,
    required double phosphorus,
    required double humidity,
    required double temperature,
    required double rainfall,
    required double ph,
  }) async {
    final url = Uri.http('10.0.2.2:5000', '/');
    final headers = {'Content-Type': 'application/json'};
    final data = {
      'nitrogen': nitrogen,
      'potassium': potassium,
      'phosphorus': phosphorus,
      'humidity': humidity,
      'temperature': temperature,
      'rainfall': rainfall,
      'ph': ph,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['predicted_crop'];
    } else {
      throw Exception('Failed to predict crop.');
    }
  }

  void clearForm() {
    setState(() {
      nitrogenController.clear();
      potassiumController.clear();
      phosphorusController.clear();
      humidityController.clear();
      temperatureController.clear();
      rainfallController.clear();
      phController.clear();
      predictedCrop = '';
    });
  }

  void submitForm() async {
    final double nitrogen = double.tryParse(nitrogenController.text) ?? 0;
    final double potassium = double.tryParse(potassiumController.text) ?? 0;
    final double phosphorus = double.tryParse(phosphorusController.text) ?? 0;
    final double humidity = double.tryParse(humidityController.text) ?? 0;
    final double temperature = double.tryParse(temperatureController.text) ?? 0;
    final double rainfall = double.tryParse(rainfallController.text) ?? 0;
    final double ph = double.tryParse(phController.text) ?? 0;

    if (nitrogen == 0 ||
        potassium == 0 ||
        phosphorus == 0 ||
        humidity == 0 ||
        temperature == 0 ||
        rainfall == 0 ||
        ph == 0) {
      // Display an error message or handle the empty fields case as desired
      return;
    }

    try {
      predictedCrop = await predictCrop(
        nitrogen: nitrogen,
        potassium: potassium,
        phosphorus: phosphorus,
        humidity: humidity,
        temperature: temperature,
        rainfall: rainfall,
        ph: ph,
      );
      setState(() {});
    } catch (e) {
      print(e.toString());
    }

    nitrogenFocusNode.unfocus();
    potassiumFocusNode.unfocus();
    phosphorusFocusNode.unfocus();
    humidityFocusNode.unfocus();
    temperatureFocusNode.unfocus();
    rainfallFocusNode.unfocus();
    phFocusNode.unfocus();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    nitrogenController.dispose();
    potassiumController.dispose();
    phosphorusController.dispose();
    humidityController.dispose();
    temperatureController.dispose();
    rainfallController.dispose();
    phController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Prediction'),
        actions: [
          IconButton(
            onPressed: clearForm,
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Enter the values:', style: TextStyle(fontSize: 18.0)),
            TextFormField(
              focusNode: nitrogenFocusNode,
              controller: nitrogenController,
              decoration: InputDecoration(labelText: 'Nitrogen'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              focusNode: phosphorusFocusNode,
              controller: phosphorusController,
              decoration: InputDecoration(labelText: 'Phosphorus'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              focusNode: potassiumFocusNode,
              controller: potassiumController,
              decoration: InputDecoration(labelText: 'Potassium'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              focusNode: temperatureFocusNode,
              controller: temperatureController,
              decoration: InputDecoration(labelText: 'Temperature'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              focusNode: humidityFocusNode,
              controller: humidityController,
              decoration: InputDecoration(labelText: 'Humidity'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              focusNode: phFocusNode,
              controller: phController,
              decoration: InputDecoration(labelText: 'Soil pH'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              focusNode: rainfallFocusNode,
              controller: rainfallController,
              decoration: InputDecoration(labelText: 'Rainfall'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                      //padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text('Submit'),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      //padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: clearForm,
                  child: Text('Clear'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Text(
                  'Predicted Crop: ',
                  style: TextStyle(fontSize: 24.0),
                ),
                Visibility(
                  visible: predictedCrop.isNotEmpty,
                  replacement: Container(),
                  child: Text(
                    predictedCrop.toUpperCase(),
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
