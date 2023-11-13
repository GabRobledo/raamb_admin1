import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/databaseservice.dart';

class VerificationRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Requests'),
      ),
      body: Consumer<DatabaseService>(
        builder: (context, databaseService, child) {
          if (databaseService.verificationRequests.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 1),
              itemCount: databaseService.verificationRequests.length,
              itemBuilder: (context, index) {
                final request = databaseService.verificationRequests[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.verified_user),
                    ),
                    title: Text(
                      request.mobileNumber,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Additional details here'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    contentPadding: EdgeInsets.all(16),
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
