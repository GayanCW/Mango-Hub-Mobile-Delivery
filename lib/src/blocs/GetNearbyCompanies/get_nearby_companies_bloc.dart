import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mangoHub/src/models/APImodels/GetNearbyCompaniesModel.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'get_nearby_companies_event.dart';
part 'get_nearby_companies_state.dart';

class GetNearbyCompaniesBloc extends Bloc<GetNearbyCompaniesEvent, GetNearbyCompaniesState> {
  GetNearbyCompaniesBloc() : super(GetNearbyCompaniesInitial());

  @override
  Stream<GetNearbyCompaniesState> mapEventToState(
    GetNearbyCompaniesEvent event,
  ) async* {
    if(event is GetNearbyCompanies){
      yield* _getNearbyCompanies(event);
    }
  }

  Stream<GetNearbyCompaniesState> _getNearbyCompanies(GetNearbyCompanies event) async*{

    final String apiUrl = "https://app-a5e00a51-0c5e-4dce-a2df-5662105ba7f4.cleverapps.io/public/companies-nearby?"
                          "geo=${event.latitude},${event.longitude}&distance=${event.distance}";

    try{
      final response = await http.get(apiUrl);

      GetNearbyCompaniesModel _nearbyCompanies = new GetNearbyCompaniesModel();

      if(response.statusCode == 200 && response.body!=null){
        var validResponse = jsonDecode(response.body);
        _nearbyCompanies = GetNearbyCompaniesModel.fromJson(validResponse);
        yield GetNearbyCompaniesSuccess(_nearbyCompanies);
      }else{
        var failedResponse = jsonDecode(response.body);
        _nearbyCompanies = GetNearbyCompaniesModel.fromJson(failedResponse);
        yield GetNearbyCompaniesFailed(_nearbyCompanies);
      }
    }
    catch(e){
      String errorObject = e.toString().split(':')[1];
      yield GetNearbyCompaniesFailedException(errorObject);
    }

  }
}
