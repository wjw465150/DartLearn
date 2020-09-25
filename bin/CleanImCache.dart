import 'dart:io';

const rootPath = r'c:/WJW_D/个人配置/My Documents/';
//各种IM的缓存目录
List<String> _cachePath = [
  '${rootPath}Tencent Files/746861174/Image/Group2',
  '${rootPath}Tencent Files/746861174/Video',
  '${rootPath}Tencent Files/746861174/FileRecv',
  '${rootPath}Tencent Files/746861174/Audio',
  '${rootPath}WXWork/1688853573303163/Cache/File',
  '${rootPath}WXWork/1688853573303163/Cache/Image',
  '${rootPath}WXWork/1688853573303163/Cache/Video',
  '${rootPath}WXWork/1688853573303163/Cache/Voice'
];

void main() {
  /*
  Map<String, String> envVars = Platform.environment;
  print(envVars);
  exit(0);
*/

  for (String dd in _cachePath) {
    var darDD = Directory(dd);
    if (darDD.existsSync() == false) {
      continue;
    }

    FileStat fileStat = darDD.statSync();
    if (fileStat.size > 0) {
      print("$dd size: ${fileStat}");
      darDD.deleteSync(recursive: true);
    } else {
      List<FileSystemEntity> llFS = darDD.listSync(recursive: true, followLinks: false);
      for (var fs in llFS) {
        if (fs.statSync().size > 0) {
          print("$fs size: ${fileStat}");
          darDD.deleteSync(recursive: true);
          break;
        }
      }
    }
  }
}
