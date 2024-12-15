
//in app user
class User {
  String id = '';
  String name = '';

  User({required this.id, required this.name});

  bool get isEmpty => id.isEmpty;
  User.empty();
}
