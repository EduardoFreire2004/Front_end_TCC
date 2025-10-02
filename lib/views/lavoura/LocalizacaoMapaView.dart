import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalizacaoMapaView extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const LocalizacaoMapaView({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<LocalizacaoMapaView> createState() => _LocalizacaoMapaViewState();
}

class _LocalizacaoMapaViewState extends State<LocalizacaoMapaView> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  final Color primaryColor = Colors.green[700]!;
  final Color primaryColorDark = Colors.green[800]!;
  final Color errorColor = Colors.redAccent;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {

      final permission = await Permission.location.request();
      if (permission != PermissionStatus.granted) {
        _showErrorDialog('Permissão de localização negada');
        return;
      }

      LatLng initialPosition;

      if (widget.initialLatitude != null && widget.initialLongitude != null) {

        initialPosition = LatLng(
          widget.initialLatitude!,
          widget.initialLongitude!,
        );
        _selectedLocation = initialPosition;
        _addMarker(initialPosition);
      } else {

        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        initialPosition = LatLng(position.latitude, position.longitude);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Erro ao obter localização: $e');
    }
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          infoWindow: const InfoWindow(
            title: 'Localização da Lavoura',
            snippet: 'Toque no mapa para alterar',
          ),
        ),
      );
      _selectedLocation = position;
    });
  }

  void _onMapTap(LatLng position) {
    _addMarker(position);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Erro'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      Navigator.pop(context, {
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma localização no mapa'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final newPosition = LatLng(position.latitude, position.longitude);

      _addMarker(newPosition);

      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(newPosition));
      }
    } catch (e) {
      _showErrorDialog('Erro ao obter localização atual: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Localização'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _confirmLocation,
            child: const Text(
              'CONFIRMAR',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Carregando mapa...'),
                  ],
                ),
              )
              : Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target:
                          _selectedLocation ??
                          const LatLng(
                            -23.5505,
                            -46.6333,
                          ), // São Paulo como fallback
                      zoom: 15.0,
                    ),
                    onTap: _onMapTap,
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    compassEnabled: true,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: _getCurrentLocation,
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.my_location, color: Colors.white),
                    ),
                  ),
                  if (_selectedLocation != null)
                    Positioned(
                      bottom: 100,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coordenadas selecionadas:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColorDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Latitude: ${_selectedLocation!.latitude.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Longitude: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
    );
  }
}

