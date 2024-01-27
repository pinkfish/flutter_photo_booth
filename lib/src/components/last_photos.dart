import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/photos_library_api_model.dart';
import '../photos_library_api/media_item.dart';

class LastPhotos extends StatefulWidget {
  final String albumId;
  final double size;

  const LastPhotos({super.key, required this.albumId, required this.size});

  @override
  State<StatefulWidget> createState() => _LastPhotosState();
}

class _LastPhotosState extends State<LastPhotos> {
  late InfiniteScrollController controller;
  late Timer scrollingTimer;

  @override
  void initState() {
    super.initState();

    controller = InfiniteScrollController();
    scrollingTimer = Timer.periodic(const Duration(seconds: 3),
        (t) => controller.nextItem(duration: const Duration(seconds: 1)));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    scrollingTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var width = widget.size /16 * 9 + 15;
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (BuildContext context, Widget? child,
              PhotosLibraryApiModel apiModel) =>
          FutureBuilder(
              future: apiModel.searchMediaItems(widget.albumId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(
                      'got an error ${snapshot.error} ${snapshot.stackTrace}');
                }
                if (snapshot.hasData) {
                  var d = snapshot.data!;
                  return SizedBox(
                    height: widget.size,
                    child: InfiniteCarousel.builder(
                      itemCount: d.length,
                      itemExtent: width,
                      center: true,
                      anchor: 0.0,
                      velocityFactor: 0.2,
                      onIndexChanged: (index) {},
                      controller: controller,
                      axisDirection: Axis.horizontal,
                      loop: true,
                      itemBuilder: (context, itemIndex, realIndex) {
                        return _createCard(d[itemIndex], width);
                      },
                    ),
                  );
                }
                return SizedBox(
                  height: widget.size,
                );
              }),
    );
  }

  Widget _createCard(MediaItem it, double width) {
    return CachedNetworkImage(
        imageUrl: '${it.baseUrl}=w364',
        width: width,
        height: widget.size);
  }
}
