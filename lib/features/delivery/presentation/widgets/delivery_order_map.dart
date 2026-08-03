import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;

import '../../../../core/map/osrm_route_service.dart';
import '../../../../core/utils/app_colors.dart';
import '../../data/models/delivery_order_model.dart';

class DeliveryOrderMap extends StatefulWidget {
  const DeliveryOrderMap({super.key, required this.order});

  final DeliveryOrderModel order;

  @override
  State<DeliveryOrderMap> createState() => _DeliveryOrderMapState();
}

class _DeliveryOrderMapState extends State<DeliveryOrderMap> {
  LatLng? _driverLocation;
  List<LatLng> _routePoints = const [];
  bool _isLoading = true;
  String? _locationMessage;

  @override
  void initState() {
    super.initState();
    _loadMap();
  }

  @override
  void didUpdateWidget(covariant DeliveryOrderMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.id != widget.order.id ||
        oldWidget.order.status != widget.order.status ||
        oldWidget.order.pickupLatitude != widget.order.pickupLatitude ||
        oldWidget.order.pickupLongitude != widget.order.pickupLongitude ||
        oldWidget.order.dropoffLatitude != widget.order.dropoffLatitude ||
        oldWidget.order.dropoffLongitude != widget.order.dropoffLongitude) {
      _loadMap();
    }
  }

  Future<void> _loadMap() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _locationMessage = null;
      });
    }

    final driverLocation = await _getDriverLocation();
    final pickup = _validPoint(
      widget.order.pickupLatitude,
      widget.order.pickupLongitude,
    );
    final dropoff = _validPoint(
      widget.order.dropoffLatitude,
      widget.order.dropoffLongitude,
    );
    final target = _activeTarget(pickup: pickup, dropoff: dropoff);

    final waypoints = <LatLng>[];
    if (driverLocation != null && target != null) {
      waypoints.addAll([driverLocation, target]);
    } else if (pickup != null && dropoff != null) {
      waypoints.addAll([pickup, dropoff]);
    }

    final routePoints = await resolveRoadRoutePoints(
      fallbackWaypoints: waypoints,
    );

    if (!mounted) return;
    setState(() {
      _driverLocation = driverLocation;
      _routePoints = routePoints;
      _isLoading = false;
    });
  }

  Future<LatLng?> _getDriverLocation() async {
    try {
      final location = loc.Location();
      var serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }
      if (!serviceEnabled) {
        _locationMessage = 'فعّل خدمة الموقع لعرض مسارك الحالي.';
        return null;
      }

      var permission = await location.hasPermission();
      if (permission == loc.PermissionStatus.denied) {
        permission = await location.requestPermission();
      }
      if (permission != loc.PermissionStatus.granted) {
        _locationMessage = 'اسمح بالوصول إلى الموقع لعرض الطريق من موقعك.';
        return null;
      }

      final current = await location.getLocation();
      if (current.latitude == null || current.longitude == null) return null;

      return LatLng(current.latitude!, current.longitude!);
    } catch (_) {
      _locationMessage = 'تعذر تحديد موقعك الحالي، تم عرض مسار الطلب.';
      return null;
    }
  }

  LatLng? _activeTarget({required LatLng? pickup, required LatLng? dropoff}) {
    return switch (widget.order.status) {
      'picked_up' || 'delivered' || 'completed' => dropoff ?? pickup,
      _ => pickup ?? dropoff,
    };
  }

  LatLng? _validPoint(num latitude, num longitude) {
    final lat = latitude.toDouble();
    final lng = longitude.toDouble();
    if (lat == 0 && lng == 0) return null;
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null;
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final pickup = _validPoint(
      widget.order.pickupLatitude,
      widget.order.pickupLongitude,
    );
    final dropoff = _validPoint(
      widget.order.dropoffLatitude,
      widget.order.dropoffLongitude,
    );
    final points = <LatLng>[
      if (_driverLocation != null) _driverLocation!,
      if (pickup != null) pickup,
      if (dropoff != null) dropoff,
    ];

    if (points.isEmpty) {
      return const _MapUnavailableCard();
    }

    final center = LatLng(
      points.map((point) => point.latitude).reduce((a, b) => a + b) /
          points.length,
      points.map((point) => point.longitude).reduce((a, b) => a + b) /
          points.length,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                const Icon(Icons.route_rounded, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.order.status == 'picked_up'
                        ? 'الطريق إلى موقع العميل'
                        : 'الطريق إلى نقطة الاستلام',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'تحديث الموقع والمسار',
                  onPressed: _isLoading ? null : _loadMap,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(18),
            ),
            child: SizedBox(
              height: 270,
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: center,
                      initialZoom: 13.5,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.pinchZoom |
                            InteractiveFlag.drag |
                            InteractiveFlag.doubleTapZoom,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.dllni.driver',
                      ),
                      if (_routePoints.length >= 2)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routePoints,
                              color: AppColors.primary,
                              strokeWidth: 5,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          if (pickup != null)
                            _mapMarker(
                              point: pickup,
                              icon: Icons.store_rounded,
                              label: 'الاستلام',
                              color: const Color(0xFFF59E0B),
                            ),
                          if (dropoff != null)
                            _mapMarker(
                              point: dropoff,
                              icon: Icons.person_pin_circle_rounded,
                              label: 'العميل',
                              color: AppColors.primary,
                            ),
                          if (_driverLocation != null)
                            _mapMarker(
                              point: _driverLocation!,
                              icon: Icons.delivery_dining_rounded,
                              label: 'موقعك',
                              color: const Color(0xFF0CBBC7),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (_isLoading)
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.white54,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_locationMessage != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _locationMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.94),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 6,
                            children: [
                              _LegendItem(
                                color: Color(0xFFF59E0B),
                                label: 'الاستلام',
                              ),
                              _LegendItem(
                                color: AppColors.primary,
                                label: 'العميل',
                              ),
                              _LegendItem(
                                color: Color(0xFF0CBBC7),
                                label: 'موقعك',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Marker _mapMarker({
    required LatLng point,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Marker(
      point: point,
      width: 76,
      height: 62,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 34),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

class _MapUnavailableCard extends StatelessWidget {
  const _MapUnavailableCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Row(
        children: [
          Icon(Icons.map_outlined, color: Color(0xFF6B7280)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'إحداثيات مسار هذا الطلب غير متوفرة حالياً.',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
        ],
      ),
    );
  }
}
