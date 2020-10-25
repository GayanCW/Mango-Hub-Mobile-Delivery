class LocalDistricts {
  List<Districts> districts;

  LocalDistricts({this.districts});

  LocalDistricts.fromJson(Map<String, dynamic> json) {
    if (json['districts'] != null) {
      districts = new List<Districts>();
      json['districts'].forEach((v) {
        districts.add(new Districts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.districts != null) {
      data['districts'] = this.districts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Districts {
  int id;
  String district;
  List<String> city;

  Districts({this.id, this.district, this.city});

  Districts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    district = json['district'];
    city = json['city'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['district'] = this.district;
    data['city'] = this.city;
    return data;
  }
}