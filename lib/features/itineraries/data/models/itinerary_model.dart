import 'package:json_annotation/json_annotation.dart';

part 'itinerary_model.g.dart';

@JsonSerializable()
class ItineraryModel {
  final String id;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final String leadId;
  final String? bookingId;
  final String companyId;
  final DateTime createdAt;

  ItineraryModel({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.leadId,
    this.bookingId,
    required this.companyId,
    required this.createdAt,
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) => _$ItineraryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ItineraryModelToJson(this);
}
