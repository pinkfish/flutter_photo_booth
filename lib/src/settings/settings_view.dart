import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'settings_account.dart';
import 'settings_album.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/photos_library_api_model.dart';
import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.info),
              title: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String version = snapshot.data!.version;
                    String buildNumber = snapshot.data!.buildNumber;
                    return Text("Version $version $buildNumber");
                  }
                  return const Text("[loading]");
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings_display),
              title: DropdownButton<ThemeMode>(
                // Read the selected themeMode from the controller
                value: controller.themeMode,
                // Call the updateThemeMode method any time the user selects a theme.
                onChanged: (v) => controller.updateThemeMode(v!),
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark Theme'),
                  )
                ],
              ),
            ),
            SettingsAccount(
              controller: controller,
            ),
            controller.albumId == null
                ? OutlinedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SettingsAlbum(
                            controller: controller,
                          ),
                        ),
                      );
                    },
                    child: const Text('SELECT ALBUM'),
                  )
                : ScopedModelDescendant<PhotosLibraryApiModel>(
                    builder: (BuildContext context, Widget? child,
                            PhotosLibraryApiModel apiModel) =>
                        FutureBuilder(
                      future: apiModel.getAlbum(controller.albumId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var album = snapshot.data!;
                          return ListTile(
                            title: Text(
                              album.title ?? '[no title]',
                              style: Theme.of(context).textTheme.titleLarge!,
                            ),
                            leading: CachedNetworkImage(
                              imageUrl:
                                  '${snapshot.data!.coverPhotoBaseUrl}=w20-h20-c',
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (BuildContext context, String url,
                                  Object error) {
                                if (kDebugMode) {
                                  print(error);
                                }
                                return const Icon(Icons.error);
                              },
                              height: 20,
                              width: 20,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.album),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SettingsAlbum(
                                      controller: controller,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const ListTile(
                          leading: Icon(Icons.picture_in_picture),
                          title: Text('[loading]'),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
