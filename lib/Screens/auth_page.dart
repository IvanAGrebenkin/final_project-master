import '../Utils/design.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/strings.dart';
import '../Utils/widgets.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);
  @override

  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  String? _userStoredName;
  String? _userStoredPass;

  bool _checkAuthorization() {
    if ((_userStoredName == Strings.userName)&&(_userStoredPass == Strings.userPass)) {
      return true;
    }
    return false;
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userStoredName = (prefs.getString('userStoredName') ?? '');
      _userStoredPass = (prefs.getString('userStoredPass') ?? '');
    });
  }

  void _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userStoredName', (_userStoredName ?? ''));
    prefs.setString('userStoredPass', (_userStoredPass ?? ''));
  }


  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  // void _performLogin() {
  //   Navigator.pushNamed(context, '/main_screen');
  // }


  @override
  Widget build(BuildContext context) {
    if (_checkAuthorization()) {
      return Scaffold(
        appBar: appBar(context),
        drawer: navDrawer(context),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40,),
                Icon(Icons.verified_user, size: 50, color: Theme.of(context).primaryColor,),
                const SizedBox(height: 50),
                Text(
                  Strings.authSuccess,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: const [
                    Expanded(child: SizedBox(height: 20)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: (){
                        _userStoredName ='';
                        _userStoredPass ='';
                        _saveUserData();
                        setState(() {});
                      },
                      child: const Text(Strings.buttonExit)
                  ),
                )
              ],
            ),
          ),
        ),

      );
      // _performLogin();
    } else {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  Icon(Icons.verified_user, size: 50, color: Theme.of(context).primaryColor,),
                  const SizedBox(height: 50),
                  Text(
                    Strings.authEnterLogin,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: userController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                                              hintText: '+7 ...',
                                              enabledBorder: inputFileBorderStyle,
                                              focusedBorder: inputFileBorderStyle,
                                              filled: true,
                                              fillColor: Color(0xffECEFF1),
                                              labelText: 'Телефон',),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return Strings.validName;
                            } else if (value.length !=10){
                              return Strings.validNameLength;
                            }
                            return null;
                          },
                        ),
                      ),
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: passController,
                          obscureText: true,
                          decoration: const InputDecoration(
                                              hintText: 'максимум 6 символов',
                                              enabledBorder: inputFileBorderStyle,
                                              focusedBorder: inputFileBorderStyle,
                                              filled: true,
                                              fillColor: Color(0xffECEFF1),
                                              labelText: 'Пароль',
                                            ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return Strings.validPass;
                            }
                            return null;
                          },
                        ),
                      ),
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            _userStoredName = userController.text;
                            _userStoredPass = passController.text;
                            if (_checkAuthorization()) {
                              _saveUserData();
                            } else {
                              _userStoredName = '';
                              _userStoredPass = '';
                              _saveUserData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(Strings.authFailed), duration: Duration(seconds: 2)),
                              );
                            }
                          }
                          setState(() {});
                        },
                        child: const Text(Strings.buttonEnter)
                    ),
                  ),
                  const SizedBox(height: 50,),
                  const Text('Демо-доступ:'),
                  Text('Тел: ${Strings.userName}'),
                  Text('Пароль: ${Strings.userPass}'),
                ],
              ),
            ),
          ),
        ),
      );
      // return Scaffold(
      //   body: SingleChildScrollView(
      //     child: Form(
      //       key: _formKey,
      //       child: MaterialApp(
      //         scaffoldMessengerKey: _messengerKey,
      //         home: Container (
      //           child: Column(children: [
      //               const SizedBox(width:103, height:81,),
      //               const SizedBox(width:103, height:79.42,
      //                 child: Image(
      //                   image: AssetImage('assets/dart-logo 1.png'),
      //                 ),
      //               ),// Значок Flutter
      //               const SizedBox(width:103, height:18.58,),
      //               const Text('Введите логин в виде номера телефона в формате ',
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(
      //                   fontSize:16,
      //                   color: Color.fromRGBO(0, 0, 0, 0.6),
      //                 ),
      //               ),// Текст: 'Введите логин в виде номера телефона в формате '
      //               const Text('+7 901 234 56 78',
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(
      //                   fontSize:16,
      //                   color: Color.fromRGBO(0, 0, 0, 0.6),
      //                 ),
      //               ),// Текст: '+7 901 234 56 78'
      //               const SizedBox(width:103, height:20,),
      //               TextFormField(
      //                 validator: (value) {
      //                   if (value == null || value.isEmpty) {
      //                     return 'Пожалуйста введите номер телефона';
      //                   }
      //                   return null;
      //                 },
      //                 controller: userController,
      //                 maxLength: 1,
      //                 keyboardType: TextInputType.phone,
      //                 decoration: const InputDecoration(
      //                   hintText: '+7 ...',
      //                   enabledBorder: inputFileBorderStyle,
      //                   focusedBorder: inputFileBorderStyle,
      //                   filled: true,
      //                   fillColor: Color(0xffECEFF1),
      //                   labelText: 'Телефон',),
      //               ),// Поле ввода номера телефона
      //               const SizedBox(width:103, height:20,),
      //               TextFormField(
      //                 validator: (value) {
      //                   if (value == null || value.isEmpty) {
      //                     return 'Пожалуйста введите пароль';
      //                   }
      //                   return null;
      //                 },
      //                 controller: passController,
      //                 maxLength: 1,
      //                 obscureText: true,
      //                 decoration: const InputDecoration(
      //                   hintText: 'максимум 6 символов',
      //                   enabledBorder: inputFileBorderStyle,
      //                   focusedBorder: inputFileBorderStyle,
      //                   filled: true,
      //                   fillColor: Color(0xffECEFF1),
      //                   labelText: 'Пароль',
      //                 ),
      //               ),// Поле ввода пароля
      //               const SizedBox(width:103, height:28,),
      //               SizedBox(width:154, height:42,
      //                 child: ElevatedButton(
      //                   onPressed: (){
      //                     if (_formKey.currentState!.validate()) {
      //                       _userStoredName = userController.text;
      //                       _userStoredPass = passController.text;
      //                       if (_checkAuthorization()) {
      //                         _saveUserData();
      //                       } else {
      //                         _userStoredName = '';
      //                         _userStoredPass = '';
      //                         _saveUserData();
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           const SnackBar(content: Text(Strings.authFailed), duration: Duration(seconds: 2)),
      //                         );
      //                       }
      //                     }
      //                     setState(() {});
      //                   },
      //                   child: const Text('Войти'),
      //                   style: ElevatedButton.styleFrom(
      //                     primary: const Color(0xff0079D0),
      //                     shape: RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.circular(36.0)),
      //                   ),
      //
      //                 ),
      //               ),// Кнопка 'Войти'
      //               const SizedBox(width:103, height:68,),
      //               InkWell(
      //                 child: const Text(
      //                   'Регистрация',
      //                   style: linkTextStyle,
      //                 ),
      //                 onTap: () {},
      //               ),// Ссылка 'Регистрация'
      //               const SizedBox(width:103, height:19,),
      //               InkWell(
      //                 child: const Text(
      //                   'Забыли пароль?',
      //                   style: linkTextStyle,
      //                 ),
      //                 onTap: () {
      //                   _messengerKey.currentState!.showSnackBar(
      //                       SnackBar(
      //                         content: Row(
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           children: const [
      //                             Text('Телефон: 1',
      //                               textAlign: TextAlign.left,),
      //                             SizedBox(width:40, height:40,),
      //                             Text('Пароль: q',
      //                               textAlign: TextAlign.right,),
      //                           ],
      //                         ),));
      //                 },
      //               ),// Ссылка 'Забыли пароль?'
      //             ],
      //           ),
      //
      //           decoration: const BoxDecoration(
      //             image: DecorationImage(
      //               image: AssetImage('assets/wallpaper1.jpg'),
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //           padding: const EdgeInsets.symmetric(horizontal: 50),
      //           width: double.infinity,
      //           height: double.infinity,
      //         ),
      //       ),
      //     ),
      //   ),
      // );
    }
  }
}
