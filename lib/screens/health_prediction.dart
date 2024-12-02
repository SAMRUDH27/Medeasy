import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'prediction_result.dart';

class HeartDiseasePrediction extends StatefulWidget {
  const HeartDiseasePrediction({super.key});

  @override
  _HeartDiseasePredictionState createState() => _HeartDiseasePredictionState();
}

class _HeartDiseasePredictionState extends State<HeartDiseasePrediction> {
  TextEditingController ageController = TextEditingController();
  TextEditingController trestbpsController = TextEditingController();
  TextEditingController cholController = TextEditingController();
  TextEditingController thalachController = TextEditingController();
  TextEditingController oldpeakController = TextEditingController();
  TextEditingController caController = TextEditingController();
  String sexValue = ''; 
  String cpValue = ''; 
  String fbsValue = ''; 
  String restecgValue = ''; 
  String exangValue = ''; 
  String slopeValue = ''; 
  String thalValue = ''; 

  String predictionResult = '';

  Future<void> predict() async {
    const apiUrl = 'https://prediction-7llb.onrender.com/api/predict';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'age': ageController.text,
        'sex': sexValue == 'Male' ? '1' : '0',
        'cp': ChestPain(cpValue),
        'trestbps': trestbpsController.text,
        'chol': cholController.text,
        'fbs': fbsValue == 'Greater than 120 mg/dl' ? '1' : '0',
        'restecg': Restecg(restecgValue),
        'thalach': thalachController.text,
        'exang': exangValue == 'Yes' ? '1' : '0',
        'oldpeak': oldpeakController.text,
        'slope': Slope(slopeValue),
        'ca': caController.text,
        'thal': Thalass(thalValue),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        predictionResult = '${data['prediction']}';
      });
    } else {
      setState(() {
        predictionResult = 'Failed to get prediction';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 4,
        shape: const OutlineInputBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
        ),
        title: Text('Heart Disease Prediction', style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              _buildTextField(ageController, 'Age'),
              const SizedBox(height: 10),
              _buildDropdown('Sex', ['Select Option', 'Male', 'Female'], sexValue, (value) {
                setState(() {
                  sexValue = value!;
                });
              }),
              const SizedBox(height: 10),
              _buildDropdown('Chest Pain Type', ['Select Option', 'Typical Angina', 'Atypical Angina', 'Non-anginal Pain', 'Asymptomatic'], cpValue, (value) {
                setState(() {
                  cpValue = value!;
                });
              }),
              const SizedBox(height: 10),
              _buildTextField(trestbpsController, 'Resting Blood Pressure'),
              const SizedBox(height: 10),
              _buildTextField(cholController, 'Serum Cholesterol'),
              const SizedBox(height: 10),
              _buildDropdown('Fasting Blood Sugar', ['Select Option', 'Greater than 120 mg/dl', 'Less than 120 mg/dl'], fbsValue, (value) {
                setState(() {
                  fbsValue = value!;
                });
              }),
              const SizedBox(height: 10),
              _buildDropdown('Resting ECG', ['Select Option', 'Normal', 'ST-T wave abnormality'], restecgValue, (value) {
                setState(() {
                  restecgValue = value!;
                });
              }),
              const SizedBox(height: 10),
              _buildTextField(thalachController, 'Max Heart Rate'),
              const SizedBox(height: 10),
              _buildDropdown('Exercise-induced Angina', ['Select Option', 'Yes', 'No'], exangValue, (value) {
                setState(() {
                  exangValue = value!;
                });
              }),
              const SizedBox(height: 10),
              _buildTextField(oldpeakController, 'ST depression'),
              const SizedBox(height: 10),
              _buildDropdown('Slope', ['Select Option', 'Upsloping', 'Flat', 'Downsloping'], slopeValue, (value) {
                setState(() {
                  slopeValue = value!;
                });
              }),
              const SizedBox(height: 10),
              _buildTextField(caController, 'Number of Major vessels'),
              const SizedBox(height: 10),
              _buildDropdown('Thalassemia', ['Select Option', 'Normal', 'Fixed Defect', 'Reversible Defect'], thalValue, (value) {
                setState(() {
                  thalValue = value!;
                });
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  predict();
                  print(predictionResult);
                  predictionResult.isNotEmpty
                      ? Get.to(const Prediction(), arguments: predictionResult)
                      : const CircularProgressIndicator();
                },
                child: Text('Predict', style: GoogleFonts.ubuntu(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              thalValue.isNotEmpty ? const LinearProgressIndicator(color: Colors.green) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.green),
        suffixIcon: Icon(FontAwesomeIcons.userPen, color: Colors.green),
      ),
    );
  }

  DropdownButtonFormField<String> _buildDropdown(
      String labelText,
      List<String> items,
      String value,
      Function(String?)? onChanged,
      ) {
    return DropdownButtonFormField<String>(
      menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
      dropdownColor: Colors.white,
      elevation: 5,
      icon: Icon(FontAwesomeIcons.angleDown, color: Colors.green),
      borderRadius: BorderRadius.circular(8),
      value: value.isNotEmpty ? value : null,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: GoogleFonts.ubuntu()),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.green),
      ),
    );
  }

  String ChestPain(String type) {
    if (type == "Typical Angina") return '0';
    if (type == "Atypical Angina") return '1';
    if (type == "Non-anginal Pain") return '2';
    return '3';
  }

  String Restecg(String type) {
    if (type == "Normal") return '0';
    if (type == "ST-T wave abnormality") return '1';
    return '2';
  }

  String Slope(String type) {
    if (type == "Upsloping") return '0';
    if (type == "Flat") return '1';
    return '2';
  }

  String Thalass(String type) {
    if (type == "Normal") return '0';
    if (type == "Fixed Defect") return '1';
    return '2';
  }
}
