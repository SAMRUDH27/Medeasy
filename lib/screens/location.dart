import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OpenStreetMapApiService {
  final String baseUrl = 'https://nominatim.openstreetmap.org/';

  Future<List<dynamic>> fetchNearbyPlaces(double lat, double lon, String placeType) async {
    // Using a larger radius for better results
    String url = '${baseUrl}search?format=json&lat=$lat&lon=$lon&zoom=18&addressdetails=1&q=$placeType&limit=50';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class NearbyPlacesController extends GetxController {
  final OpenStreetMapApiService _apiService = OpenStreetMapApiService();
  
  RxList<dynamic> pharmacies = [].obs;
  RxDouble userLat = 0.0.obs;
  RxDouble userLon = 0.0.obs;
  RxBool isLoading = false.obs;

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled. Please enable them.')),
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return false;
    }
    
    return true;
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    isLoading.value = true;
    try {
      final hasPermission = await _handleLocationPermission(context);
      if (!hasPermission) return;
      
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      userLat.value = position.latitude;
      userLon.value = position.longitude;
      
      await fetchNearbyPharmacies();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNearbyPharmacies() async {
    try {
      pharmacies.value = await _apiService.fetchNearbyPlaces(
        userLat.value, 
        userLon.value, 
        'pharmacy'
      );
    } catch (e) {
      print('Error fetching pharmacies: $e');
      pharmacies.value = [];
    }
  }
}

class PharmacyFinder extends StatelessWidget {
  final NearbyPlacesController controller = Get.put(NearbyPlacesController());

  PharmacyFinder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Pharmacies'),
        actions: [
          Obx(() => controller.isLoading.value
            ? const Center(child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: Colors.white),
              ))
            : IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.getCurrentLocation(context),
              )
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.userLat.value == 0 && controller.userLon.value == 0) {
                return Center(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.getCurrentLocation(context),
                    icon: const Icon(Icons.location_on),
                    label: const Text('Get Current Location'),
                  ),
                );
              }
              
              return FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                    controller.userLat.value,
                    controller.userLon.value
                  ),
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      // User location marker
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: LatLng(
                          controller.userLat.value,
                          controller.userLon.value
                        ),
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                      // Pharmacy markers
                      ...controller.pharmacies.map((pharmacy) => Marker(
                        width: 40.0,
                        height: 40.0,
                        point: LatLng(
                          double.parse(pharmacy['lat']),
                          double.parse(pharmacy['lon'])
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pharmacy['display_name'] ?? 'Pharmacy',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    FutureBuilder<double>(
                                      future: Future.value(Geolocator.distanceBetween(
                                        controller.userLat.value,
                                        controller.userLon.value,
                                        double.parse(pharmacy['lat']),
                                        double.parse(pharmacy['lon'])
                                      )),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            'Distance: ${(snapshot.data! / 1000).toStringAsFixed(2)} km',
                                            style: const TextStyle(fontSize: 16),
                                          );
                                        }
                                        return const Text('Calculating distance...');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.local_pharmacy,
                            color: Colors.green,
                            size: 40,
                          ),
                        ),
                      )).toList(),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}