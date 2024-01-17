/*
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/photos_library_api_model.dart';
import '../settings/settings_controller.dart';

class CreatePhotoBoothPage extends StatefulWidget {
  const CreatePhotoBoothPage({super.key, required this.controller});

  @override
  State createState() => _CreatePhotoBoothPageState();

  final SettingsController controller;

  static const routeName = '/create';
}

class _CreatePhotoBoothPageState extends State<CreatePhotoBoothPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController boothNameFormController = TextEditingController();

  @override
  void dispose() {
    boothNameFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: boothNameFormController,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        hintText: 'Booth name',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 0,
                      ),
                      child: const Text(
                        'This will create a shared album in your Google Photos'
                        ' account',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Center(
                      child: OutlinedButton(
                        onPressed: () => _createPhotoBooth(context),
                        child: const Text('CREATE BOOTH'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _createPhotoBooth(BuildContext context) async {
    // Display the loading indicator.
    setState(() => _isLoading = true);

    var album = await ScopedModel.of<PhotosLibraryApiModel>(context)
        .createAlbum(boothNameFormController.text);

    // Hide the loading indicator.
    setState(() => _isLoading = false);
    // Set the setting into the saved settings.
    widget.controller.updateAlbumId(album.id);
    if (!context.mounted) return;
    Navigator.pop(context);
  }
}
