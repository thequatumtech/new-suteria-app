class InsurancePeriodModel {
  final int? id;
  final String? name;

  InsurancePeriodModel({this.id, this.name});

  factory InsurancePeriodModel.fromJson(Map<String, dynamic> json) {
    return InsurancePeriodModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }
}