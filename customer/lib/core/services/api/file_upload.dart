import 'dart:io';
import 'package:xtridelink/core/constants/strings.dart';
import '../../constants/helpers.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import '../storage/index.dart';

sealed class FileUploadService {
  Future<String?> uploadImage({required File image});
}

@Injectable()
class FileUploadServiceImpl extends FileUploadService {
  StorageServiceImpl storageServiceImpl;

  FileUploadServiceImpl({required this.storageServiceImpl});

  @override
  Future<String?> uploadImage({required File image}) async {
    if (File(image.path).lengthSync() >= (3 * 1024 * 1024)) {
      HelperFunc.toast('File size should be less than 3MB');
      return null;
    }
    try {
      Dio dio = Dio();
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path,
            filename: image.path.split(Platform.pathSeparator).last,
            contentType: MediaType('image', 'png'))
      });
      Response response =
          await dio.post('https://${GlobalStrings.host}/v1/file/upload',
              data: formData,
              options: Options(headers: {
                'Content-Type': 'multipart/form-data',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${await storageServiceImpl.getToken()}'
              }));
      var body = response.data;
      HelperFunc.logger(response.data.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return body['Location'] ?? '';
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to upload image');
      }
    } catch (e) {
      HelperFunc.logger(e.toString());
      HelperFunc.toast('Failed to upload image');
    }
    return null;
  }
}
