import 'package:flutter/material.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('ID: ${user.id}'),
          Text('Name: ${user.name}'),
          Text('Username: ${user.username}'),
          Text('Email: ${user.email}'),
          ListTile(
            title: const Text('Phone'),
            subtitle: Text(user.phone),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Website'),
            subtitle: Text(user.website ?? 'No website'),
            onTap: () {},
          ),
          const Divider(),
          const Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(user.address.street),
          Text(user.address.suite),
          Text(user.address.city),
          Text(user.address.zipcode),
          Text('Latitude: ${user.address.geo.lat}'),
          Text('Longitude: ${user.address.geo.lng}'),
          const Divider(),
          const Text('Company', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(user.company.name),
          Text(user.company.catchPhrase),
          Text(user.company.bs),
        ],
      ),
    );
  }
}
