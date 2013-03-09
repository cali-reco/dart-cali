part of cali;

abstract class ListWrapper<T> extends Collection<T> implements List<T> {
  List<T> _list;

  ListWrapper([List<T> list]) {
    if (!?list || list == null) {
      list = [];
    }
    _list = list;
  }

  Iterator<T> get iterator => _list.iterator;
  void add(T element) { _list.add(element); }
  void remove(Object element) { _list.remove(element); }

  T operator [](int index) => _list[index];
  void operator []=(int index, T value) { _list[index] = value; }

  T removeLast() { _list.removeLast(); }
}
