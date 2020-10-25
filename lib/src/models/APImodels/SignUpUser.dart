
class SignUpUser {
  bool success;
  bool exist;
  Login login;

  SignUpUser({this.success, this.login, this.exist});

  SignUpUser.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    exist = json['exist'];
    login = json['login'] != null ? new Login.fromJson(json['login']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['exist'] = this.exist;
    if (this.login != null) {
      data['login'] = this.login.toJson();
    }
    return data;
  }
}

class Login {
  List<String> loginCompanies;
  String sId;
  String loginEmail;
  String loginPassword;
  String loginSalt;
  String loginType;
  String loginRole;
  bool loginStatus;
  String loginStatusString;
  String userProfileId;
  int iV;

  Login({this.loginCompanies,
        this.sId,
        this.loginEmail,
        this.loginPassword,
        this.loginSalt,
        this.loginType,
        this.loginRole,
        this.loginStatus,
        this.loginStatusString,
        this.userProfileId,
        this.iV});

  Login.fromJson(Map<String, dynamic> json) {
    loginCompanies = json['login_companies'].cast<String>();
    sId = json['_id'];
    loginEmail = json['login_email'];
    loginPassword = json['login_password'];
    loginSalt = json['login_salt'];
    loginType = json['login_type'];
    loginRole = json['login_role'];
    loginStatus = json['login_status'];
    loginStatusString = json['login_status_string'];
    userProfileId = json['user_profile_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login_companies'] = this.loginCompanies;
    data['_id'] = this.sId;
    data['login_email'] = this.loginEmail;
    data['login_password'] = this.loginPassword;
    data['login_salt'] = this.loginSalt;
    data['login_type'] = this.loginType;
    data['login_role'] = this.loginRole;
    data['login_status'] = this.loginStatus;
    data['login_status_string'] = this.loginStatusString;
    data['user_profile_id'] = this.userProfileId;
    data['__v'] = this.iV;
    return data;
  }
}