class Polygon implements List<Point> {
    num _area = null;
    num _perim = null;

    List<Point> _points;

    Polygon([List<Point> points]) {
        if (points == null) {
            _points = new List<Point>();
        } else {
            _points = points;
        }
    }

    toString() => Strings.join(map((pt) => pt.toString()), ",");
    
    /*----------------------------------------------------------------------------+
    | Description: Computes the area of the polygon, using a general algorithm.
    | Output: the area
    +----------------------------------------------------------------------------*/
    num get area() {
      if (_area == null) {
        _area = 0;
    		if (length < 3) {
        		return _area;
    		}

    		for (int i = 0; i < length - 1; i++) {
	    	    _area += this[i].x * this[i+1].y - this[i+1].x * this[i].y;
    		}
	    	
	    	_area /= 2;
	    	
      }
      return _area.abs();
    }

    /*----------------------------------------------------------------------------+
    | Description: Computes the perimeter of the polygon, using a general algorithm.
    | Output: the perimeter
    +----------------------------------------------------------------------------*/
    num get perimeter() {
        if (_perim == null) {
          this._perim = 0.0;
            for (int i = 0; i < length - 1; i++) {
                _perim += Helper.distance(this[i], this[i+1]);
            }	
            
            if (length < 3) {
                _perim *= 2;
            }
        }
        return _perim;
    }

    // delegates for Collection
    Iterator<Point> iterator() => _points.iterator();
    bool isEmpty() => _points.isEmpty();
    void forEach(void f(Point c)) => _points.forEach(f);
    Collection map(f(Point c)) => _points.map(f);
    Collection<Point> filter(bool f(Point c)) => _points.filter(f);
    bool every(bool f(Point c)) => _points.every(f);
    bool some(bool f(Point c)) => _points.some(f);
    int get length() => _points.length;
    Dynamic reduce(Dynamic initialValue,
                   Dynamic combine(Dynamic previousValue, Point element)) => _points.reduce(initialValue, combine);

    // delegates for List
    void add(Point c) => _points.add(c);
    void addAll(List<Point> pts) => pts.forEach((pt) => add(pt));
    Point operator [](int index) => _points[index];
    void operator []=(int index, Point c) { _points[index] = c; }
    Point last() => _points.last();
    List<Point> getRange(int start, int length) => _points.getRange(start, length);
    Point removeLast() => _points.removeLast();
    List<Point> get points => _points;
}