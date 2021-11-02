import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Message {
  String? sendTime;
  String? from;
  String? to;
  Message(this.sendTime, this.from, this.to);

  factory Message.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final String? type = doc.data()!['type'];
    Message? message;
    switch (type) {
      case 'text':
        message = TextMessage.fromFirestore(doc);
        break;
      case 'image':
        message = ImageMessage.fromFirestore(doc);
        break;
      case 'video':
        message = VideoMessage.fromFirestore(doc);
        break;
      case 'gif':
        message = GifMessage.fromFirestore(doc);
        break;
      case 'audio':
        message = AudioMessage.fromFirestore(doc);
        break;
      case 'doc':
        message = DocumentMessage.fromFirestore(doc);
        break;
    }
    return message!;
  }

  Map<String, dynamic> toMap();
}

class TextMessage extends Message {
  String message;
  TextMessage(this.message, sendTime, from, to) : super(sendTime, from, to);

  factory TextMessage.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map data = doc.data()!;
    return TextMessage.fromMap(data);
  }

  factory TextMessage.fromMap(Map data) {
    return TextMessage(
        data['message'], data['sendTime'], data['from'], data['to']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['message'] = message;
    map['sendTime'] = sendTime;
    map['from'] = from;
    map['to'] = to;
    map['type'] = 'text';
    return map;
  }
}

class ImageMessage extends Message {
  String imageUrl;
  ImageMessage(this.imageUrl, sendTime, from, to) : super(sendTime, from, to);

  factory ImageMessage.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map data = doc.data()!;
    return ImageMessage.fromMap(data);
  }
  factory ImageMessage.fromMap(Map data) {
    return ImageMessage(
        data['imageUrl'], data['sendTime'], data['from'], data['to']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['imageUrl'] = imageUrl;
    map['sendTime'] = sendTime;
    map['from'] = from;
    map['to'] = to;
    map['type'] = 'image';
    return map;
  }
}

class GifMessage extends Message {
  String gifUrl;
  GifMessage(this.gifUrl, sendTime, from, to) : super(sendTime, from, to);

  factory GifMessage.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map data = doc.data()!;
    return GifMessage.fromMap(data);
  }
  factory GifMessage.fromMap(Map data) {
    return GifMessage(
        data['gifUrl'], data['sendTime'], data['from'], data['to']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['gifUrl'] = gifUrl;
    map['sendTime'] = sendTime;
    map['from'] = from;
    map['to'] = to;
    map['type'] = 'gif';
    return map;
  }
}

class VideoMessage extends Message {
  String videoUrl;
  VideoMessage(this.videoUrl, sendTime, from, to) : super(sendTime, from, to);

  factory VideoMessage.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map data = doc.data()!;
    return VideoMessage.fromMap(data);
  }
  factory VideoMessage.fromMap(Map data) {
    return VideoMessage(
        data['videoUrl'], data['sendTime'], data['from'], data['to']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['videoUrl'] = videoUrl;
    map['sendTime'] = sendTime;
    map['from'] = from;
    map['to'] = to;
    map['type'] = 'video';
    return map;
  }
}

class DocumentMessage extends Message {
  String docUrl;
  DocumentMessage(this.docUrl, sendTime, from, to) : super(sendTime, from, to);

  factory DocumentMessage.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map data = doc.data()!;
    return DocumentMessage.fromMap(data);
  }
  factory DocumentMessage.fromMap(Map data) {
    return DocumentMessage(
        data['docUrl'], data['sendTime'], data['from'], data['to']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['docUrl'] = docUrl;
    map['sendTime'] = sendTime;
    map['from'] = from;
    map['to'] = to;
    map['type'] = 'doc';
    return map;
  }
}

class AudioMessage extends Message {
  String audioUrl;
  AudioMessage(this.audioUrl, sendTime, from, to) : super(sendTime, from, to);

  factory AudioMessage.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map data = doc.data()!;
    return AudioMessage.fromMap(data);
  }
  factory AudioMessage.fromMap(Map data) {
    return AudioMessage(
        data['audioUrl'], data['sendTime'], data['from'], data['to']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['audioUrl'] = audioUrl;
    map['sendTime'] = sendTime;
    map['from'] = from;
    map['to'] = to;
    map['type'] = 'audio';
    return map;
  }
}
