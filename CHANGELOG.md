## [1.0.0-dev.9]

- fix: update supabase to [v1.0.0-dev.9](https://github.com/supabase-community/supabase-dart/blob/main/CHANGELOG.md#100-dev9)
  - fix: recreate a `PostgrestClient` with proper auth headers when calling `.rpc()` [(#143)](https://github.com/supabase-community/supabase-dart/pull/143)
  - fix: allow custom headers to be set for `SupabaseClient` [(#144)](https://github.com/supabase-community/supabase-dart/pull/144)
  - fix: stream error will emit the entire exception and the stack trace [(#145)](https://github.com/supabase-community/supabase-dart/pull/145)
  - fix: update realtime to [v1.0.0-dev.5](https://github.com/supabase-community/realtime-dart/blob/main/CHANGELOG.md#100-dev5)
    - fix: bug where it throws exception when listening to postgres changes on old version of realtime server
    - fix: sends null for access_token when not signed in [(#53)](https://github.com/supabase-community/realtime-dart/pull/53)



## [1.0.0-dev.8]

- BREAKING: update supabase to [v1.0.0-dev.7](https://github.com/supabase-community/supabase-dart/pull/141)
  - update payload shape on old version of realtime server to match the new version in realtime [v1.0.0-dev.3](https://github.com/supabase-community/realtime-dart/blob/main/CHANGELOG.md#100-dev3)
  - fix: encoding issue with some languages in gotrue [v1.0.0-dev.4](https://github.com/supabase-community/gotrue-dart/blob/main/CHANGELOG.md#100-dev4)
  - fix: update insert documentation to reflect new `returning` behavior in postgrest [v1.0.0-dev.4](https://github.com/supabase-community/postgrest-dart/blob/master/CHANGELOG.md#100-dev4)

## [1.0.0-dev.7]

- chore: update supabase to [v1.0.0-dev.6](https://github.com/supabase-community/supabase-dart/pull/139)
  - fix: `.stream()` typing issue [#138](https://github.com/supabase-community/supabase-dart/pull/138)

## [1.0.0-dev.6]

- BREAKING: update supabase package [v1.0.0-dev.5](https://github.com/supabase-community/supabase-dart/blob/main/CHANGELOG.md#100-dev5)
  - deprecated: `.stream()` no longer needs `.execute()`
  - BREAKING: `eq` filter on `.stream()` is a separate method now
  ```dart
  // before
  Supabase.instance.client.from('my_table:title=eq.Supabase')
    .stream(['id'])
    .order('created_at')
    .limit(10)
    .execute()
    .listen((payload) {
      // do something with payload here
    });

  // now
  Supabase.instance.client.from('my_table')
    .stream(['id'])
    .eq('title', 'Supabase')
    .order('created_at')
    .limit(10)
    .listen((payload) {
      // do something with payload here
    });
  ```
  - BREAKING: listening to database changes has a new API
  - feat: added support for [broadcast](https://supabase.com/docs/guides/realtime/broadcast) and [presence](https://supabase.com/docs/guides/realtime/presence)
  ```dart
  final channel = Supabase.instance.client.channel('can_be_any_string');

  // listen to insert events on public.messages table
  channel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: 'messages',
      ), (payload, [ref]) {
    print('database insert payload: $payload');
  });

  // listen to `location` broadcast events
  channel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(
        event: 'location',
      ), (payload, [ref]) {
    print(payload);
  });

  // send `location` broadcast events
  channel.send(
    type: RealtimeListenTypes.broadcast,
    event: 'location',
    payload: {'lat': 1.3521, 'lng': 103.8198},
  );

  // listen to presence states
  channel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'sync'),
      (payload, [ref]) {
    print(payload);
    print(channel.presenceState());
  });

  // subscribe to the above changes
  channel.subscribe((status) async {
    if (status == 'SUBSCRIBED') {
      // if subscribed successfully, send presence event
      final status = await channel.track({'user_id': myUserId});
    }
  });
  ```

## [1.0.0-dev.5]

- chore: add example app in example directory
- fix: `WidgetsBinding` warning

## [1.0.0-dev.4]

- BREAKING: update supabase package [v1.0.0-dev.4](https://github.com/supabase-community/supabase-dart/blob/main/CHANGELOG.md#100-dev4)
- feat: accept custom headers
- feat: add add X-Client-Info header

## [1.0.0-dev.3]

- BREAKING: update supabase package [v1.0.0-dev.3](https://github.com/supabase-community/supabase-dart/blob/main/CHANGELOG.md#100-dev3)

## [1.0.0-dev.2]

- feat: custom http client

## [1.0.0-dev.1]
- feat: add Mac OS and Windows support for deeplinks
- BREAKING: Remove SupabaseAuthRequiredState as well as overriding methods in SupabaseAuthState
```dart
// Before

await Supabase.initialize(
  url: 'SUPABASE_URL',
  anonKey: 'SUPABASE_ANON_KEY',
);
...

// Class extending `SupabaseAuthState` or `AuthRequiredState` was necessary
// to persist auth state
class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  ...
}

// After

// Initializing Supabase is all you need to do to persist auth state
// Deeplinks will also be automatically handled when you initialize Supabase.
await Supabase.initialize(
  url: 'SUPABASE_URL',
  anonKey: 'SUPABASE_ANON_KEY',
);

...

// You can get the initial session of the user with `SupabaseAuth.instance.initialSession`
try {
    final initialSession = await SupabaseAuth.instance.initialSession;
} catch(error) {
    // Handle errors in session initial recovery here
}

// You should now use `onAuthStateChanged` as the 
Supabase.instance.client.auth.onAuthStateChange((event, session) {
    // handle sinin/ signups here
});
```
- fix: OAuth should open in an external browser
- BREAKING: update supabase package [v1.0.0-dev.1](https://github.com/supabase-community/supabase-dart/blob/main/CHANGELOG.md#100-dev1)

## [0.3.3]
- feat: update supabase package [v0.3.6](https://github.com/supabase-community/supabase-dart/blob/main/CHANGELOG.md#036)

## [0.3.2]
- chore: add basic example codes on readme.md

## [0.3.1+3]
- fix: OAuth authentication page should open in an external browser

## [0.3.1+2]
- chore: update supabase package [v0.3.4+1](https://github.com/supabase-community/supabase-dart/blob/main/CHANGELOG.md#0341)

## [0.3.1+1]

- fix: lint error on Flutter 2.X
- chore: add multiple Flutter version to the CI pipeline

## [0.3.1]

- feat: update supabase to [v0.3.4](https://github.com/supabase-community/supabase-dart/blob/main/CHANGELOG.md#030)

## [0.3.0]

- BREAKING: update supabase to [v0.3.0](https://github.com/supabase-community/supabase-dart/blob/main/CHANGELOG.md#030)

## [0.2.12]

- chore: update supabase-dart package v0.2.14

## [0.2.11]

- chore: update supabase-dart package v0.2.13

## [0.2.10]

- chore: update supabase-dart package v0.2.12
- chore: update documents

## [0.2.9]

- feat: signing out now triggers `onUnauthenticated()`
- feat: export supabase package so that underlying symbols can be imported
- fix: update code samples to reflect breaking change from v0.0.3
- fix: typos on code samples on readme.md

## [0.2.8]

- chore: update supabase to v0.2.7

## [0.2.7]

- chore: update supabase to v0.2.6

## [0.2.6]

- fix: export local_storage

## [0.2.5]

- chore: update supabase to v0.2.5

## [0.2.4]

- chore: update supabase to v0.2.4

## [0.2.3]

- chore: update supabase to v0.2.3

## [0.2.2]

- chore: update supabase to v0.2.2

## [0.2.1]

- chore: update supabase to v0.2.1

## [0.2.0]

- chore: update supabase to v0.2.0

## [0.1.0]

- BREAKING CHANGE: `Supabase.initialize` is now `Future<void>`
- chore: update supabase to v0.1.0
- feat: using hive to persist session by default

## [0.0.8]

- chore: update supabase to v0.0.8

## [0.0.7]

- chore: update supabase to v0.0.7

## [0.0.6]

- chore: update supabase to v0.0.5

## [0.0.5]

- chore: update supabase to v0.0.4

## [0.0.4]

- chore: update supabase to v0.0.3

## [0.0.3]

- BREAKING CHANGE: rework Supabase singleton with `Supabase.initialize` and `Supabase.instance`
- chore: update docs

## [0.0.2]

- feat: support custom localStorage with fallback to SharedPreferences as default

## [0.0.1]

- chore: update supabase, url_launcher packages

## [0.0.1-dev.5]

- fix: launch url in the current tab for flutter web
- fix: SupabaseAuthRequiredState to trigger onAuthenticated when user session available

## [0.0.1-dev.4]

- feat: support flutter web

## [0.0.1-dev.3]

- chore: update supabase to v0.0.1

## [0.0.1-dev.2]

- feat: support nested authentication flow with startAuthObserver() and stopAuthObserver()
- feat: support SupabaseAuthRequiredState
- feat: support enable/disable debug log
- refactor: tidy up

## [0.0.1-dev.1]

- Initial pre-release.
