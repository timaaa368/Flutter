import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import 'users_model.dart';
import 'widgets/loading_view.dart';
import 'widgets/error_view.dart';
import 'widgets/user_list.dart';
import 'new_user_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UsersModel>();

    Widget body;

    if (model.loading) {
      body = const LoadingView();
    } else {
      body = switch (model.error) {
        null => UserList(users: model.items),
        NoConnectionException() => ErrorView(
          message: 'No internet connection',
          onRetry: model.load,
        ),
        NotFoundException() => ErrorView(
          message: 'User not found',
          onRetry: model.load,
        ),
        UnauthorizedException() => ErrorView(
          message: 'Unauthorized request',
          onRetry: model.load,
        ),
        ServerException(:final status) => ErrorView(
          message: 'Server error: $status',
          onRetry: model.load,
        ),
        BadResponseException() => const Center(
          child: Text('Could not read server response'),
        ),
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users API'),
        actions: [
          IconButton(onPressed: model.load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: model.load,
        child: body is UserList
            ? body
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: body,
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
