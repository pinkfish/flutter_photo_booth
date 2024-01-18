import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:froggybooth/src/settings/settings_controller.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/photos_library_api_model.dart';
import '../pages/login_page.dart';

class SettingsAccount extends StatelessWidget {
  final SettingsController controller;

  const SettingsAccount({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (BuildContext context, Widget? child,
          PhotosLibraryApiModel apiModel) {
        if (apiModel.isLoggedIn()) {
          final placeholderCharSources = <String>[
            apiModel.user!.displayName ?? 'Unknown',
            apiModel.user!.email,
            '-',
          ];
          final placeholderChar = placeholderCharSources
              .firstWhere((String str) => str.trimLeft().isNotEmpty)
              .trimLeft()[0]
              .toUpperCase();
          return ListTile(
            leading: apiModel.user!.photoUrl != null
                ? CircleAvatar(
                    radius: 14,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        apiModel.user!.photoUrl ?? 'http://unknown',
                      ),
                    ),
                  )
                : CircleAvatar(
                    child: Text(placeholderChar),
                  ),
            title: Text(
              apiModel.user?.displayName ?? '[no name]',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
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
            ),
          );
        }
        return Row(children: [
          OutlinedButton(
              onPressed: () async => {
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage(
                          controller: controller,
                        ),
                      ),
                    )
                  },
              child: const Text('LOGIN')),
        ]);
      },
    );
  }
}
