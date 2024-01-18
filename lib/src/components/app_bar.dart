import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:froggybooth/src/settings/settings_controller.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/photos_library_api_model.dart';
import '../pages/login_page.dart';
import '../settings/settings_view.dart';

class FroggyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SettingsController controller;

  const FroggyAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (BuildContext context, Widget? child,
          PhotosLibraryApiModel apiModel) {
        return AppBar(
          title: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(right: 8),
                child: SvgPicture.asset(
                  'assets/images/flutter_logo.svg',
                  width: 20,
                  height: 20,
                ),
              ),
              Text(
                'Froggy Booth',
                style: TextStyle(color: Colors.green[800]),
              ),
            ],
          ),
          actions: _buildActions(apiModel, context),
        );
      },
    );
  }

  List<Widget> _buildActions(
      PhotosLibraryApiModel apiModel, BuildContext context) {
    final widgets = <Widget>[];
    if (apiModel.isLoggedIn()) {
      if (apiModel.user!.photoUrl != null) {
        widgets.add(CircleAvatar(
          radius: 14,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              apiModel.user!.photoUrl ?? 'http://unknown',
            ),
          ),
        ));
      } else {
        //  Placeholder to use when there is no photo URL.
        final placeholderCharSources = <String>[
          apiModel.user!.displayName ?? 'Unknown',
          apiModel.user!.email,
          '-',
        ];
        final placeholderChar = placeholderCharSources
            .firstWhere((String str) => str.trimLeft().isNotEmpty)
            .trimLeft()[0]
            .toUpperCase();
        widgets.add(
          Container(
            height: 6,
            child: CircleAvatar(
              child: Text(placeholderChar),
            ),
          ),
        );
      }
      widgets.add(IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          // Navigate to the settings page. If the user leaves and returns
          // to the app after it has been killed while running in the
          // background, the navigation stack is restored.
          Navigator.restorablePushNamed(context, SettingsView.routeName);
        },
      ));
      widgets.add(
        PopupMenuButton<_AppBarOverflowOptions>(
          onSelected: (_AppBarOverflowOptions selection) async {
            await apiModel.signOut();
            if (!context.mounted) return;
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginPage(
                  controller: controller,
                ),
              ),
            );
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<_AppBarOverflowOptions>>[
              const PopupMenuItem<_AppBarOverflowOptions>(
                value: _AppBarOverflowOptions.signOut,
                child: Text('Disconnect from Google Photos'),
              ),
            ];
          },
        ),
      );
    } else {
      widgets.add(IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          // Navigate to the settings page. If the user leaves and returns
          // to the app after it has been killed while running in the
          // background, the navigation stack is restored.
          Navigator.restorablePushNamed(context, SettingsView.routeName);
        },
      ));
    }
    return widgets;
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

enum _AppBarOverflowOptions {
  signOut,
}
