class OnlineModel {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? image;
  String? status;

  OnlineModel({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.image,
    this.status,
  });

  // Factory constructor to create a OnlineModel from JSON
  factory OnlineModel.fromJson(Map<String, dynamic> json) {
    return OnlineModel(
      id: json['id'],
      fName: json['f_name'],
      lName: json['l_name'],
      phone: json['phone'],
      email: json['email'],
      image: json['image'],
      status: json['status'],
    );
  }

  // Method to convert OnlineModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'f_name': fName,
      'l_name': lName,
      'phone': phone,
      'email': email,
      'image': image,
      'status': status,
    };
  }
}
