enum Status { todo, progessing, done }

class Item {
  String title;
  String desc;
  Status status;
  String createdDate;

  Item({required this.title, required this.desc, required this.status, required this.createdDate});
}
