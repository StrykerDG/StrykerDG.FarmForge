class User {
  int userId;
  String username;

  User({
    this.userId,
    this.username
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      userId: data['UserId'],
      username: data['Username']
    );
  }
}