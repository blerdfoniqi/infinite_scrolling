import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../services/api_service.dart';
import '../../services/custom_image_cache.dart';
import '../../models/user.dart';
import '../widgets/user_list_item.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({
    super.key,
    ApiService? apiService,
    Future<Uint8List?> Function(String url)? imageLoader,
  }) : _apiService = apiService,
       _imageLoader = imageLoader;

  final ApiService? _apiService;
  final Future<Uint8List?> Function(String url)? _imageLoader;

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _scrollController = ScrollController();
  late final ApiService _apiService;
  late final Future<Uint8List?> Function(String url) _imageLoader;

  final List<User> _users = [];
  bool _isLoading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _apiService = widget._apiService ?? ApiService();
    _imageLoader = widget._imageLoader ?? CustomImageCache.instance.getImage;
    _fetchUsers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.atEdge && position.pixels != 0) {
      _fetchUsers();
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _page = 1;
      _users.clear();
      _isLoading = false;
    });
    await _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final newUsers = await _apiService.fetchUsers(_page);
      setState(() {
        _page++;
        _users.addAll(newUsers);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Infinite Scrolling')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).padding.left,
            right: MediaQuery.of(context).padding.right,
            bottom: MediaQuery.of(context).padding.bottom + 60,
          ),
          itemCount: _users.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _users.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return UserListItem(user: _users[index], imageLoader: _imageLoader);
          },
        ),
      ),
    );
  }
}
