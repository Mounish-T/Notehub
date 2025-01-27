import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/features/about.dart';
import 'package:notes/features/crud.dart';
import 'package:notes/features/image_process.dart';
import 'package:notes/features/toast.dart';
import 'package:notes/screens/edit_note_screen.dart';

import '../features/auth/auth_pages/change_password.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> data = [];
  final DataService db = DataService();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Fetch data from database
    List<Map<String, dynamic>> fetchedData = await db.readData();
    setState(() {
      data = fetchedData;
    });
  }

  Future<void> _changePassword() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
    );
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _deleteAccount() async {
    try {
      await db.deleteAccount();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showCustomToast(context, "Please re-authenticate and try again", "");
      } else {
        showCustomToast(context, "Error: ${e.message}", "");
      }
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteAccountConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to delete your account? This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 117, 182, 214),
        centerTitle: true,
        title: Row(
          children: [
            Text(
              'Notehub',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 191, 2, 2),
              ),
            ),
          ],
        ),
      ),
      body: data.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Nothing to be displayed",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addNote');
                    },
                    child: Text(
                      "Add Note",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      if (index <= 0) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/addNote');
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                (index % 4 == 0 ? 10 : 4),
                                6,
                                ((index + 1) % 4 == 0 ? 10 : 5),
                                6),
                            color: Colors.grey,
                            child: Icon(Icons.add_rounded),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditNoteScreen(
                                          data: data[index - 1],
                                        )));
                          },
                          onLongPress: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 115,
                                    padding: EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Delete this Note ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: data[index - 1]['title'],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: const Color.fromARGB(
                                                      255, 24, 136, 41),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                // Add your delete note logic here
                                                // if (data[index - 1]['url'] !=
                                                //     null) {
                                                //   deleteImage(
                                                //       data[index - 1]['url']);
                                                // }
                                                final DataService db =
                                                    DataService();
                                                String delete_data =
                                                    data[index - 1]['title'];
                                                db.deleteData(
                                                    data[index - 1]['id']);
                                                setState(() {
                                                  showCustomToast(
                                                      context,
                                                      "Successfully deleted ",
                                                      delete_data);
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          '/home',
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  // backgroundColor: Colors.red,
                                                  ),
                                              child: Text("Delete"),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                              (index % 4 == 0 ? 10 : 4),
                              6,
                              ((index + 1) % 4 == 0 ? 10 : 5),
                              6,
                            ),
                            color: const Color.fromARGB(255, 33, 243, 180),
                            child:
                                Center(child: Text(data[index - 1]['title'])),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(user?.displayName ?? 'N/A'),
                  accountEmail: Text(user?.email ?? 'N/A'),
                  currentAccountPicture: CircleAvatar(
                    child: Icon(Icons.person, size: 50),
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 117, 182, 214),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('About'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Change Password'),
                  onTap: _changePassword,
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete Account'),
                  onTap: _showDeleteAccountConfirmationDialog,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _showLogoutConfirmationDialog,
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 249, 39, 39),
                  backgroundColor: const Color.fromARGB(255, 54, 197, 244),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
