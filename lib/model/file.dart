class FileModel {
  int fid;
  String hash;
  String name;
  int uid;
  String shareCode;
  String? username;

  FileModel(
      {required this.fid,
        required this.hash,
        required this.name,
        required this.uid,
        required this.shareCode,
        this.username});

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      fid: json['fid'],
      hash: json['hash'],
      name: json['name'],
      uid: json['uid'],
      shareCode: json['share_code'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fid'] = this.fid;
    data['hash'] = this.hash;
    data['name'] = this.name;
    data['uid'] = this.uid;
    data['share_code'] = this.shareCode;
    data['username'] = this.username;
    return data;
  }
}
