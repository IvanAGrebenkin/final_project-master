import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/strings.dart';
import '../Utils/widgets.dart';
import '../models/user.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<UserList> futureUserList;
  int _selectedIndex = -1;

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
    futureUserList = fetchUserList();
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
            child: FutureBuilder<UserList>(
                future: futureUserList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.items.length,
                      itemBuilder:(BuildContext context, int index) {
                        return Container(
                          height: 50,
                          color: (_selectedIndex == index ?
                          Theme.of(context).primaryColor
                              :(index % 2 == 1 ?
                          Theme.of(context).primaryColor.withOpacity(0.25):
                          Theme.of(context).primaryColor.withOpacity(0.05))),
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text(snapshot.data!.items[index].id.toString(), style: Theme.of(context).textTheme.bodyText2,)
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(snapshot.data!.items[index].name, style: Theme.of(context).textTheme.bodyText1,)
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Text(snapshot.data!.items[index].email, style: Theme.of(context).textTheme.caption, textAlign: TextAlign.right,)
                                ),
                              ],
                            ),
                            selected: index == _selectedIndex,
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                              Navigator.pushNamed(
                                  context,
                                  '/user_inf',
                                  arguments: snapshot.data!.items[index].id
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    );
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
