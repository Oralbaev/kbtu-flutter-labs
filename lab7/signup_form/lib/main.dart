import 'package:flutter/material.dart';

import 'summary_card.dart';

void main() => runApp(const MyApp());

const groups = ['IT-2301', 'IT-2302', 'IT-2303', 'IT-2304', 'IT-2305'];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign up',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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

  final _emailFocus = FocusNode();

  String? _group;
  DateTime? _birth;

  bool _agreed = false;
  bool _done = false;
  int _passwordLength = 0;

  @override
  void dispose() {
    for (final controller in [
      _name,
      _email,
      _password,
      _confirm,
      _birthController,
    ]) {
      controller.dispose();
    }

    _emailFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Account created')));

    setState(() => _done = true);
  }

  Future<void> _selectBirthDate() async {
    final today = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: today,
    );

    if (selected == null) return;
    if (!mounted) return;

    setState(() {
      _birth = selected;

      final day = selected.day.toString().padLeft(2, '0');
      final month = selected.month.toString().padLeft(2, '0');

      _birthController.text = '$day.$month.${selected.year}';
    });
  }

  void _reset() {
    setState(() {
      for (final controller in [
        _name,
        _email,
        _password,
        _confirm,
        _birthController,
      ]) {
        controller.clear();
      }

      _group = null;
      _birth = null;
      _agreed = false;
      _done = false;
      _passwordLength = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: _done ? _buildSummary() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create your account',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _emailFocus.requestFocus(),
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              validator: (value) {
                if ((value ?? '').trim().length < 2) {
                  return 'Name is too short';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _email,
              focusNode: _emailFocus,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'name@kbtu.kz',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              validator: (value) {
                final email = (value ?? '').trim();

                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                  return 'Email looks wrong';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                labelText: 'Password',
                helperText: 'At least 8 characters',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                setState(() => _passwordLength = value.length);
              },
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              validator: (value) {
                if ((value ?? '').length < 8) {
                  return 'Password is too short';
                }
                return null;
              },
            ),

            Text('$_passwordLength of 8'),
            const SizedBox(height: 16),

            TextFormField(
              controller: _confirm,
              decoration: const InputDecoration(
                labelText: 'Confirm password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (_agreed) _submit();
              },
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              validator: (value) {
                if (value != _password.text) {
                  return 'Passwords do not match';
                }
                return null;
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
                setState(() => _group = value);
              },
              validator: (value) {
                if (value == null) {
                  return 'Choose a group';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _birthController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date of birth',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: _selectBirthDate,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              validator: (_) {
                if (_birth == null) {
                  return 'Choose your date of birth';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            CheckboxListTile(
              title: const Text('I agree to the rules'),
              value: _agreed,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() => _agreed = value ?? false);
              },
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: _agreed ? _submit : null,
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SummaryCard(
            name: _name.text.trim(),
            email: _email.text.trim(),
            group: _group ?? '',
            birthDate: _birthController.text,
          ),
          const SizedBox(height: 24),
          TextButton(onPressed: _reset, child: const Text('Start over')),
        ],
      ),
    );
  }
}
