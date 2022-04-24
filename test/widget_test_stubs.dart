import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockWidget extends ConsumerStatefulWidget {
  const MockWidget({Key? key}) : super(key: key);

  @override
  _MockWidgetState createState() => _MockWidgetState();
}

class _MockWidgetState extends SupabaseAuthRequiredState<MockWidget> {
  bool isSignedIn = true;

  @override
  void onUnauthenticated() {
    setState(() {
      isSignedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isSignedIn
        ? TextButton(
            onPressed: () {
              Supabase.instance.client.auth.signOut();
            },
            child: const Text('Sign out'),
          )
        : const Text('You have signed out');
  }
}

class MockLocalStorage extends LocalStorage {
  MockLocalStorage()
      : super(
          initialize: () async {},

          /// Session expires at is at its maximum value for unix timestamp
          accessToken: () async =>
              '{"currentSession":{"access_token":"","expires_in":3600,"refresh_token":"","user":{"id":"","aud":"","created_at":"","role":"authenticated","updated_at":""}},"expiresAt":2147483647}',
          persistSession: (_) async {},
          removePersistedSession: () async {},
          hasAccessToken: () async => true,
        );
}
