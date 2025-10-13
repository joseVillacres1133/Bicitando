import 'package:flutter/cupertino.dart';

class GeneralSizeCicleAvatar{
  double radius;
  double textSize;
  double widthImage;
  double heightImage;
  GeneralSizeCicleAvatar(this.radius, this.textSize, this.widthImage, this.heightImage);
}


class NetworkImageString {
  NetworkImage networkImage;
  String name;
  String urlImage;
  
  NetworkImageString(this.networkImage, this.name, this.urlImage);
}