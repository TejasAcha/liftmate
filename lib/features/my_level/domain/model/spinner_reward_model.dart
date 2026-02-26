class SpinnerRewardModel {
  final int id;
  final String title;
  final double points;
  final String icon;
  final String color;

  SpinnerRewardModel({
    required this.id,
    required this.title,
    required this.points,
    required this.icon,
    required this.color,
  });

  factory SpinnerRewardModel.fromJson(Map<String, dynamic> json) {
    return SpinnerRewardModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      points: (json['points'] ?? 0).toDouble(),
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#FFFFFF',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'points': points,
      'icon': icon,
      'color': color,
    };
  }
}
