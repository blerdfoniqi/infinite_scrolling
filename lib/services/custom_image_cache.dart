import 'dart:io';
import 'dart:typed_data';

class CustomImageCache {
  CustomImageCache._privateConstructor();

  static final CustomImageCache _instance = CustomImageCache._privateConstructor();

  final Map<String, Uint8List> _cache = {};

  static CustomImageCache get instance => _instance;

  Future<Uint8List?> getImage(String url) async {
    if (_cache.containsKey(url)) {
      return _cache[url];
    } else {
      final httpClient = HttpClient();
      try {
        final uri = Uri.parse(url);
        final request = await httpClient.getUrl(uri);
        final response = await request.close();

        if (response.statusCode == HttpStatus.ok) {
          final bytes = await response.fold<List<int>>(
              [], (previous, current) => previous..addAll(current));
          final imageBytes = Uint8List.fromList(bytes);
          _cache[url] = imageBytes;
          return imageBytes;
        }
      } catch (e) {
        print('Error downloading image: $e');
        return null;
      } finally {
        httpClient.close();
      }
    }
    return null;
  }
}