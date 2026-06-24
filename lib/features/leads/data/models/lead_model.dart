import 'package:json_annotation/json_annotation.dart';

part 'lead_model.g.dart';

@JsonSerializable()
class LeadModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? company;
  final String stage;
  final String sourceId;
  final String assignedToId;
  final String companyId;
  final DateTime createdAt;

  LeadModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.company,
    required this.stage,
    required this.sourceId,
    required this.assignedToId,
    required this.companyId,
    required this.createdAt,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) => _$LeadModelFromJson(json);
  Map<String, dynamic> toJson() => _$LeadModelToJson(this);
}
