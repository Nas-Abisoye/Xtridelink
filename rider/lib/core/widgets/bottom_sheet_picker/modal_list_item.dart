abstract class ModalListItem<T> {
  String title;
  bool? isLocked;
  T value;
  ModalListItem({
    required this.title,
    this.isLocked,
    required this.value,
  });
}

class CustomModalListItem<T> extends ModalListItem<T> {
  CustomModalListItem(
      {required super.title, required super.value, super.isLocked});
}
