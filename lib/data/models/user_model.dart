class UserModel {
  final String uid;
  final String name;
  final String email;
  final String instagram;
  final String photoUrl;
  final String createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.instagram = '@spacenews_user',
    this.photoUrl = '',
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      instagram: map['instagram'] as String? ?? '@spacenews_user',
      photoUrl: map['photoUrl'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'instagram': instagram,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };
  }
}
