import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/lib/userdata.dart';
import '../databaseservice.dart';
class UserManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Consumer<DatabaseService>(
        builder: (context, databaseService, child) {
          if (databaseService.users.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: databaseService.users.length,
              itemBuilder: (context, index) {
                final user = databaseService.users[index];
                return Card(
                  child: ListTile(
                    title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(user.email),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(user.name[0], style: TextStyle(color: Colors.white)),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
