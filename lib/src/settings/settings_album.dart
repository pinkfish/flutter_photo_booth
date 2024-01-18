import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../pages/photo_booth_page.dart';
import '../components/album_card.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/photos_library_api_model.dart';
import '../pages/create_booth_page.dart';
import 'settings_controller.dart';

class SettingsAlbum extends StatelessWidget {
  const SettingsAlbum({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBoothList(),
    );
  }

  Widget _buildBoothList() {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (BuildContext context, Widget? child,
          PhotosLibraryApiModel photosLibraryApi) {
        if (!photosLibraryApi.hasAlbums) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (photosLibraryApi.albums.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/flutter_logo.svg',
                color: Colors.grey[300],
                height: 148,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "You're not currently a member of any photo booth albums. "
                  'Create a new booth booth album or join an existing one below.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              _buildButtons(context),
            ],
          );
        }

        return ListView.builder(
          itemCount: photosLibraryApi.albums.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildButtons(context);
            }
            var albumId = photosLibraryApi.albums[index - 1].id;
            return AlbumCard(
              albumId: albumId,
              onTap: () => controller.updateAlbumId(albumId).then((d) => {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return PhotoBoothPage(
                        albumId: albumId,
                      );
                    }))
                  }),
            );
          },
        );
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      CreatePhotoBoothPage(controller: controller),
                ),
              );
            },
            child: const Text('CREATE A BOOTH ALBUM'),
          ),
        ],
      ),
    );
  }
}
