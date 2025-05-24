import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../models/user.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final Future<Uint8List?> Function(String url) imageLoader;

  const UserListItem({
    super.key,
    required this.user,
    required this.imageLoader,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfilePicture(),
              const SizedBox(width: 16),
              _buildUserInfo(context),
            ],
          ),
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return FutureBuilder<Uint8List?>(
      future: imageLoader(user.thumbnailUrl),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return CircleAvatar(
            radius: 30,
            backgroundImage: MemoryImage(snapshot.data!),
          );
        } else {
          return const CircleAvatar(
            radius: 30,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
      },
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameText(context),
          const SizedBox(height: 4),
          _buildEmailText(context),
          const SizedBox(height: 8),
          _buildLocationRow(context),
        ],
      ),
    );
  }

  Widget _buildNameText(BuildContext context) {
    return Text(
      user.fullName,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildEmailText(BuildContext context) {
    return Text(
      user.email,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildLocationRow(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        Icon(Icons.location_on, size: 16, color: primaryColor),
        const SizedBox(width: 4),
        if (user.flagEmoji.isNotEmpty)
          Text(user.flagEmoji, style: const TextStyle(fontSize: 14)),
        if (user.flagEmoji.isNotEmpty) const SizedBox(width: 4),
        Flexible(
          child: Text(
            user.location,
            style: TextStyle(fontSize: 14, color: primaryColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(height: 1, thickness: 1),
    );
  }
}
