import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_gay_agenda/services/user.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfilePicturePicker extends StatefulWidget {
  final User user;
  const ProfilePicturePicker({required this.user, Key? key}) : super(key: key);

  @override
  _ProfilePicturePickerState createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  final _imagePicker = ImagePicker();

  Widget imagePickerButton(ImageSource source) => ElevatedButton(
      child: Text('From ' + source.toString().split('.').last),
      onPressed: () async {
        XFile? image = await _imagePicker.pickImage(
            source: source,
            imageQuality: 50,
            preferredCameraDevice: CameraDevice.front);
        setState(() {
          widget.user.imagePath = image!.path;
          widget.user.save();
        });
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 200,
            height: 200,
            child: CircleAvatar(
                foregroundImage: widget.user.imagePath.isNotEmpty
                    ? Image.file(File(widget.user.imagePath)).image
                    : Image.memory(kTransparentImage).image,
                backgroundImage: const NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/20/20079.png'))),
        Container(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const Text('New profile image:'),
              const SizedBox(height: 10),
              imagePickerButton(ImageSource.gallery),
              const SizedBox(height: 10),
              imagePickerButton(ImageSource.camera)
            ]))
      ],
    );
  }
}
