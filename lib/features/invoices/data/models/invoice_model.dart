class InvoiceModel {
  final String id;
  final String number;
  final String bookingId;
  final String status;
  final double amount;
  final DateTime issuedAt;
  final DateTime dueDate;
  final DateTime? paidAt;
  final String? pdfUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Nested booking containing lead
  final BookingWithLeadModel? booking;

  InvoiceModel({
    required this.id,
    required this.number,
    required this.bookingId,
    required this.status,
    required this.amount,
    required this.issuedAt,
    required this.dueDate,
    this.paidAt,
    this.pdfUrl,
    required this.createdAt,
    required this.updatedAt,
    this.booking,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as String,
      number: json['number'] as String,
      bookingId: json['bookingId'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt'] as String) : null,
      pdfUrl: json['pdfUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      booking: json['booking'] != null ? BookingWithLeadModel.fromJson(json['booking'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'bookingId': bookingId,
      'status': status,
      'amount': amount,
      'issuedAt': issuedAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
      'pdfUrl': pdfUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'booking': booking?.toJson(),
    };
  }
}

class BookingWithLeadModel {
  final String id;
  final String leadId;
  final String serviceId;
  final double amount;
  final double collectedAmount;
  final double pendingAmount;
  final LeadInfoModel? lead;

  BookingWithLeadModel({
    required this.id,
    required this.leadId,
    required this.serviceId,
    required this.amount,
    required this.collectedAmount,
    required this.pendingAmount,
    this.lead,
  });

  factory BookingWithLeadModel.fromJson(Map<String, dynamic> json) {
    return BookingWithLeadModel(
      id: json['id'] as String,
      leadId: json['leadId'] as String,
      serviceId: json['serviceId'] as String,
      amount: (json['amount'] as num).toDouble(),
      collectedAmount: (json['collectedAmount'] as num).toDouble(),
      pendingAmount: (json['pendingAmount'] as num).toDouble(),
      lead: json['lead'] != null ? LeadInfoModel.fromJson(json['lead'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leadId': leadId,
      'serviceId': serviceId,
      'amount': amount,
      'collectedAmount': collectedAmount,
      'pendingAmount': pendingAmount,
      'lead': lead?.toJson(),
    };
  }
}

class LeadInfoModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  LeadInfoModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory LeadInfoModel.fromJson(Map<String, dynamic> json) {
    return LeadInfoModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
