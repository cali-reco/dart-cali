part of cali;

abstract class ListWrapper<T> extends Iterable<T> with ListMixin<T> {
  List<T> _list;

  ListWrapper([List<T> list]) {
    if (list == null) {
      list = [];
    }
    _list = list;
  }

  Iterator<T> get iterator => _list.iterator;
  void add(T element) { _list.add(element); }
  bool remove(Object element) { _list.remove(element); }

  T operator [](int index) => _list[index];
  void operator []=(int index, T value) { _list[index] = value; }

  T removeLast() { _list.removeLast(); }
  int get length => _list.length;
  void set length(int n) { _list.length = n;}
  T get last => _list.last;
}