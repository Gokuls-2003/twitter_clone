import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void ShowSnackBar(BuildContext context, String content){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content)
    )
  );
}

String getNameFromEmail(String email){
  return email.split('@')[0];
}

Future<List<File>> PickImages() async{
  List<File> images =[];
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();
  if(imageFiles.isNotEmpty){
    for(final image in imageFiles){
        images.add(File(image.path));
    }
  }
  return images;
}

Future<File?> PickImage() async{
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickImage(source: ImageSource.gallery);
  if(imageFiles != null){
     return File(imageFiles.path);
  }
  return null;
}