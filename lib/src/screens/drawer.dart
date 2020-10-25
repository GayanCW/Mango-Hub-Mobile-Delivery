import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangoHub/src/screens/EditUser.dart';


class DrawerClass extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(top: 30.0),
              color: Colors.orange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/profile.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 100.0,
                    height: 50.0,
                    margin: EdgeInsets.only(left:10.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Dinesh Madushan",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => ProfileScreen()));
            },
          ),
          ListTiles(),
//          NewListTiles(),
        ],
      ),
    );
  }
}

class ListTiles extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text("About me"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.contact_phone),
            title: Text("Contacts"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text("Photos"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Favorite"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.my_location),
            title: Text("My location"),
            onTap: (){
            },
          ),
          ListTile(
            leading: Icon(Icons.fingerprint),
            title: Text("fingerprint"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: (){
              // Navigator.pushNamed(context, '/editUser');
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditUser()));
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help"),
            onTap: (){},
          ),
        ],
      ),
    );
  }
}


class ListItems extends StatelessWidget{
  final String name;
  ListItems(this.name);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(name),
      onTap: (){},
    );
  }
}

