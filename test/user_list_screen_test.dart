import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_scrolling/services/api_service.dart';
import 'package:infinite_scrolling/models/user.dart';
import 'package:infinite_scrolling/ui/screens/user_list_screen.dart';

void main() {
  final fakeImageBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=',
  );
  Future<Uint8List?> imageLoader(String _) => Future.value(fakeImageBytes);

  testWidgets('displays fetched users with their details', (
    WidgetTester tester,
  ) async {
    final fakeApi = _FakeApiService({
      1: [
        _buildUser(
          name: 'Mr Test User',
          email: 'test.user@example.com',
          city: 'Timaru',
          country: 'New Zealand',
          countryCode: 'NZ',
        ),
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: UserListScreen(apiService: fakeApi, imageLoader: imageLoader),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Mr Test User'), findsOneWidget);
    expect(find.text('test.user@example.com'), findsOneWidget);
    expect(find.text('Timaru, New Zealand'), findsOneWidget);
  });

  testWidgets('loads the next page when scrolled to the bottom', (
    WidgetTester tester,
  ) async {
    final fakeApi = _FakeApiService({
      1: List.generate(
        25,
        (index) =>
            _buildUser(name: 'User $index', email: 'user$index@example.com'),
      ),
      2: [_buildUser(name: 'Ms Next Page', email: 'next.page@example.com')],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: UserListScreen(apiService: fakeApi, imageLoader: imageLoader),
      ),
    );

    await tester.pumpAndSettle();

    expect(fakeApi.requestedPages, contains(1));
    expect(find.text('Ms Next Page'), findsNothing);

    await _scrollToBottom(tester);
    await _scrollToBottom(tester);

    expect(fakeApi.requestedPages, contains(2));
    expect(find.text('Ms Next Page'), findsOneWidget);
  });
}

User _buildUser({
  required String name,
  required String email,
  String city = 'Auckland',
  String country = 'New Zealand',
  String countryCode = 'NZ',
}) {
  return User(
    fullName: name,
    email: email,
    thumbnailUrl: 'https://example.com/thumb.jpg',
    largePictureUrl: 'https://example.com/large.jpg',
    city: city,
    country: country,
    countryCode: countryCode,
  );
}

class _FakeApiService extends ApiService {
  _FakeApiService(this.responses);

  final Map<int, List<User>> responses;
  final List<int> requestedPages = [];

  @override
  Future<List<User>> fetchUsers(int page) async {
    requestedPages.add(page);
    return Future.value(responses[page] ?? []);
  }
}

Future<void> _scrollToBottom(WidgetTester tester) async {
  final listView = tester.widget<ListView>(find.byType(ListView));
  final controller = listView.controller!;
  expect(controller.hasClients, isTrue);
  controller.jumpTo(controller.position.maxScrollExtent);
  await tester.pump();
  await tester.pumpAndSettle();
}
