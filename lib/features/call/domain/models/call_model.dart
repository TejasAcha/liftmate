class CallModel {
  final String callId;
  final String callerId;
  final String callerName;
  final String callerImage;
  final String callType; // audio or video
  final String callStatus; // incoming, ringing, connected, ended
  final int callStartTime;
  final int callEndTime;
  final String callDirection; // incoming or outgoing

  CallModel({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.callerImage,
    required this.callType,
    required this.callStatus,
    required this.callStartTime,
    required this.callEndTime,
    required this.callDirection,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      callId: json['callId'] ?? '',
      callerId: json['callerId'] ?? '',
      callerName: json['callerName'] ?? '',
      callerImage: json['callerImage'] ?? '',
      callType: json['callType'] ?? 'audio',
      callStatus: json['callStatus'] ?? 'incoming',
      callStartTime: json['callStartTime'] ?? 0,
      callEndTime: json['callEndTime'] ?? 0,
      callDirection: json['callDirection'] ?? 'incoming',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'callerImage': callerImage,
      'callType': callType,
      'callStatus': callStatus,
      'callStartTime': callStartTime,
      'callEndTime': callEndTime,
      'callDirection': callDirection,
    };
  }
}

class CallHistoryModel {
  final String id;
  final String contactId;
  final String contactName;
  final String contactImage;
  final String callType; // audio or video
  final String callStatus; // completed, missed, rejected
  final int duration;
  final int timestamp;
  final String direction; // incoming or outgoing

  CallHistoryModel({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.contactImage,
    required this.callType,
    required this.callStatus,
    required this.duration,
    required this.timestamp,
    required this.direction,
  });

  factory CallHistoryModel.fromJson(Map<String, dynamic> json) {
    return CallHistoryModel(
      id: json['id'] ?? '',
      contactId: json['contactId'] ?? '',
      contactName: json['contactName'] ?? '',
      contactImage: json['contactImage'] ?? '',
      callType: json['callType'] ?? 'audio',
      callStatus: json['callStatus'] ?? 'completed',
      duration: json['duration'] ?? 0,
      timestamp: json['timestamp'] ?? 0,
      direction: json['direction'] ?? 'incoming',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactId': contactId,
      'contactName': contactName,
      'contactImage': contactImage,
      'callType': callType,
      'callStatus': callStatus,
      'duration': duration,
      'timestamp': timestamp,
      'direction': direction,
    };
  }
}
