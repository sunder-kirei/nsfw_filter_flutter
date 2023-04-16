import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profanity_detector/helpers/api_helper.dart';

class ImageFilter extends StatefulWidget {
  const ImageFilter({super.key});

  @override
  State<ImageFilter> createState() => _ImageFilterState();
}

class _ImageFilterState extends State<ImageFilter> {
  File? _pickedFile;
  Map<String, dynamic>? apiResponse;
  bool isLoading = false;
  bool isUnsafe = false;

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) return;

    final path = pickedImage.path;
    setState(() {
      _pickedFile = File(path);
      isUnsafe = false;
      apiResponse = null;
    });

    return;
  }

  Future<void> checkNSFW() async {
    if (_pickedFile == null) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response = await APIHelper.checkNudity(
      path: _pickedFile?.path as String,
    );
    setState(() {
      apiResponse = response;
      isUnsafe = response["unsafe"];
      isLoading = false;
    });
    return;
  }

  Widget _buildPickerButton() {
    return IconButton(
      icon: Icon(
        Icons.image,
        size: 40,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: pickImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: isUnsafe ? Colors.redAccent[100] : null,
          ),
        ),
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  top: 20,
                ),
                child: Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 400,
                    child: _pickedFile == null
                        ? _buildPickerButton()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.file(
                                    _pickedFile!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                    ),
                                    child: _buildPickerButton(),
                                  ),
                                ),
                                if (isLoading)
                                  Positioned(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: ElevatedButton(
                  onPressed: checkNSFW,
                  child: const Text("Check NSFW"),
                ),
              ),
            ),
            if (apiResponse != null) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text(
                    "Found -",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              if (apiResponse!["objects"].isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text("Everything looks great!"),
                  ),
                ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final data = apiResponse!["objects"][index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          data["label"],
                        ),
                      ),
                    ),
                  );
                }, childCount: apiResponse!["objects"].length),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
