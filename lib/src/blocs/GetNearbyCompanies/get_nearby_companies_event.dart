part of 'get_nearby_companies_bloc.dart';

@immutable
abstract class GetNearbyCompaniesEvent {}

class GetNearbyCompanies extends GetNearbyCompaniesEvent{
  GetNearbyCompanies({this.latitude, this.longitude, this.distance});
  final double latitude;
  final double longitude;
  final double distance;
}