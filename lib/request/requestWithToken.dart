import 'package:dio/dio.dart';

class HttpHelper{
  late Dio _dio;

  DioHelper(){
    _dio=Dio(BaseOptions());
  }

  Future<Response> getRequest(String url, {String? token}) async {
    try {
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      } else {
        _dio.options.headers.remove('Authorization');
      }
      Response response = await _dio.get(url);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Response> postRequest(String url,dynamic data,{String? token})async{
    try {
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      } else {
        _dio.options.headers.remove('Authorization');
      }
      Response response = await _dio.post(url, data: data);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
  Future<Response> uploadFile(String url, String filePath, {String? token}) async {
    try {
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      } else {
        _dio.options.headers.remove('Authorization');
      }

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
      });

      Response response = await _dio.post(url, data: formData);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> downloadFile(String url, String savePath, {String? token}) async {
    try {
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      } else {
        _dio.options.headers.remove('Authorization');
      }

      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );
    } catch (e) {
      return Future.error(e);
    }
  }
}