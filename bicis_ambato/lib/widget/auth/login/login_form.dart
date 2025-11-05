// Widget + opciones
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:carousel_slider/carousel_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:geolocator/geolocator.dart';

import '../../../blocs/auth/login/bloc.dart';
import '../../../data/auth_provider.dart';
import '../../../data/models/general/GeneralModels.dart';
import '../../../data/repository.dart';
import '../../../style/style.dart';
import '../../../utils/constants_msg.dart' as AST;
import '../../../utils/constants_msg.dart';
import '../../../utils/sharedprefs_helper.dart';
import '../reset_password.dart';
import 'login_button.dart';

class LoginForm extends StatefulWidget {
  final Repository _repository;

  LoginForm({super.key, @required Repository? repository})
      : assert(repository != null),
        _repository = repository!;

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static bool activeImg = false;
  static List<NetworkImageString> imgNetwork = [];

  late LoginBloc _loginBloc;
  final _prefs = Prefs();
  late String tokenFirebase;
  var termsConditions = "";
  var usePolicies = "";
  late bool passwordVisible;

  Repository get _repository => widget._repository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && state.isSubmitting;
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    if (position != null) {
      _prefs.latitud = position.latitude.toString();
      _prefs.longitud = position.longitude.toString();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks != null) {
        _prefs.cityOrigen = placemarks.first.locality!;
      }
    }
  }

  // Future<void> _getCurrentLocation() async {
  //   //final Geolocator geolocator = Geolocator();
  //   try {
  //     final position = await Geolocator.getCurrentPosition(
  //             desiredAccuracy: LocationAccuracy.best)
  //         .timeout(const Duration(seconds: 5));

  //     if (position != null) {
  //       Coordinates coordinates =
  //           Coordinates(position.latitude, position.longitude);

  //       var address =
  //           await Geocoder.local.findAddressesFromCoordinates(coordinates);

  //       setState(() {
  //         _prefs.latitud = position.latitude.toString();
  //         _prefs.longitud = position.longitude.toString();
  //         _prefs.cityOrigen = address.first.locality!;
  //       });
  //     } else {
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     //setState(() {
  //     //_prefs.latitud = "0.0";
  //     // _prefs.longitud = "0.0";
  //     //});
  //   }
  // }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    imgNetwork = [];

    Prefs().getLoginCredentials().then((creds) {
      _emailController.text = creds['email']!;
      _passwordController.text = creds['password']!;
    });

    _loginBloc = BlocProvider.of<LoginBloc>(context);
    // _emailController.text = 'admin';
    // _passwordController.text = 'admin';
    _emailController.addListener(_onEmailChanged);
    _emailController.addListener(() {
      _loginBloc.add(EmailChanged(email: _emailController.text.trim()));
    });
    _passwordController.addListener(_onPasswordChanged);
  }

  Future<bool> _requestPop() {
    // return new Future.value(false); // bloquear el boton de regreso
    SystemNavigator.pop();
    return Future.value(true);
  }

  final ValueNotifier<bool> _busy = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Size size = MediaQuery.of(context).size;
    print('generando form');
    // ─── dentro de build() (después de calcular size) ───
    return PopScope(
      //onWillPop: _requestPop,
      child: BlocListener(
        bloc: _loginBloc,
        listener: (BuildContext context, LoginState state) async {
          if (state.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.mensaje,
                        style: poppinsBold(12, whiteColor),
                      ),
                      const Icon(Icons.error)
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            print('antes');
            _busy.value = false;
            print('despues');
          }
          if (state.isOffline) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AST.str_without_connect,
                        style: poppinsBold(12, whiteColor),
                      ),
                      const Icon(Icons.signal_wifi_off),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            _busy.value = false;
          }
          if (state.isChangeSuccess) {
            //         FlutterWindowManager.clearFlags(
            // FlutterWindowManager.FLAG_NOT_TOUCHABLE);
            Navigator.pushReplacementNamed(context, 'resetPass');
          }
          if (state.isSubmitting) {
            // FlutterWindowManager.addFlags(
            // FlutterWindowManager.FLAG_NOT_TOUCHABLE);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: purplelight,
                  content: GestureDetector(
                    onTap: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AST.str_starting_session,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: yellow,
                        ),
                      ],
                    ),
                  ),
                  duration: const Duration(seconds: 5),
                ),
              );
          }
          if (state.isSuccess) {
            //******************************************
            await Prefs().saveLoginCredentials(
                _emailController.text, _passwordController.text);
            await saveToken();
            getLocation();
            _busy.value = false;
            await Navigator.pushReplacementNamed(context, 'home');
          }
        },
        child: BlocBuilder(
            bloc: _loginBloc,
            builder: (BuildContext context, LoginState state) {
              return Stack(
                children: <Widget>[
                  _prefs.requireOffline
                      ? const Stack(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                AST.str_connect,
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 36.0),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.redAccent,
                              ),
                            ),
                          ],
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 0.0),
                        ),
                  Align(
                    alignment: const AlignmentDirectional(0.0, -0.95),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: MediaQuery.of(context).size.height * 0.40,
                      width: MediaQuery.of(context).size.width * 0.60,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: AssetImage(AST
                                .img_logo) // ExactAssetImage(AST.img_logo_blanco),
                            ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0.0, 0.8),
                    child: Container(
                      width: size.height,
                      height: MediaQuery.of(context).size.height * 0.60,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        // color: whiteColor,
                      ),
                      child: SingleChildScrollView(
                      child: Column(children: [
                        const Text(
                          str_start_session,
                          style: TextStyle(
                              color: secondary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        formUI(state, size),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: size.width * 0.2,
                            width: size.height,
                            decoration: const BoxDecoration(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  str_first_time,
                                  style: TextStyle(color: secondary),
                                ),
                                TextButton(
                                    onPressed: () => {
                                          Navigator.pushReplacementNamed(
                                              context, 'register')
                                        },
                                    child: const Text(str_create_account,
                                        style: TextStyle(
                                            fontSize: 12, color: secondary)))
                              ],
                            )),
                      ]),
                      // ),
                    ),
                  ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  saveToken() async {
    /*_authProviderAlways ??= AuthProvider(odooClient: OdooClient(LOCAL_BASE_URL));
    _prefs.trokenfmc = tokenFirebase;
    bool result = await _authProviderAlways.tokenUserCreateUpdateApi(
        _prefs.imei, _prefs.idUserPartner, tokenFirebase);
    if (result) {
    } */
  }

  void showWarningMessage(
      BuildContext context, String titulo, String subtitulo) {
    final dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Center(
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.lock,
              color: secondary,
            ),
            Text(
              titulo,
              style: poppinsBold(
                  ScreenUtil().setSp(
                    4.5,
                  ),
                  secondary),
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Text(
          subtitulo,
          textAlign: TextAlign.justify,
        ),
      ),
    );
    showDialog(
        context: context, barrierDismissible: true, builder: (x) => dialog);
  }

  Widget formUI(LoginState state, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: size.height * 0.04,
              left: size.width * 0.03,
              right: size.width * 0.03),
          child: Card(
            color: whiteColor,
            elevation: 5,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * .03,
              right: MediaQuery.of(context).size.height * .03,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Image.asset(
                      AST.img_correo,
                      color: secondary,
                      scale: 27,
                    ),
                    labelText: AST.str_email,
                    errorStyle: poppinsNormal(10.0, secondary),
                  ),
                  autovalidateMode: AutovalidateMode.always,
                  autocorrect: false,
                  validator: (_) {
                    return !state.isEmailValid
                        ? AST.str_valid_mail_invalid
                        : null;
                  },
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                  height: 1,
                  color: secondary,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Image.asset(
                      AST.img_contrasenia,
                      color: secondary,
                      scale: 27,
                    ),
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: secondary,
                        size: size.width * 0.055,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: passwordVisible,
                  autovalidateMode: AutovalidateMode.always,
                  autocorrect: false,
                  validator: (_) {
                    return !state.isPasswordValid
                        ? AST.str_valid_pwd_invalid
                        : null;
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1 / 2.5,
        ),

        // Row(children: [
        //child:
        LoginButton(
          email: _emailController.text.trim(),
          pswd: _passwordController.text.trim(),
          onPressed: isLoginButtonEnabled(state) //(state)
              ? _onFormSubmitted
              : () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AST.str_admit_data_empty,
                              style: poppinsBold(12, whiteColor),
                            ),
                            const Icon(Icons.error),
                          ],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                },
        ),
        const SizedBox(
          height: 25,
        ),
        // ]),
        SizedBox(
          height: size.width * 0.15,
          width: size.height * 2,
          child: Center(
            child: ResetPasswordButton(
              email: _emailController.text,
            ),
          ),
        ),

        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.1 / 3.5,
        // ),

        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.1 / 3.5,
        // ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text.trim()),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text.trim()),
    );
  }

  Future _onFormSubmitted() async {
    _prefs.requireGPS = false;

    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  //////////////////manual
  static List<String> imgList = [];
  var _counter = 0;
  var _counterList = 0;

  customDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext c) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.transparent,
                ),
                child: SizedBox(child: buttonDemo(context))),
          );
        });
  }

  final cs.CarouselSliderController controllerCarousel =
      cs.CarouselSliderController();

  Widget buttonDemo(BuildContext context) {
    _counter = 0;

    final basicSlider = cs.CarouselSlider(
      items: itemListChild,
      carouselController: controllerCarousel, //
      options: cs.CarouselOptions(
        disableCenter: true,
        autoPlay: false,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 0,
        reverse: false,
        scrollDirection: Axis.horizontal,
        scrollPhysics: const NeverScrollableScrollPhysics(),
      ),
    );

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      basicSlider,
      _counterList <= 1
          ? const SizedBox()
          : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo),
                ),
                onPressed: () {
                  //print('***********>> numeros');
                  _incrementCounter();
                  _counter < _counterList
                      ? controllerCarousel.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear)
                      : Navigator.of(context).pop(true);
                },
                child: const Text(
                  AST.str_next,
                  // style: TextStyle(
                  //     fontSize: ScreenUtil().setSp(8), color: Colors.white),
                ),
              ),
            ]),
    ]);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  static List<T> mapFunction<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  List<Widget>? itemListChild;
  listItemShow() {
    _counterList = 0;
    if (!activeImg && imgNetwork.isEmpty) {
      _counterList = imgList.length;
    } else {
      _counterList = imgNetwork.length;
    }

    itemListChild = mapFunction<Widget>(
      (!activeImg && imgNetwork.isEmpty) ? imgList : imgNetwork,
      (index, i) {
        return Container(
          margin: const EdgeInsets.all(3.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(2.0)),
            child: Stack(children: <Widget>[
              (!activeImg && imgNetwork.isEmpty)
                  ? Image.asset(i,
                      fit: BoxFit.fill, width: 1000, height: 1000000.0)
                  : Image.network(
                      i.urlImage,
                      fit: BoxFit.fill,
                      width: 1000,
                      height: 1000000.0,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                              const SizedBox(height: 25),
                              const Text(
                                AST.str_loading,
                                // style: poppinsBold(
                                //     ScreenUtil().setSp(4).toDouble(),
                                //     blackColor),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

              ///Image.network(i, fit: BoxFit.cover, width: 1000.0),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: (!activeImg && imgNetwork.isEmpty)
                      ? const SizedBox()
                      : Text(
                          i.name.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ]),
          ),
        );
      },
    ).toList();
    setState(() {});
  }
}
