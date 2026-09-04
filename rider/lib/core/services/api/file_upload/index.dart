import 'dart:convert';
import 'dart:io';
// import 'dart:math';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:xtridelink_driver/core/constants/strings.dart';
// import 'package:xtridelink_driver/core/services/api/request_helper.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
// import 'package:xtridelink_driver/injector.dart';
import '../../../constants/helpers.dart';
import '../../storage/index.dart';
import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

sealed class FileUploadService {
  Future<String?> uploadImage({required File image});
  Future<String?> uploadFile({required File image});
}

class FileUploadServiceImpl extends FileUploadService {
  StorageServiceImpl storageServiceImpl;

  FileUploadServiceImpl({required this.storageServiceImpl});

  @override
  Future<String?> uploadImage({required File image}) async {
    final cloudinary =
        CloudinaryPublic('dgic0yeol', 'rider_documents', cache: false);
    if (File(image.path).lengthSync() >= (3 * 1024 * 1024)) {
      HelperFunc.toast('File size should be less than 3MB');
      return null;
    }
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'rider_uploads',
        ),
      );

      HelperFunc.logger(response.data.toString());
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      HelperFunc.logger(e.message!);
      HelperFunc.toast('Failed to upload image');
    } catch (e) {
      globalPop();
      HelperFunc.toast('An unexpected error occurred');
    }

    return null;
  }

  @override
  Future<String?> uploadFile({required File image}) async {
    // 1. Define the API endpoint URL (HTTPS — uploads carry auth + KYC docs)
    var uri = Uri.https(GlobalStrings.host, '/users/uploads/spaces/');

    // 2. Create a MultipartRequest
    var request = http.MultipartRequest('POST', uri);

    // 3. Add text fields (optional)
    // These act as normal form fields (e.g., user ID, name, etc.)
    request.fields['upload_type'] = 'image';

    // 5. Add files (optional)
    // To upload a file, use http.MultipartFile.fromPath()
    try {
      // Example: assuming you have a file path
      String filePath = image.path;
      request.files.add(await http.MultipartFile.fromPath(
        'file', // This is the field name expected by the server
        filePath,
        // contentType: MediaType('image', 'jpeg'), // Optional: specify content type
      ));
    } catch (e) {
      debugPrint('Error adding file: $e');
    }

    // 6. Send the request
    var response = await request.send();

    // 7. Process the response
    if (response.statusCode == 200) {
      // Convert the streamed response to a string to read the body
      final responseBody = await response.stream.bytesToString();
      debugPrint('Uploaded successfully!');
      debugPrint('Response body: $responseBody');
      // You can then decode the JSON response if needed: jsonDecode(responseBody);
      final responseJson = jsonDecode(responseBody);
      return responseJson['data']['url'];
    } else {
      debugPrint('Failed to upload. Status code: ${response.statusCode}');
      final errorBody = await response.stream.bytesToString();
      debugPrint('Error body: $errorBody');
      return errorBody;
    }
  }
}
