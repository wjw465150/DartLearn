main() {
  var ingredients = new Set();

  ingredients.addAll(['gold', 'titanium', 'xenon']);
  assert(ingredients.length == 3);

// 添加已存在的元素无效
  ingredients.add('gold');
  assert(ingredients.length == 3);

// 删除元素
  ingredients.remove('gold');
  assert(ingredients.length == 2);

// 检查在Set中是否包含某个元素
  assert(ingredients.contains('titanium'));

// 检查在Set中是否包含多个元素
  assert(ingredients.containsAll(['titanium', 'xenon']));
  ingredients.addAll(['gold', 'titanium', 'xenon']);

// 获取两个集合的交集
  var nobleGases = new Set.from(['xenon', 'argon']);
  var intersection = ingredients.intersection(nobleGases);
  assert(intersection.length == 1);
  assert(intersection.contains('xenon'));

// 检查一个Set是否是另一个Set的子集
  var allElements = ['hydrogen', 'helium', 'lithium', 'beryllium', 'gold', 'titanium', 'xenon'];
  allElements.contains(ingredients);
}
