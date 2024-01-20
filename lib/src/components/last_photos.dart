import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/photos_library_api_model.dart';
import '../photos_library_api/media_item.dart';

class LastPhotos extends StatelessWidget {
  final String albumId;
  final double size;

  const LastPhotos({super.key, required this.albumId, required this.size});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (BuildContext context, Widget? child,
              PhotosLibraryApiModel apiModel) =>
          FutureBuilder(
              future: apiModel.searchMediaItems(albumId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var d = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: d.mediaItems.map(_createCard).toList(),
                    ),
                  );
                }
                return SizedBox(
                  height: size,
                );
              }),
    );
  }

  Widget _createCard(MediaItem it) {
    return CachedNetworkImage(
        imageUrl: '${it.baseUrl}=w364', width: size, height: size);
  }
}
