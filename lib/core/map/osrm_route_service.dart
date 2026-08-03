import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

/// Resolves road-following driving routes using the public OSRM service.
class OsrmRouteService {
  OsrmRouteService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://router.project-osrm.org',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: const <String, dynamic>{
                  'User-Agent': 'dllni-driver-app/1.0',
                },
              ),
            );

  final Dio _dio;

  Future<List<LatLng>?> fetchDrivingRoute(List<LatLng> waypoints) async {
    if (waypoints.length < 2) return null;

    final coordinates = waypoints
        .map((point) => '${point.longitude},${point.latitude}')
        .join(';');

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/route/v1/driving/$coordinates',
        queryParameters: const <String, dynamic>{
          'overview': 'full',
          'geometries': 'geojson',
          'steps': 'false',
        },
      );

      final routes = response.data?['routes'];
      if (routes is! List || routes.isEmpty) return null;

      final firstRoute = routes.first;
      if (firstRoute is! Map<String, dynamic>) return null;

      final geometry = firstRoute['geometry'];
      if (geometry is! Map<String, dynamic>) return null;

      final rawCoordinates = geometry['coordinates'];
      if (rawCoordinates is! List || rawCoordinates.length < 2) return null;

      return rawCoordinates
          .whereType<List>()
          .map((coordinate) {
            if (coordinate.length < 2) return null;
            final longitude = coordinate[0];
            final latitude = coordinate[1];
            if (longitude is! num || latitude is! num) return null;
            return LatLng(latitude.toDouble(), longitude.toDouble());
          })
          .whereType<LatLng>()
          .toList(growable: false);
    } catch (_) {
      return null;
    }
  }
}

Future<List<LatLng>> resolveRoadRoutePoints({
  required List<LatLng> fallbackWaypoints,
  OsrmRouteService? osrm,
}) async {
  if (fallbackWaypoints.length < 2) return const <LatLng>[];

  final service = osrm ?? OsrmRouteService();
  final roadRoute = await service.fetchDrivingRoute(fallbackWaypoints);

  if (roadRoute != null && roadRoute.length >= 2) return roadRoute;
  return fallbackWaypoints;
}
