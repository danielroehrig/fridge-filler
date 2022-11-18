abstract class Reorderable {
  int getPosition();
  void setPosition(int position);
  Future<void> save();
}

Future<void> updatePositions(List<Reorderable> lists) async {
  List<Future<void>> saveFutures = [];
  for (int i = 0; i < lists.length; i++) {
    Reorderable item = lists[i];
    item.setPosition(i);
    saveFutures.add(item.save());
  }
  await Future.wait(saveFutures);
}
