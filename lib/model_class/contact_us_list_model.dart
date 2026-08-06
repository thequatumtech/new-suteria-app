class ContactChatsListModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  ContactChatsListModel(
      {this.status, this.statusCode, this.message, this.data});

  ContactChatsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Messages>? messages;
  String? clientName;
  String? filePath;

  Data({this.messages, this.clientName, this.filePath});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
    clientName = json['client_name'];
    filePath = json['file_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    data['client_name'] = this.clientName;
    data['file_path'] = this.filePath;
    return data;
  }
}

class Messages {
  int? id;
  int? clientId;
  String? message;
  String? isMessage;
  String? sentBy;
  String? isRead;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Client? client;

  Messages(
      {this.id,
        this.clientId,
        this.message,
        this.isMessage,
        this.sentBy,
        this.isRead,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.client});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    message = json['message'];
    isMessage = json['is_message'];
    sentBy = json['sent_by'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    client =
    json['client'] != null ? new Client.fromJson(json['client']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['message'] = this.message;
    data['is_message'] = this.isMessage;
    data['sent_by'] = this.sentBy;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.client != null) {
      data['client'] = this.client!.toJson();
    }
    return data;
  }
}

class Client {
  int? id;
  String? firstName;
  String? fatherName;
  String? grandfatherName;
  String? surname;
  String? language;
  int? nationalityId;
  String? nationalIdNumber;
  String? residenceIdNumber;
  String? birthDate;
  String? gender;
  String? maritalStatus;
  String? emailId;
  String? mobileNo;
  int? countryId;
  String? residingCountrySame;
  int? residingCountryId;
  int? cityId;
  int? districtId;
  String? streetName;
  String? buildingNo;
  String? employmentType;
  String? companyName;
  int? occupationId;
  String? position;
  String? workNature;
  int? companyCityId;
  int? companyDistrictId;
  String? companyStreetName;
  String? companyBuildingNo;
  String? companyContactNo;
  String? idFront;
  String? idBack;
  String? profilePic;
  int? agentId;
  int? noOfPolicies;
  String? hasCompany;
  String? isBlacklisted;
  String? blackListReason;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Client(
      {this.id,
        this.firstName,
        this.fatherName,
        this.grandfatherName,
        this.surname,
        this.language,
        this.nationalityId,
        this.nationalIdNumber,
        this.residenceIdNumber,
        this.birthDate,
        this.gender,
        this.maritalStatus,
        this.emailId,
        this.mobileNo,
        this.countryId,
        this.residingCountrySame,
        this.residingCountryId,
        this.cityId,
        this.districtId,
        this.streetName,
        this.buildingNo,
        this.employmentType,
        this.companyName,
        this.occupationId,
        this.position,
        this.workNature,
        this.companyCityId,
        this.companyDistrictId,
        this.companyStreetName,
        this.companyBuildingNo,
        this.companyContactNo,
        this.idFront,
        this.idBack,
        this.profilePic,
        this.agentId,
        this.noOfPolicies,
        this.hasCompany,
        this.isBlacklisted,
        this.blackListReason,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    fatherName = json['father_name'];
    grandfatherName = json['grandfather_name'];
    surname = json['surname'];
    language = json['language'];
    nationalityId = json['nationality_id'];
    nationalIdNumber = json['national_id_number'];
    residenceIdNumber = json['residence_id_number'];
    birthDate = json['birth_date'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    emailId = json['email_id'];
    mobileNo = json['mobile_no'];
    countryId = json['country_id'];
    residingCountrySame = json['residing_country_same'];
    residingCountryId = json['residing_country_id'];
    cityId = json['city_id'];
    districtId = json['district_id'];
    streetName = json['street_name'];
    buildingNo = json['building_no'];
    employmentType = json['employment_type'];
    companyName = json['company_name'];
    occupationId = json['occupation_id'];
    position = json['position'];
    workNature = json['work_nature'];
    companyCityId = json['company_city_id'];
    companyDistrictId = json['company_district_id'];
    companyStreetName = json['company_street_name'];
    companyBuildingNo = json['company_building_no'];
    companyContactNo = json['company_contact_no'];
    idFront = json['id_front'];
    idBack = json['id_back'];
    profilePic = json['profile_pic'];
    agentId = json['agent_id'];
    noOfPolicies = json['no_of_policies'];
    hasCompany = json['has_company'];
    isBlacklisted = json['is_blacklisted'];
    blackListReason = json['black_list_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['father_name'] = this.fatherName;
    data['grandfather_name'] = this.grandfatherName;
    data['surname'] = this.surname;
    data['language'] = this.language;
    data['nationality_id'] = this.nationalityId;
    data['national_id_number'] = this.nationalIdNumber;
    data['residence_id_number'] = this.residenceIdNumber;
    data['birth_date'] = this.birthDate;
    data['gender'] = this.gender;
    data['marital_status'] = this.maritalStatus;
    data['email_id'] = this.emailId;
    data['mobile_no'] = this.mobileNo;
    data['country_id'] = this.countryId;
    data['residing_country_same'] = this.residingCountrySame;
    data['residing_country_id'] = this.residingCountryId;
    data['city_id'] = this.cityId;
    data['district_id'] = this.districtId;
    data['street_name'] = this.streetName;
    data['building_no'] = this.buildingNo;
    data['employment_type'] = this.employmentType;
    data['company_name'] = this.companyName;
    data['occupation_id'] = this.occupationId;
    data['position'] = this.position;
    data['work_nature'] = this.workNature;
    data['company_city_id'] = this.companyCityId;
    data['company_district_id'] = this.companyDistrictId;
    data['company_street_name'] = this.companyStreetName;
    data['company_building_no'] = this.companyBuildingNo;
    data['company_contact_no'] = this.companyContactNo;
    data['id_front'] = this.idFront;
    data['id_back'] = this.idBack;
    data['profile_pic'] = this.profilePic;
    data['agent_id'] = this.agentId;
    data['no_of_policies'] = this.noOfPolicies;
    data['has_company'] = this.hasCompany;
    data['is_blacklisted'] = this.isBlacklisted;
    data['black_list_reason'] = this.blackListReason;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
