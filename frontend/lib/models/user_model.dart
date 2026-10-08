class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final List<String> roles;
  final String activeRole;

  final String? restaurantId;
  final Map<String, dynamic>? defaultAddress;
  final bool? isShipperOnline;
  final double? shipperWallet;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.roles,
    required this.activeRole,
    this.restaurantId,
    this.defaultAddress,
    this.isShipperOnline,
    this.shipperWallet,
  });

  factory UserModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return UserModel(
      uid: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      roles: List<String>.from(
        map['roles'] ?? ['customer'],
      ),
      activeRole: map['activeRole'] ?? 'customer',
      restaurantId: map['restaurantId'],
      defaultAddress: map['defaultAddress'] != null
          ? Map<String, dynamic>.from(
              map['defaultAddress'],
            )
          : null,
      isShipperOnline: map['isShipperOnline'],
      shipperWallet: (map['shipperWallet'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'roles': roles,
      'activeRole': activeRole,
      'restaurantId': restaurantId,
      'defaultAddress': defaultAddress,
      'isShipperOnline': isShipperOnline,
      'shipperWallet': shipperWallet,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    List<String>? roles,
    String? activeRole,
    String? restaurantId,
    Map<String, dynamic>? defaultAddress,
    bool? isShipperOnline,
    double? shipperWallet,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      roles: roles ?? this.roles,
      activeRole: activeRole ?? this.activeRole,
      restaurantId: restaurantId ?? this.restaurantId,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      isShipperOnline: isShipperOnline ?? this.isShipperOnline,
      shipperWallet: shipperWallet ?? this.shipperWallet,
    );
  }
}
