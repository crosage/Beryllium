class LogEntry {
  final int uid;
  final String username;
  final String name;
  final String timestamp;
  final String operation;

  LogEntry({
    required this.uid,
    required this.username,
    required this.name,
    required this.timestamp,
    required this.operation,
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      uid: json['uid'],
      username: json['username'],
      name: json['name'],
      timestamp: json['timestamp'],
      operation: json['operation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'timestamp': timestamp,
      'operation': operation,
    };
  }
}
