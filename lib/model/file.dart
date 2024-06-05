class FileModel {
  int fid;
  String hash;
  String name;
  int uid;
  String shareCode;
  String? username;

  FileModel(this.fid, this.hash, this.name, this.uid, this.shareCode,{this.username});
}