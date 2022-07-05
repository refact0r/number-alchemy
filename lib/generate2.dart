import 'package:collection/collection.dart';

void permute(List<int> nums, int k, List<List<int>> perms) {
  for (int i = k; i < nums.length; i++) {
    nums.swap(i, k);
    permute(nums, k + 1, perms);
    nums.swap(k, i);
  }
  if (k == nums.length - 1) {
    if (!perms.contains(nums)) {
      perms.add(nums);
    }
  }
}
