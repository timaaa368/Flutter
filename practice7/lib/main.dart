import 'package:flutter/material.dart';

import 'summary_card.dart';

void main() {
  runApp(const MyApp());
}

const groups = ['IT-2301', 'IT-2302', 'IT-2303', 'IT-2304', 'IT-2305'];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();

  String? _group;
  DateTime? _birth;
  bool _agreed = false;
  bool _done = false;
  int _passwordLength = 0;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _birthController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if ((value ?? '').trim().length < 2) {
      return 'Name must have at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();
    final at = email.indexOf('@');

    if (at < 1 || !email.substring(at + 1).contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').length < 8) {
      return 'Password must have at least 8 characters';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    if ((value ?? '') != _password.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateGroup(String? value) {
    if (value == null) {
      return 'Choose a group';
    }
    return null;
  }

  String? _validateBirth(String? value) {
    if (_birth == null) {
      return 'Choose your date of birth';
    }
    return null;
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2005, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;
    if (!mounted) return;

    setState(() {
      _birth = picked;
      _birthController.text =
          '${picked.day.toString().padLeft(2, '0')}.'
          '${picked.month.toString().padLeft(2, '0')}.'
          '${picked.year}';
    });
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _done = true;
      });

      FocusManager.instance.primaryFocus?.unfocus();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Account created')));
    }
  }

  void _startOver() {
    setState(() {
      _name.clear();
      _email.clear();
      _password.clear();
      _confirm.clear();
      _birthController.clear();

      _passwordLength = 0;
      _group = null;
      _birth = null;
      _agreed = false;
      _done = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_done ? 'Your profile' : 'Sign up')),
      body: _done
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SummaryCard(
                    name: _name.text.trim(),
                    email: _email.text.trim(),
                    group: _group!,
                    birthDate: _birthController.text,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _startOver,
                    child: const Text('Start over'),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _name,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateName,
                        onFieldSubmitted: (_) {
                          _emailFocus.requestFocus();
                        },
                        onTapOutside: (_) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _email,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'name@kbtu.kz',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateEmail,
                        onTapOutside: (_) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          helperText: 'At least 8 characters',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validatePassword,
                        onChanged: (value) {
                          setState(() {
                            _passwordLength = value.length;
                          });
                        },
                        onTapOutside: (_) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('$_passwordLength of 8'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirm,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Confirm password',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateConfirm,
                        onTapOutside: (_) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _group,
                        decoration: const InputDecoration(
                          labelText: 'Group',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          for (final group in groups)
                            DropdownMenuItem(value: group, child: Text(group)),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _group = value;
                          });
                        },
                        validator: _validateGroup,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _birthController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Date of birth',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_month),
                        ),
                        onTap: _pickBirthDate,
                        validator: _validateBirth,
                        onTapOutside: (_) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('I agree to the rules'),
                        value: _agreed,
                        onChanged: (value) {
                          setState(() {
                            _agreed = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _agreed ? _signUp : null,
                        child: const Text('Sign up'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
