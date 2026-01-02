class Doctor {
  final String id;
  final String name;
  final String specialty;
  final bool isActive;
  final DateTime joinedDate;
  final String image;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.isActive,
    required this.joinedDate,
    required this.image,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      isActive: json['isActive'],
      joinedDate: DateTime.parse(json['joinedDate']),
      image: json['image'],
    );
  }
}
