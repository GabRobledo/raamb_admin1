import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../adminusers.dart';
import '../databaseservice.dart';
import 'lib/verificationsrequest.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_application_1/lib/userdata.dart';
import 'package:flutter/material.dart';
import 'lib/UserList.dart';
import 'lib/Verificationslist.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DatabaseService()..connectAndListen(),
      child: MyApp(),
    ),
  );
}


class User {
  final String id;
  final String name;
  final String email;
  final String role;

  User(this.id, this.name, this.email, this.role);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['_id'],
      json['name'],
      json['email'],
      json['role'],
    );
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
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey, // Custom color for AppBar
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
        ),
      ),
      home: AdminDashboard(),
    );
  }
}


class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context, listen: false);
    databaseService.fetchVerificationRequests(); // Fetch verification requests
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      // drawer: AdminDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Welcome, Admin!', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 20),
            DashboardTiles(),
            SizedBox(height: 100),
            // UserList(),
            // VerificationRequestList(),
            // SizedBox(height: 20),
            // VerificationRequestList(),
          ],
        ),
      ),
    );
  }
}

// class UserList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DatabaseService>(
//       builder: (context, databaseService, child) {
//         if (databaseService.users.isEmpty) {
//           return Center(child: CircularProgressIndicator());
//         }
//          else {
//           return ListView.builder(
//             itemCount: databaseService.users.length,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               final user = databaseService.users[index];
//               return Card(
//                 child: ListTile(
//                   title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Text(user.email),
//                   leading: CircleAvatar(
//                     backgroundColor: Theme.of(context).primaryColor,
//                     child: Text(user.name[0], style: TextStyle(color: Colors.white)), 
//                   ),
//                   trailing: Icon(Icons.arrow_forward_ios),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }

// class VerificationRequestList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DatabaseService>(
//       builder: (context, databaseService, child) {
//         if (databaseService.verificationRequests.isEmpty) {
//           return Center(child: CircularProgressIndicator());
//         } else {
//           return ListView.separated(
//             separatorBuilder: (context, index) => Divider(height: 1),
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: databaseService.verificationRequests.length,
//             itemBuilder: (context, index) {
//               final request = databaseService.verificationRequests[index];
//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 8),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     // Use an icon or initials as per your data
//                     child: Icon(Icons.verified_user),
//                   ),
//                   title: Text(
//                     request.mobileNumber,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text('Additional details here'), // Display more information if available
//                   trailing: Icon(Icons.arrow_forward_ios),
//                   contentPadding: EdgeInsets.all(16), // Increased padding for larger size
//                   onTap: () {
//                     // Handle item tap if needed
//                   },
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }




class DashboardTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      shrinkWrap: true,
      children: <Widget>[
        DashboardTile(
          icon: Icons.people,
          title: 'User Lists',
          subtitle: 'User Accounts Registed to RAAMB',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagementPage()));
          },
        ),
        // DashboardTile(
        //   icon: Icons.pending_actions,
        //   title: 'Verification Requests',
        //   subtitle: 'Manage account verification requests',
        //   onTap: () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationRequestsPage()));
        //   },
        // ),
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
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            SizedBox(height: 15),
            Text(title, style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center),
          ],
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



