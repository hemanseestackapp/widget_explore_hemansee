import 'dart:convert';

PostModal postModalFromJson(String str) => PostModal.fromJson(json.decode(str));

String postModalToJson(PostModal data) => json.encode(data.toJson());


class PostModal {
  String? postId;
  String? postImage;
  String? caption;
  String? location;
  String? createBy;
  bool? isArchived;
  bool? isHidden;
  bool? isDraft;
  List<String>? like;
  List<String>? share;
  List<Comment>? comment;
  List<String>? save;
  String? time;

  PostModal({
     this.postId,
     this.postImage,
     this.caption,
     this.location,
     this.createBy,
     this.isArchived,
     this.isHidden,
    this.isDraft,
     this.like,
     this.share,
     this.comment,
    this.save,
    this.time,
  });

  factory PostModal.fromJson(Map<String, dynamic> json) => PostModal(
    postId: json['postId'],
    postImage: json['postImage'],
    caption: json['caption'],
    location: json['location'],
    createBy: json['createBy'],
    isArchived: json['isArchived'],
    isHidden: json['isHidden'],
    isDraft: json['isDraft'],
    time: json['timeDuration'],
    like: List<String>.from(json['like'].map((x) => x)),
    share: List<String>.from(json['share'].map((x) => x)),
    comment: List<Comment>.from(json['comment'].map((x) => Comment.fromJson(x))),
    save: List<String>.from(json['save'].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'postImage': postImage,
    'caption': caption,
    'location': location,
    'createBy': createBy,
    'isArchived': isArchived,
    'isHidden': isHidden,
    'isDraft':isDraft,
    'timeDuration':time,
    'like': List<dynamic>.from(like!.map((x) => x)),
    'share': List<dynamic>.from(share!.map((x) => x)),
    'comment': List<dynamic>.from(comment!.map((x) => x.toJson())),
    'save': List<dynamic>.from(save!.map((x) => x)),
  };
}

class Comment {
  String commentBy;
  String time;
  String comment;
  List<String> commentLike;

  Comment({
    required this.commentBy,
    required this.time,
    required this.comment,
    required this.commentLike,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    commentBy: json['commentBy'],
    time: json['time'],
    comment: json['comment'],
    commentLike: List<String>.from(json['commentLike'].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'commentBy': commentBy,
    'time': time,
    'comment': comment,
    'commentLike': List<dynamic>.from(commentLike.map((x) => x)),
  };
}
