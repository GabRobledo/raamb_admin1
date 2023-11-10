import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../adminusers.dart';
import '../databaseservice.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserData()),
        ChangeNotifierProvider(create: (context) => VerificationRequestData()),
      ],
      child: MyApp(),
    ),
  );
}

// Assuming User and VerificationRequest have a named constructor for JSON parsing
class User {
  final String id;
  final String name;
  final String email;
  final String role; // Added role field

  User(this.id, this.name, this.email, this.role);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['_id'],
      json['name'],
      json['email'],
      json['role'], // Assuming 'role' field exists in your JSON
    );
  }
}

class VerificationRequest {
  final String id;
  final String userName;
  final String userEmail;

  VerificationRequest(this.id, this.userName, this.userEmail);

  factory VerificationRequest.fromJson(Map<String, dynamic> json) {
    return VerificationRequest(
      json['_id'],
      json['userName'],
      json['userEmail'],
    );
  }
}

class UserData with ChangeNotifier {
  IO.Socket? socket;
  List<User> _users = [];
  List<User> get users => _users;

  UserData() {
    _initSocket();
  }

  void _initSocket() {
    if (socket == null) {
      socket = IO.io('http://192.168.1.7:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket?.connect();

      socket?.on('users', (data) {
        _users = (data as List).map((u) => User.fromJson(u)).toList();
        notifyListeners();
      });

      socket?.on('error', (data) => print('Socket Error: $data'));
      socket?.on('disconnect', (_) => print('Disconnected'));
    }
  }
  Future<void> fetchUsers() async {
    socket?.emit('request-users');
  }
  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
  }
}




// VerificationRequestData Provider
class VerificationRequestData with ChangeNotifier {
  List<VerificationRequest> _verificationRequests = [];
  List<VerificationRequest> get verificationRequests => _verificationRequests;

  Future<void> fetchVerificationRequests() async {
    final response = await http.get(Uri.parse('http://your-api-url/verification-requests'));

    if (response.statusCode == 200) {
      List<dynamic> verificationRequestsJson = json.decode(response.body);
      _verificationRequests = verificationRequestsJson.map((json) => VerificationRequest.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load verification requests');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      drawer: AdminDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Welcome, Admin!', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 20),
            DashboardTiles(),
            SizedBox(height: 20),
            UserList(),
            SizedBox(height: 20),
            VerificationRequestList(),
          ],
        ),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(
      builder: (context, userData, child) {
        if (userData.users.isEmpty) {
          // If the list is empty, it may be loading, so show a progress indicator
          return Center(child: CircularProgressIndicator());
        } else {
          // If the list has data, build a ListView with the data
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // Disable ListView's scrolling since it's inside a SingleChildScrollView
            itemCount: userData.users.length,
            itemBuilder: (context, index) {
              final user = userData.users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                leading: Icon(Icons.person),
              );
            },
          );
        }
      },
    );
  }
}



class VerificationRequestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using a Consumer widget to listen to VerificationRequestData changes
    return Consumer<VerificationRequestData>(
      builder: (context, verificationRequestData, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Verification Requests', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            verificationRequestData.verificationRequests.isEmpty
                ? CircularProgressIndicator() // Show a loading indicator while fetching data
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // to disable ListView's scrolling
                    itemCount: verificationRequestData.verificationRequests.length,
                    itemBuilder: (context, index) {
                      final request = verificationRequestData.verificationRequests[index];
                      return ListTile(
                        title: Text(request.userName),
                        subtitle: Text(request.userEmail),
                        leading: Icon(Icons.verified_user),
                      );
                    },
                  ),
          ],
        );
      },
    );
  }
}


class DashboardTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: <Widget>[
        DashboardTile(
          icon: Icons.insert_chart,
          title: 'Analytics',
          subtitle: 'View statistics and reports',
          onTap: () {}, // Navigate to the analytics page
        ),
        ElevatedButton(
  onPressed: () {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminUsersPage()));
  },
  child: Text('View Registered Users'),
),


        DashboardTile(
          icon: Icons.people,
          title: 'User Management',
          subtitle: 'Manage user accounts and permissions',
          onTap: () {}, // Navigate to the user management page
        ),
        DashboardTile(
          icon: Icons.pending_actions,
          title: 'Verification Requests',
          subtitle: 'Manage account verification requests',
          onTap: () {}, // Navigate to the verification requests page
        ),
      ],
    );
  }
}

class DashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  DashboardTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 40),
              SizedBox(height: 10),
              Text(title, style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 5),
              Text(subtitle),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Admin User'),
            accountEmail: Text('admin@example.com'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          // ... Drawer ListTiles
        ],
      ),
    );
  }
}

// UserList and VerificationRequestList Widgets remain largely unchanged but with added interactivity and responsiveness.

