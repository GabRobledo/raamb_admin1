import 'package:flutter/material.dart';
import 'databaseservice.dart';
import 'lib/userdata.dart';
import 'package:provider/provider.dart';



class AdminUsersPage extends StatefulWidget {
  @override
  _AdminUsersPageState createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    dbService.connectAndListen(); // Connect to Socket.IO server
  }

  @override
  void dispose() {
    dbService.dispose(); // Disconnect the socket
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DatabaseService()..connectAndListen(),
      child: Scaffold(
        appBar: AppBar(title: Text('Admin - Registered Users')),
        body: Consumer<DatabaseService>(
          builder: (context, dbService, child) {
            final users = dbService.users;
            if (users.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Text(user.role),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
