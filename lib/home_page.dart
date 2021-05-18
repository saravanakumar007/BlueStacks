import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/signup_page.dart';
import 'package:flutter_application/model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late List<dynamic> jsonData;

  late double screenWidth;
  late double screenHeight;

  late StateSetter stateChange;

  bool hasData = false;

  late User currentUser;

  late List<Items> totalItems;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchDataFromTournamentsAPI() async {
    final response = await http.get(
      Uri.parse(
          'https://60a2fdc07c6e8b0017e264d7.mockapi.io/api/v1/tournaments'),
    );
    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      totalItems =
          jsonData.map((dynamic data) => Items.fromJson(data)).toList();
      var s = 0;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchDataFromUsersAPI() async {
    final response = await http.get(
      Uri.parse('https://60a2fdc07c6e8b0017e264d7.mockapi.io/api/v1/users'),
    );
    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      final List<User> allUserList =
          jsonData.map((dynamic data) => User.fromJson(data)).toList();
      final Random random = Random();
      int min = 0, max = allUserList.length - 1;
      final int index = min + random.nextInt(max - min);
      currentUser = allUserList[index];
      stateChange(() {
        hasData = true;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchDataFromAPI() async {
    await fetchDataFromTournamentsAPI();
    await fetchDataFromUsersAPI();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
        drawer: getDrawer(),
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.short_text,
              color: Colors.black,
            ),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          backgroundColor: Color.fromRGBO(242, 242, 242, 1),
          title: Center(
              child: Text('Flyingwolf',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
        ),
        body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          stateChange = setState;
          if (hasData) {
            return getRenderWidget();
          } else {
            fetchDataFromAPI();
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 25,
                  ),
                  Text('Please wait... Loading Data')
                ]));
          }
        }));
  }

  Widget getDrawer() {
    return Drawer(
        child: Container(
            child: Column(children: [
      SizedBox(height: screenHeight * 0.1),
      Text('Dashboard', style: TextStyle(fontSize: 20, color: Colors.indigo)),
      SizedBox(height: screenHeight * 0.1),
      InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()));
          },
          child: Center(
              child: FlatButton(
            child: Column(
              children: [
                Icon(Icons.power_settings_new),
                Text('LogOut',
                    style: TextStyle(fontSize: 20, color: Colors.red)),
              ],
            ),
            onPressed: null,
          )))
    ])));
  }

  Widget getRenderWidget() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(width: 15),
            Ink(
              child: Image.network(
                currentUser.photo_url.toString(),
                scale: 0.75,
              ),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 15),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                currentUser.name.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(currentUser.rating.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.blue)),
                        Text('   Elo Rating  ',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 12))
                      ],
                    )),
              ),
            ])
          ]),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(colors: [
                      const Color.fromRGBO(242, 133, 10, 1),
                      const Color.fromRGBO(245, 161, 66, 1),
                    ], stops: [
                      0.0,
                      1.0
                    ]),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)),
                  ),
                  child: Column(children: [
                    Text(
                      currentUser.played.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tournaments',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      'Played',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ])),
              Container(width: 1.5),
              Container(
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(colors: [
                    const Color.fromRGBO(105, 17, 168, 1),
                    const Color.fromRGBO(169, 89, 227, 1),
                  ], stops: [
                    0.0,
                    1.0
                  ])),
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Column(children: [
                    Text(
                      currentUser.won.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tournaments',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      'Won',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ])),
              Container(width: 1.5),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(colors: [
                      const Color.fromRGBO(227, 69, 25, 1),
                      const Color.fromRGBO(242, 117, 82, 1),
                    ], stops: [
                      0.0,
                      1.0
                    ]),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                  ),
                  child: Column(children: [
                    Text(
                      currentUser.percentage.toString() + '%',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Winning',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      'Percentage',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ]))
            ],
          ),
          SizedBox(height: 20),
          Row(children: [
            Text('Recommended For you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))
          ]),
          SizedBox(height: 20),
          Expanded(flex: 2, child: Container(child: getRecommendedWidgets()))
        ]));
  }

  Widget getRecommendedWidgets() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int build) => const SizedBox(
              height: 15,
            ),
        cacheExtent: (totalItems.length).toDouble(),
        itemCount: totalItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 280,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/images/image' + index.toString() + '.jpg',
                  ),
                ),
                Text(
                  '  ' + totalItems[index].name.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('   ' + totalItems[index].game_name.toString()),
              ],
            ),
          );
        });
  }
}
