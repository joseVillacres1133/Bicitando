class UserInfoOdoo {

  String? name;
  String city;
  String? phone;
  String? email;
  String? identitier;
  String? image;
  String? imageUrl;
  String? typeUser;
  String? urlTr;

  String? traccarPwd;
  String? temporalPwd;
  bool verificateSMS;
  bool validateCI;


  UserInfoOdoo(this.name, 
              this.city, 
              this.phone, 
              this.email, 
              this.identitier, 
              this.image, 
              this.typeUser, 
              this.urlTr,
              this.traccarPwd, 
              this.temporalPwd, 
              this.verificateSMS,
              this.validateCI,
              this.imageUrl);

}