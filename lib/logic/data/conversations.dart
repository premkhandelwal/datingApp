import 'package:dating_app/logic/data/message.dart';

class Conversations {
  String? message;
  String? sendTime;
  String? chatid;
  String? userId;
  String? status;

  Conversations(
      {this.message, this.sendTime, this.userId, this.chatid, this.status});

  factory Conversations.fromRecieverMessage(Message message, String chatid) {
    if (message is TextMessage) {
      return Conversations(
          chatid: chatid,
          message: message.message,
          sendTime: message.sendTime,
          userId: message.to,
          status: 'seen');
    } else if (message is ImageMessage) {
      return Conversations(
          chatid: chatid,
          message: '📷 Photo',
          sendTime: message.sendTime,
          userId: message.to,
          status: 'seen');
    } else if (message is VideoMessage) {
      return Conversations(
          chatid: chatid,
          message: '📹 Video',
          sendTime: message.sendTime,
          userId: message.to,
          status: 'seen');
    } else if (message is GifMessage) {
      return Conversations(
          chatid: chatid,
          message: 'GIF',
          sendTime: message.sendTime,
          userId: message.to,
          status: 'seen');
    } else if (message is AudioMessage) {
      return Conversations(
          chatid: chatid,
          message: '🔊 Audio',
          sendTime: message.sendTime,
          userId: message.to,
          status: 'seen');
    } else if (message is DocumentMessage) {
      return Conversations(
          chatid: chatid,
          message: '📝 DOC',
          sendTime: message.sendTime,
          userId: message.to,
          status: 'seen');
    }
    return Conversations();
  }

  factory Conversations.fromSenderMessage(Message message, String chatid) {
    if (message is TextMessage) {
      return Conversations(
          chatid: chatid,
          message: message.message,
          sendTime: message.sendTime,
          userId: message.from,
          status: 'unseen');
    } else if (message is ImageMessage) {
      return Conversations(
          chatid: chatid,
          message: '📷 Photo',
          sendTime: message.sendTime,
          userId: message.from,
          status: 'unseen');
    } else if (message is VideoMessage) {
      return Conversations(
          chatid: chatid,
          message: '📹 Video',
          sendTime: message.sendTime,
          userId: message.from,
          status: 'unseen');
    } else if (message is GifMessage) {
      return Conversations(
          chatid: chatid,
          message: 'GIF',
          sendTime: message.sendTime,
          userId: message.from,
          status: 'unseen');
    } else if (message is AudioMessage) {
      return Conversations(
          chatid: chatid,
          message: '🔊 Audio',
          sendTime: message.sendTime,
          userId: message.from,
          status: 'unseen');
    } else if (message is DocumentMessage) {
      return Conversations(
          chatid: chatid,
          message: '📝 DOC',
          sendTime: message.sendTime,
          userId: message.from,
          status: 'unseen');
    }
    return Conversations();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['message'] = message;
    map['sendTime'] = sendTime;
    map['userId'] = userId;
    map['chatid'] = chatid;
    map['status'] = status;
    return map;
  }

  factory Conversations.fromJson(Map<String, dynamic> json) {
    return Conversations(
        message: json['message'],
        sendTime: json['sendTime'],
        userId: json['userId'],
        chatid: json['chatid'],
        status: json['status']);
  }
}
