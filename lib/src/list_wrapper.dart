part of cali;

class ListWrapper<T> implements List<T> {
  List<T> _list;

  ListWrapper([List<T> list]) {
    if (!?list || list == null) {
      list = [];
    }
    _list = list;
  }
  
  // delegates for Collection
  Iterator<T> iterator() => _list.iterator();
  bool get isEmpty => _list.isEmpty;
  void forEach(void f(T c)) => _list.forEach(f);
  Collection map(f(T c)) => _list.map(f);
  Collection<T> filter(bool f(T c)) => _list.filter(f);
  bool every(bool f(T c)) => _list.every(f);
  bool some(bool f(T c)) => _list.some(f);
  int get length => _list.length;
  bool contains(T c) => _list.contains(c);
  reduce(initialValue,
      combine(previousValue, T element)) => _list.reduce(initialValue, combine);

  // delegates for List
  void add(T c) { _list.add(c); }
  void addAll(List<T> pts) => pts.forEach((pt) => add(pt));
  T operator [](int index) => _list[index];
  void operator []=(int index, T c) { _list[index] = c; }
  T get last => _list.last;
  List<T> getRange(int start, int length) => _list.getRange(start, length);
  T removeLast() => _list.removeLast();
  List<T> get points => _list;
  void set length(int newLength) { _list.length = newLength; }
  void addLast(T value) {_list.addLast(value); }
  void sort([Comparator<T> compare = Comparable.compare]) { _list.sort(compare); }
  int indexOf(T element, [int start = 0]) => _list.indexOf(element, start);
  int lastIndexOf(T element, [int start]) => _list.lastIndexOf(element, start);
  void clear() { _list.clear(); }
  T removeAt(int index) => _list.removeAt(index);
  void setRange(int start, int length, List<T> from, [int startFrom]) { _list.setRange(start, length, from, startFrom); }
  void removeRange(int start, int length) { _list.removeRange(start, length); }
  void insertRange(int start, int length, [T initialValue]) { _list.insertRange(start, length, initialValue); }
}
