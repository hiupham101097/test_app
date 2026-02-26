import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

class RegisterStoreRequest {
  RegisterStoreRequest({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.imageFile,
    this.bannerFile,
    this.organizationId,
    this.phone,
    this.ownerEmail,
    this.location,
    this.province,
    this.district,
    this.commune,
    this.street,
    this.lat,
    this.lng,
    this.minPrice,
    this.maxPrice,
    this.menu,
    this.rating,
    this.openTime,
    this.closeTime,
    this.taxCode,
    this.businessLicenseNumber,
    this.status,
    this.storeSystemCategory,
    this.system,
  });

  final String? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? imageFile;
  final String? bannerFile;
  final int? organizationId;
  final String? phone;
  final String? ownerEmail;
  final String? location;
  final String? province;
  final String? district;
  final String? commune;
  final String? street;
  final double? lat;
  final double? lng;
  final int? minPrice;
  final int? maxPrice;
  final String? menu;
  final int? rating;
  final String? openTime;
  final String? closeTime;
  final String? taxCode;
  final List<String>? businessLicenseNumber;
  final String? status;
  final List<Map<String, dynamic>>? storeSystemCategory;
  final List<String>? system;
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "slug": slug,
      "description": description,
      "image_url": imageFile,
      "banner_img": bannerFile,
      "organizationId": organizationId,
      "phone": phone,
      "ownerEmail": ownerEmail,
      "location": location,
      "province": province,
      "district": district,
      "commune": commune,
      "street": street,
      "lat": lat,
      "lng": lng,
      "minPrice": minPrice,
      "maxPrice": maxPrice,
      "rating": rating,
      "openTime": openTime,
      "closeTime": closeTime,
      "taxCode": taxCode,
      "status": status,
      "storeSystemCategory": storeSystemCategory,
      "system": system,
    }..removeWhere((k, v) => v == null || v.toString().isEmpty);
  }

  Future<dio.FormData> toFormData() async {
    final formData = dio.FormData();

    // Text fields
    final textFields = {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'organizationId': organizationId?.toString(),
      'phone': phone,
      'ownerEmail': ownerEmail,
      'location': location,
      'province': province,
      'district': district,
      'commune': commune,
      'street': street,
      'lat': lat?.toString(),
      'lng': lng?.toString(),
      'minPrice': minPrice?.toString(),
      'maxPrice': maxPrice?.toString(),
      'rating': rating?.toString(),
      'openTime': openTime,
      'closeTime': closeTime,
      'taxCode': taxCode,
      'status': status,
    }..removeWhere((_, v) => v == null || v.isEmpty);

    textFields.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    // JSON field
    if (storeSystemCategory != null && storeSystemCategory!.isNotEmpty) {
      formData.fields.add(
        MapEntry('storeSystemCategory', jsonEncode(storeSystemCategory)),
      );
    }

    if (system != null && system!.isNotEmpty) {
      formData.fields.add(MapEntry('system', jsonEncode(system)));
    }

    // Helper function to detect mime type
    MediaType _getMediaType(String path) {
      final ext = path.split('.').last.toLowerCase();
      switch (ext) {
        case 'png':
          return MediaType('image', 'png');
        case 'jpg':
        case 'jpeg':
          return MediaType('image', 'jpeg');
        case 'pdf':
          return MediaType('application', 'pdf');
        default:
          return MediaType('application', 'octet-stream');
      }
    }

    bool _isFilePath(String path) {
      if (path.startsWith('http://') || path.startsWith('https://')) {
        return false;
      }

      final fileExtensions = ['.png', '.jpg', '.jpeg', '.pdf', '.gif', '.webp'];
      return fileExtensions.any((ext) => path.toLowerCase().endsWith(ext));
    }

    // Add file fields
    final List<Future<void>> fileFutures = [];

    if (imageFile != null && imageFile!.isNotEmpty && _isFilePath(imageFile!)) {
      fileFutures.add(() async {
        formData.files.add(
          MapEntry(
            'image_url',
            await dio.MultipartFile.fromFile(
              imageFile!,
              filename: imageFile!.split('/').last,
              contentType: _getMediaType(imageFile!),
            ),
          ),
        );
      }());
    }

    if (bannerFile != null &&
        bannerFile!.isNotEmpty &&
        _isFilePath(bannerFile!)) {
      fileFutures.add(() async {
        formData.files.add(
          MapEntry(
            'banner_img',
            await dio.MultipartFile.fromFile(
              bannerFile!,
              filename: bannerFile!.split('/').last,
              contentType: _getMediaType(bannerFile!),
            ),
          ),
        );
      }());
    }

    if (menu != null && menu!.isNotEmpty && _isFilePath(menu!)) {
      fileFutures.add(() async {
        formData.files.add(
          MapEntry(
            'menu',
            await dio.MultipartFile.fromFile(
              menu!,
              filename: menu!.split('/').last,
              contentType: _getMediaType(menu!),
            ),
          ),
        );
      }());
    }

    if (businessLicenseNumber != null && businessLicenseNumber!.isNotEmpty) {
      for (final file in businessLicenseNumber!) {
        if (_isFilePath(file)) {
          fileFutures.add(() async {
            formData.files.add(
              MapEntry(
                'businessLicenseNumber',
                await dio.MultipartFile.fromFile(
                  file,
                  filename: file.split('/').last,
                  contentType: _getMediaType(file),
                ),
              ),
            );
          }());
        }
      }
    }

    await Future.wait(fileFutures);
    return formData;
  }
}
