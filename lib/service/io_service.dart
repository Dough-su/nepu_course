import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:path_provider/path_provider.dart';

class io_service {
  Future<bool> fileExists(File file) async {
    return await file.exists();
  }

  Future<String> readFileAsString(File file) async {
    return await file.readAsString();
  }

  Future<File> createFile(File file) async {
    return await file.create();
  }

  Future<void> writeStringToFile(File file, String data) async {
    await file.writeAsString(data);
  }

  getavaterpng() async {
    //获取应用目录的card.png，如果有则返回
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/avater.png');
      if (file.existsSync()) {
        //将本地图片保存到cardpic
        //将file转换为image
        Global().avaterpic = Image.file(File(file.path)).image;
      }
    });
  }

  getcardpng() async {
    //获取应用目录的card.png，如果有则返回
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/card.png');
      if (file.existsSync()) {
        //将本地图片保存到cardpic
        //将file转换为image
        Global().cardpic = Image.file(File(file.path)).image;
      }
    });
  }

  calanderlogo() async {
    //获取应用目录的logo.png，如果有则返回
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/calendar.png');
      if (file.existsSync()) {
        print(file.path);
        Global().calendarlogo = Image.file(File(file.path)).image;
      }
    });
  }

  getlogopng() async {
    //获取应用目录的logo.png，如果有则返回
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/logo.png');
      if (file.existsSync()) {
        //将本地图片保存到logopic
        //将file转换为image
        print(file.path);
        Global().logopic = Image.file(File(file.path)).image;
      }
    });
  }

  Future<void> downloadAndUpdateFile(
      {required File file,
      required String fileUrl,
      required Function(int) onDownloadingListener}) async {
    var dio = Dio();
    await dio.download(
      fileUrl,
      file.path,
      onReceiveProgress: (count, total) {
        onDownloadingListener((count / total * 100).toInt());
      },
    );
  }

  //清除文件
  Future<void> deleteFiles() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final filesToDelete = [
      'course.json',
      'score.json',
      'calanderagenda.txt',
      'calanderagenda1.txt',
      'account.txt',
      'logininfo1.txt',
      'hascourse.json',
    ];

    for (final filename in filesToDelete) {
      final file = File('${documentsDirectory.path}/$filename');
      if (file.existsSync()) {
        try {
          await file.delete();
        } catch (e) {
          print(e);
        }
      }
    }
  }
}
