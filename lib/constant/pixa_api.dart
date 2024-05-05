import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery/model/photo_model.dart';

class DataHelper {
  static Future<List<PhotoModel>> fetchData(int pageNumber) async {
    final apiKey = '43712574-5e5543b45a478fffbdb02d292';
    final response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=$apiKey&per_page=24&page=$pageNumber'));
    var data = jsonDecode(response.body);
    List<PhotoModel> list = [];
    for (var res in data['hits'] as List) {
      PhotoModel model = PhotoModel(
          id: res['id'].toString(),
          imageUrl: res['webformatURL'],
          views: res['views'],
          likes: res['likes'],
          tags: (res['tags'] as String).split(', ').toList());
      list.add(model);
    }
    return list;
  }
}
