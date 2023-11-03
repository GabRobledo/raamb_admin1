import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class User {
  final String id;
  final String name;
  final String email;

  User(this.id, this.name, this.email);
}

class VerificationRequest {
  final String id;
  final String userName;
  final String userEmail;

  VerificationRequest(this.id, this.userName, this.userEmail);
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
  final List<User> users = [
    User('1', 'User 1', 'user1@example.com'),
    User('2', 'User 2', 'user2@example.com'),
    User('3', 'User 3', 'user3@example.com'),
    // Add more user data here
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Registered Users',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
              leading: Icon(Icons.person),
            );
          },
        ),
      ],
    );
  }
}

class VerificationRequestList extends StatelessWidget {
  final List<VerificationRequest> verificationRequests = [
    VerificationRequest('1', 'User 4', 'user4@example.com'),
    VerificationRequest('2', 'User 5', 'user5@example.com'),
    VerificationRequest('3', 'User 6', 'user6@example.com'),
    // Add more verification requests here
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Verification Requests',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: verificationRequests.length,
          itemBuilder: (context, index) {
            final request = verificationRequests[index];
            return ListTile(
              title: Text(request.userName),
              subtitle: Text(request.userEmail),
              leading: Icon(Icons.pending),
            );
          },
        ),
      ],
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
        DashboardTile(
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'Manage app settings',
          onTap: () {}, // Navigate to the settings page
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

