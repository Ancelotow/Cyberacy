import 'encodable_object.dart';

class Login extends EncodableObject {
  String nir;
  String password;

  Login(this.nir, this.password);

  @override
  Map<String, dynamic> toJson() {
    return {
      "nir": nir,
      "password": password,
    };
  }

}
