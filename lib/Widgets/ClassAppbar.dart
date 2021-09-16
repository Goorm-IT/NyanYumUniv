import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/screen/MyLogin.dart';
import 'package:flutter/material.dart';

class ClassAppbar extends StatefulWidget implements PreferredSizeWidget {
  ClassAppbar({Key? key})
      : preferredSize = Size.fromHeight(40),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _ClassAppbarState createState() => _ClassAppbarState();
}

class _ClassAppbarState extends State<ClassAppbar> {
  Widget bar = new Text("");
  List names = [];
  List filteredNames = [];
  List fname = [];
  String _searchText = "";
  Icon searchIcon = new Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    var ctrl = new LoginDataCtrl();
    var windowWidth = MediaQuery.of(context).size.width;
    return PreferredSize(
      preferredSize: Size.fromHeight(40),
      child: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: bar,
        leading: new IconButton(
          onPressed: () {
            ctrl.removeLoginData();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyLogin()));
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.grey,
        ),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              setState(() {
                if (this.searchIcon.icon == Icons.search) {
                  searchIcon = new Icon(Icons.close);
                  bar = Container(
                      width: windowWidth - 70,
                      height: 30,
                      child: Stack(
                        children: [
                          TextField(
                            autofocus: true,
                            onChanged: (text) {
                              _searchText = text;
                              print(_searchText);
                              if (!(_searchText == "")) {
                                List tmp = [];

                                for (int i = 0; i < fname.length; i++) {
                                  if (fname[i]
                                          .className
                                          .contains(_searchText) ||
                                      fname[i].profName.contains(_searchText)) {
                                    tmp.add(fname[i]);
                                  }
                                }
                                setState(() {
                                  filteredNames = tmp;
                                });
                              } else {
                                setState(() {
                                  filteredNames = fname;
                                });
                              }
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 1,
                              width: 300,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: <Color>[
                                  Color(0xff8C65EC),
                                  Color(0xff6D6CEB)
                                ]),
                              ),
                            ),
                          )
                        ],
                      ));
                } else {
                  setState(() {
                    bar = new Text("");
                    searchIcon = new Icon(Icons.search);
                    filteredNames = fname;
                  });
                }
              });
            },
            icon: searchIcon,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
