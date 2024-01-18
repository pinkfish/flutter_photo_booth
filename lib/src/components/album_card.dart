import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/photos_library_api_model.dart';
import '../photos_library_api/album.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.albumId, this.onTap});

  final String albumId;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 33,
      ),
      child: InkWell(
        onTap: onTap,
        child: ScopedModelDescendant<PhotosLibraryApiModel>(
          builder: (BuildContext context, Widget? child,
                  PhotosLibraryApiModel apiModel) =>
              FutureBuilder(
            future: apiModel.getAlbum(albumId),
            builder: (context, snapshot) => Column(
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildPhotoBoothThumbnail(snapshot),
                ),
                Container(
                  height: 52,
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildSharedIcon(snapshot),
                        Align(
                          alignment: const FractionalOffset(0, 0.5),
                          child: Text(
                            snapshot.hasData
                                ? snapshot.data!.title ?? '[no title]'
                                : '[loading]',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoBoothThumbnail(AsyncSnapshot<Album> snapshot) {
    if (!snapshot.hasData || snapshot.data?.coverPhotoBaseUrl == null) {
      return Container(
        height: 160,
        width: 346,
        color: Colors.grey[200],
        padding: const EdgeInsets.all(5),
        child: SvgPicture.asset(
          'assets/images/flutter_logo.svg',
          color: Colors.grey[350],
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: '${snapshot.data!.coverPhotoBaseUrl}=w346-h160-c',
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (BuildContext context, String url, Object error) {
        print(error);
        return const Icon(Icons.error);
      },
    );
  }

  Widget _buildSharedIcon(AsyncSnapshot<Album> snapshot) {
    if (snapshot.hasData && snapshot.data!.shareInfo != null) {
      return const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(
            Icons.folder_shared,
            color: Colors.black38,
          ));
    } else {
      return Container();
    }
  }
}
