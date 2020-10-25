part of 'get_nearby_companies_bloc.dart';

@immutable
abstract class GetNearbyCompaniesState {}

class GetNearbyCompaniesInitial extends GetNearbyCompaniesState {}

class GetNearbyCompaniesSuccess extends GetNearbyCompaniesState{
  GetNearbyCompaniesSuccess(this.getNearbyCompanies);
  final GetNearbyCompaniesModel getNearbyCompanies;
}

class GetNearbyCompaniesFailed extends GetNearbyCompaniesState{
  GetNearbyCompaniesFailed(this.getNearbyCompanies);
  final GetNearbyCompaniesModel getNearbyCompanies;
}

class GetNearbyCompaniesFailedException extends GetNearbyCompaniesState{
  GetNearbyCompaniesFailedException(this.errorObject);
  final String errorObject;
}