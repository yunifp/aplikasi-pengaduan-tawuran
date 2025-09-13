// lib/app/models/report_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id;
  final String uid;
  final String description;
  final GeoPoint location;
  final String? imageUrl;
  final Timestamp timestamp;
  final String status;

  Report({
    required this.id,
    required this.uid,
    required this.description,
    required this.location,
    this.imageUrl,
    required this.timestamp,
    required this.status,
  });

  factory Report.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Report(
      id: doc.id,
      uid: data['uid'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      imageUrl: data['imageUrl'],
      timestamp: data['timestamp'] as Timestamp? ?? Timestamp.now(),
      status: data['status'] ?? 'unknown',
    );
  }
}