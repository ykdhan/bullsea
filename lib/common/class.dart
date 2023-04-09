// date: Moment.parse(json['updatedTime'] ?? json['createdTime'])
//     .format('MM. dd. yyyy'),

enum NetworkType { ethereum }

enum NotificationType { alert, event, announcement }

class BSNotification {
  int uid;
  NotificationType type;
  String title;
  String message;
  bool read;

  BSNotification({
    required this.uid,
    this.type = NotificationType.alert,
    required this.title,
    required this.message,
    this.read = false,
  });

  factory BSNotification.fromJson(Map<String, dynamic> json) {
    return BSNotification(uid: 0, title: '', message: '');
  }
}

class BSTokenBalance {
  String contract;
  String name;
  String symbol;
  String profile;
  double amount;

  BSTokenBalance({
    required this.contract,
    required this.name,
    required this.symbol,
    this.profile = '',
    this.amount = 0,
  });
}
