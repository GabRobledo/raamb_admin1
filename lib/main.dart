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
      create: (context) => DatabaseService(),
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(color: Colors.blueGrey),
        cardTheme: CardTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 4),
      ),
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);
    databaseService.fetchVerificationRequests();
    databaseService.fetchUsers();  // Trigger fetching verification requests

    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Welcome, Admin!', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 20),
            DashboardTiles(),
            SizedBox(height: 100),
            // UserList(), // Uncomment when ready
            // VerificationRequestList(), // Uncomment when ready
          ],
        ),
      ),
      drawer: AdminDrawer(), // Drawer for additional navigation
    );
  }
}

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



