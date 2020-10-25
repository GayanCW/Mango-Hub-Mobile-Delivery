List<NearbyCompanies> nearbyCompaniesList = new List<NearbyCompanies>();

class GetNearbyCompaniesModel {
  List<NearbyCompanies> nearbyCompanies;

  GetNearbyCompaniesModel();

  GetNearbyCompaniesModel.fromJson(json) {
    List<dynamic> fixedLengthList = json;
    if(json==null) return;
    try{
      nearbyCompanies = NearbyCompanies.listFromJson(fixedLengthList);
    }catch(e){
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    return {'nearbyCompanies': nearbyCompanies};
  }
  static List<GetNearbyCompaniesModel> listFromJson(List<dynamic> json) {
    return json == null
        ? new List<GetNearbyCompaniesModel>()
        : json.map((value) => new GetNearbyCompaniesModel.fromJson(value)).toList();
  }
  static Map<String, GetNearbyCompaniesModel> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = new Map<String, GetNearbyCompaniesModel>();
    if (json != null && json.length > 0) {
      json.forEach((String key, Map<String, dynamic> value) =>
      map[key] = new GetNearbyCompaniesModel.fromJson(value));
    }
    return map;
  }
}

class NearbyCompanies {
  BranchAddress branchAddress;
  String sId;
  String branchName;
  String branchTel;
  String branchLocation;
  bool branchStatus;
  String branchStatusString;
  String branchType;
  String branchCompany;
  String createdAt;
  String updatedAt;
  int iV;

  NearbyCompanies(
      {this.branchAddress,
        this.sId,
        this.branchName,
        this.branchTel,
        this.branchLocation,
        this.branchStatus,
        this.branchStatusString,
        this.branchType,
        this.branchCompany,
        this.createdAt,
        this.updatedAt,
        this.iV});

  NearbyCompanies.fromJson(Map<String, dynamic> json) {
    branchAddress = json['branch_address'] != null
        ? new BranchAddress.fromJson(json['branch_address'])
        : null;
    sId = json['_id'];
    branchName = json['branch_name'];
    branchTel = json['branch_tel'];
    branchLocation = json['branch_location'];
    branchStatus = json['branch_status'];
    branchStatusString = json['branch_status_string'];
    branchType = json['branch_type'];
    branchCompany = json['branch_company'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.branchAddress != null) {
      data['branch_address'] = this.branchAddress.toJson();
    }
    data['_id'] = this.sId;
    data['branch_name'] = this.branchName;
    data['branch_tel'] = this.branchTel;
    data['branch_location'] = this.branchLocation;
    data['branch_status'] = this.branchStatus;
    data['branch_status_string'] = this.branchStatusString;
    data['branch_type'] = this.branchType;
    data['branch_company'] = this.branchCompany;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }

  static List<NearbyCompanies> listFromJson(List<dynamic> json) {
    return json == null
        ? new List<NearbyCompanies>()
        : json.map((value) => new NearbyCompanies.fromJson(value)).toList();
  }
  static Map<String, NearbyCompanies> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = new Map<String, NearbyCompanies>();
    if (json != null && json.length > 0) {
      json.forEach((String key, Map<String, dynamic> value) =>
      map[key] = new NearbyCompanies.fromJson(value));
    }
    return map;
  }

}

class BranchAddress {
  String addressLine1;
  String addressLine2;
  String country;
  String district;
  String city;
  String zipCode;

  BranchAddress(
      {this.addressLine1,
        this.addressLine2,
        this.country,
        this.district,
        this.city,
        this.zipCode});

  BranchAddress.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    country = json['country'];
    district = json['district'];
    city = json['city'];
    zipCode = json['zip_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line1'] = this.addressLine1;
    data['address_line2'] = this.addressLine2;
    data['country'] = this.country;
    data['district'] = this.district;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    return data;
  }
}