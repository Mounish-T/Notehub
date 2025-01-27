import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';


final String cloudName = "dkkgmwwat";

String? uploadedImageUrl;


Future<String?> uploadImage(File image) async{
  String url = "https://api.cloudinary.com/v1_1/$cloudName/upload";
  FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path),
      "upload_preset": "image_upload",
  });
  Dio dio = Dio();
    Response response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      uploadedImageUrl = response.data['secure_url'];
    } else {
      uploadedImageUrl = null; 
    }
    print(uploadedImageUrl);
    return uploadedImageUrl;

}

Future<void> deleteImage(String imageUrl) async {
  try {
    String cloudName = "dkkgmwwat"; // Replace with your Cloudinary cloud name
    String apiKey = "211953294257812"; // Replace with your API key
    String apiSecret = "5GxwKdUoNstkJVf5zxQdcTDSMB4"; // Replace with your API secret

    String cloudinaryBaseUrl = "https://api.cloudinary.com/v1_1/$cloudName";
    String url = "$cloudinaryBaseUrl/image/destroy";

    // Extract the public ID from the image URL
    final publicId = imageUrl.split('/').last.split('.').first;

    // Generate a timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    // Create the string to sign
    String stringToSign = "public_id=$publicId&timestamp=$timestamp$apiSecret";

    // Generate the signature using HMAC-SHA1
    String signature = sha1.convert(utf8.encode(stringToSign)).toString();

    // Make the HTTP POST request to delete the image
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "public_id": publicId,
        "timestamp": timestamp,
        "api_key": apiKey,
        "signature": signature,
      },
    );

    if (response.statusCode == 200) {
      print("Image deleted successfully");
    } else {
      print("Failed to delete image: ${response.body}");
    }
  } catch (e) {
    print("Error: $e");
  }
}

Future<String?> replacneImage(String imageUrl, File updatedImageFile) async {
  try {
    // Delete the existing image
    await deleteImage(imageUrl);

    // Upload the new image
    String? url = await uploadImage(updatedImageFile);
    return url;
  } catch (e) {
    rethrow; // Rethrow for centralized error handling
  }
}