class NotificationModel {
  final String title;
  final String message;
  final String time;
  final String iconName;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    this.iconName = 'notifications',
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      time: map['time'] as String? ?? '',
      iconName: map['iconName'] as String? ?? 'notifications',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'time': time,
      'iconName': iconName,
    };
  }

  static List<NotificationModel> get dummyNotifications => [
        NotificationModel(
          title: 'New Article Available',
          message: 'New spaceflight article is available',
          time: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
          iconName: 'article',
        ),
        NotificationModel(
          title: 'Favorite Saved',
          message: 'Your favorite article has been saved',
          time: DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
          iconName: 'favorite',
        ),
        NotificationModel(
          title: 'Daily Briefing',
          message: 'Daily space briefing is ready',
          time: DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
          iconName: 'briefing',
        ),
        NotificationModel(
          title: 'Mission Update',
          message: 'International mission update published',
          time: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          iconName: 'mission',
        ),
        NotificationModel(
          title: 'Breaking News',
          message: 'Breaking: New discovery in deep space exploration',
          time: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
          iconName: 'breaking',
        ),
      ];
}
