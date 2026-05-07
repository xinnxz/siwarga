import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.photoUrl,
    required this.name,
    this.size = 40,
  });

  final String? photoUrl;
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial =
        trimmed.isNotEmpty ? trimmed[0].toUpperCase() : '?';

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: photoUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, __) => _circlePlaceholder(size, initial),
          errorWidget: (_, __, ___) => _circlePlaceholder(size, initial),
        ),
      );
    }
    return _circlePlaceholder(size, initial);
  }

  Widget _circlePlaceholder(double s, String letter) {
    return CircleAvatar(
      radius: s / 2,
      child: Text(
        letter,
        style: TextStyle(fontSize: s * 0.4, fontWeight: FontWeight.w600),
      ),
    );
  }
}
