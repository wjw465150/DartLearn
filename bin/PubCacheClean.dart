import 'dart:io';

// ignore: slash_for_doc_comments
/**
 * 2016.5.15 未按文件夹的命名来分析新版本
 * v0.1.1 用文件最后修改时间来判断
 *
 * 包名可能有下面几种情况：
 * _discoveryapis_commons-0.1.3
 * route_hierarchical-0.6.1+1
 * ace-0.5.10+20.12.14
 * unittest-0.12.0-alpha.1
 * webdriver-0.10.0-pre.10
 * q-r.dart-master
 */

//保存最新版本包信息
Map<String, String> _saveMap = new Map();

//需要被删除包的信息
Map<String, List> _deleteMap = new Map();

//保存Pub缓存目录
String _cachePath = null;

String getPubPath() {
  var path = Platform.environment["PUB_CACHE"];

  if (path == null) {
    if (Platform.isWindows) {
      path = Platform.environment["LOCALAPPDATA"];
      if (path == null) {
        noCache();
      }
      //path = path + r"/pub/cache/hosted/pub.dartlang.org";
      path = path + r"/pub/cache/hosted/pub.flutter-io.cn";
    } else {
      path = r"~/.pub-cache/hosted/pub.dartlang.org";
    }
  }

  if (!new Directory(path).existsSync()) {
    noCache();
  }

  print("[提示]Pub缓存目录：${path}");
  _cachePath = path;
  return path;
}

void noCache() {
  print(r"[错误]未找到Pub缓存目录！");
  exit(-1);
}

//判断包文件夹的名称是否规范
bool isValidFullName(String fullName) {
  if (new RegExp(r"^\D+$").hasMatch(fullName) || !new RegExp(r"(^.+)(-\d+\..*$)").hasMatch(fullName)) {
    return false;
  }

  return true;
}

//显示删除和保存包的分类信息
void showMaps() {
  print("------ Save ------");
  for (var key in _saveMap.keys) {
    print("${key}${_saveMap[key]}");
  }

  print("------ Delete ------");
  for (var key in _deleteMap.keys) {
    print("${key}${_deleteMap[key]}");
  }
}

/**
 * 获取包的名称和版本号
 * 包名称：list[0]
 * 版本号：list[1]
 */
List<String> getLibNameAndVersion(String fullName) {
  return _getLibNameAndVersionByFullName(fullName);
}

List<String> _getLibNameAndVersionByFullName(String fullName) {
  Iterable<Match> matches = new RegExp(r"(^.+)(-\d+\..*$)").allMatches(fullName);
  for (var match in matches) {
    return [match.group(1), match.group(2)];
  }
}

List<String> _getLibNameAndVersionByYaml(String fullName) {}

/**
 * 默认通过pubspec.yaml的最后修改时间来判断
 * 如果相同，则分析文件夹名称或解析yaml
 */
int compare(String name, String version) {
  int i = _compareByModified(name, version);
  if (i == 0) {
    i = _compareByName();
  }
  if (i == 0) {
    i = _compareByYaml();
  }

  return i;
}

/**
 * 对比最后修改时间
 * 如果保存的版本比匹配到的新版本旧，那么用新版本覆盖
 */
int _compareByModified(String name, String version) {
  return File(_cachePath + "/" + name + version + r"/pubspec.yaml")
      .lastModifiedSync()
      .compareTo(File(_cachePath + "/" + name + _saveMap[name] + r"/pubspec.yaml").lastModifiedSync());
}

int _compareByYaml() {}

int _compareByName() {}

void manageMaps(String name, String version) {
  if (_saveMap[name] == null) {
//如果没有该包的信息，直接保存
    _saveMap[name] = version;
  } else {
//根据比较的结果，保存包信息
    int i = compare(name, version);
    if (_deleteMap[name] == null) _deleteMap[name] = new List();

    if (i > 0) {
      _deleteMap[name].add(_saveMap[name]);
      _saveMap[name] = version;
    } else {
      _deleteMap[name].add(version);
    }
  }
}

void deleteMaps() {
  _deleteMap.forEach((name, versions) {
    versions.forEach((version) {
      File file = new File(_cachePath + "/" + name + version);
      print("[Delete]${file.path}");
      file.delete(recursive: true);
    });
  });
}

void cleanCacheDir() {
  String path = getPubPath();
  Directory cacheDir = new Directory(path);

//遍历所有文件夹
  List<FileSystemEntity> packageList = cacheDir.listSync();

  for (var i in packageList) {
    String packagePath = i.absolute.path;
    /**
     * 获取文件夹名称
     * FileUtils或Path中有方便的方法
     * String fullName = FileUtils.basename(packagePath);
     */
    String fullName = packagePath.substring(packagePath.lastIndexOf(new RegExp(r"[\/\\]")) + 1);

    if (!isValidFullName(fullName)) {
//如果包没有版本数字或不按"-"+版本数字的规范命名
//则直接将包保存到saveMap中
      _saveMap[fullName] = "";
    } else {
      List<String> name = getLibNameAndVersion(fullName);
      manageMaps(name[0], name[1]);
    }
  }

  showMaps();
  deleteMaps();
}

void main() {
  cleanCacheDir();
}
