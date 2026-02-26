class SubscriptionPlanModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String frequency; // 'monthly', 'yearly', 'lifetime'
  final int duration; // in days
  final List<String> features;
  final double discountPercentage;
  final bool isMostPopular;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.frequency,
    required this.duration,
    required this.features,
    required this.discountPercentage,
    required this.isMostPopular,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      frequency: json['frequency'] ?? 'monthly',
      duration: json['duration'] ?? 30,
      features: List<String>.from(json['features'] ?? []),
      discountPercentage: (json['discount_percentage'] ?? 0).toDouble(),
      isMostPopular: json['is_most_popular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'frequency': frequency,
      'duration': duration,
      'features': features,
      'discount_percentage': discountPercentage,
      'is_most_popular': isMostPopular,
    };
  }
}

class UserSubscriptionModel {
  final String id;
  final String planId;
  final String planName;
  final DateTime startDate;
  final DateTime expiryDate;
  final bool isActive;
  final String status; // 'active', 'expired', 'cancelled'

  UserSubscriptionModel({
    required this.id,
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.expiryDate,
    required this.isActive,
    required this.status,
  });

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionModel(
      id: json['id'] ?? '',
      planId: json['plan_id'] ?? '',
      planName: json['plan_name'] ?? '',
      startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toString()),
      expiryDate: DateTime.parse(json['expiry_date'] ?? DateTime.now().toString()),
      isActive: json['is_active'] ?? false,
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'plan_name': planName,
      'start_date': startDate.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
      'is_active': isActive,
      'status': status,
    };
  }
}
