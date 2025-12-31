class AgreementModel {
  final String id;
  final String donorId;
  final String neederId;
  final String status;
  final String donorDecision;
  final String neederDecision;
  final DateTime timestamp;
  final String governorate;
  final String hospitalName;

  AgreementModel({
    required this.id,
    required this.donorId,
    required this.neederId,
    required this.status,
    required this.donorDecision,
    required this.neederDecision,
    required this.timestamp,
    required this.governorate,
    required this.hospitalName,
  });

  AgreementModel copyWith({
    String? id,
    String? status,
    String? donorDecision,
    String? recipientDecision,
  }) {
    return AgreementModel(
      id: id ?? this.id,
      donorId: donorId,
      neederId: neederId,
      status: status ?? this.status,
      donorDecision: donorDecision ?? this.donorDecision,
      neederDecision: recipientDecision ?? neederDecision,
      timestamp: timestamp,
      governorate: governorate,
      hospitalName: hospitalName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'donorId': donorId,
      'recipientId': neederId,
      'status': status,
      'donorDecision': donorDecision,
      'recipientDecision': neederDecision,
      'timestamp': timestamp.toIso8601String(),
      'governorate': governorate,
      'hospitalName': hospitalName,
    };
  }

  factory AgreementModel.fromMap(Map<String, dynamic> map) {
    return AgreementModel(
      id: map['id'] ?? '',
      donorId: map['donorId'] ?? '',
      neederId: map['recipientId'] ?? '',
      status: map['status'] ?? '',
      donorDecision: map['donorDecision'] ?? '',
      neederDecision: map['recipientDecision'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      governorate: map['governorate'] ?? '',
      hospitalName: map['hospitalName'] ?? '',
    );
  }
}
