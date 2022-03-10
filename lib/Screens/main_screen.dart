import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/design.dart';
import '../Utils/strings.dart';
import '../Utils/widgets.dart';
import '../Utils/constants.dart';
import '../models/user.dart';

class TaskMainScreen extends StatelessWidget {
  const TaskMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int userID = ModalRoute.of(context)!.settings.arguments as int;

    return MainScreen(userID: userID);
  }
}


class MainScreen extends StatefulWidget {
  final int userID;
  const MainScreen({Key? key, required this.userID}) : super(key: key);


  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late Future<User> _futureUser;
  late Future<TaskList> _futureTaskList;
  // late List<User> usersListData;

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _futureUser = fetchSingleUser(widget.userID);
    _futureTaskList = fetchTaskList(widget.userID);
    // futureUsersList = _fetchUsersList();
    // FutureBuilder<Users>(
    //   future: futureUsers,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return Text('${snapshot.data!.id}');
    //     } else if (snapshot.hasError) {
    //       return Text('${snapshot.error}');
    //     }
    //     return const CircularProgressIndicator();
    //   },
    // );
  }



  @override
  Widget build(BuildContext context) {
    if (_checkAuthorization()) {
      return Scaffold(
        appBar:  appBar(context),
        drawer: navDrawer(context),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: FutureBuilder<User>(
                future: _futureUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.userWidget(context);
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                }
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40,),
                Icon(Icons.verified_user, size: 50, color: Theme.of(context).primaryColor,),
                const SizedBox(height: 50),
                Text(
                  Strings.authFailed,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    // return MaterialApp(
    //   scaffoldMessengerKey: _messengerKey,
    //   home: Scaffold(
    //     appBar: appBar(context),
    //     drawer: navDrawer(context),
    //     body:FutureBuilder<List<User>>(
    //       future: futureUsersList,
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           usersListData = snapshot.data!;
    //           return _usersListView(usersListData);
    //         } else if (snapshot.hasError) {
    //           return Text('${snapshot.error}');
    //         }
    //         return const CircularProgressIndicator();
    //       },
    //     ),
    //   ),
    //   //   FutureBuilder<Users>(
    //   //     future: futureUsers,
    //   //     builder: (context, snapshot) {
    //   //       if (snapshot.hasData) {
    //   //         return Text('${snapshot.data!.id}');
    //   //       } else if (snapshot.hasError) {
    //   //         return Text('${snapshot.error}');
    //   //       }
    //   //       return const CircularProgressIndicator();
    //   //     },
    //   // ),
    // );
  }
}

Future<List<User>> _fetchUsersList() async {
  final response = await http.get(Uri.parse(Url));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((user) => User.fromJson(user)).toList();

  } else {

    throw Exception('Failed to load users from API');
  }
}