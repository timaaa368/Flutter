import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'users_model.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _website = TextEditingController();

  final _street = TextEditingController();
  final _suite = TextEditingController();
  final _city = TextEditingController();
  final _zipcode = TextEditingController();

  final _company = TextEditingController();
  final _catchPhrase = TextEditingController();
  final _bs = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();
    _phone.dispose();
    _website.dispose();
    _street.dispose();
    _suite.dispose();
    _city.dispose();
    _zipcode.dispose();
    _company.dispose();
    _catchPhrase.dispose();
    _bs.dispose();
    super.dispose();
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: required
          ? (value) =>
                value == null || value.trim().isEmpty ? 'Enter $label' : null
          : null,
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final model = context.read<UsersModel>();

    final draft = User(
      id: 0,
      name: _name.text.trim(),
      username: _username.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      website: _website.text.trim().isEmpty ? null : _website.text.trim(),
      address: Address(
        street: _street.text.trim(),
        suite: _suite.text.trim(),
        city: _city.text.trim(),
        zipcode: _zipcode.text.trim(),
        geo: const Geo(lat: 0, lng: 0),
      ),
      company: (
        name: _company.text.trim(),
        catchPhrase: _catchPhrase.text.trim(),
        bs: _bs.text.trim(),
      ),
    );

    try {
      await model.create(draft);

      if (!mounted) return;
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not save user: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UsersModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('New user')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Personal information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _field(_name, 'Name', required: true),
              _field(_username, 'Username', required: true),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              _field(_phone, 'Phone'),
              _field(_website, 'Website'),

              const SizedBox(height: 24),
              const Text(
                'Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _field(_street, 'Street'),
              _field(_suite, 'Suite'),
              _field(_city, 'City'),
              _field(_zipcode, 'Zipcode'),

              const SizedBox(height: 24),
              const Text(
                'Company',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _field(_company, 'Company name'),
              _field(_catchPhrase, 'Catch phrase'),
              _field(_bs, 'Business description'),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: model.creating ? null : _save,
                child: model.creating
                    ? const CircularProgressIndicator()
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
