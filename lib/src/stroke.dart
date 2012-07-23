class Stroke implements List<Point> {
	num strokeLength = 0;
	num drawingSpeed = 0;
	
	List<Point> _points;

	Stroke() : _points = new List<Point>();

	/** Creates a stroke from a list of points or a list of [x, y] */
	Stroke.from(List pts) : _points = new List<Point>() {
		pts.forEach( (pt) {
			if (pt is! Point) {
				pt = new Point(pt[0], pt[1]);
			}
			add(pt);
		});
	}

	void add(Point pt, [num time = 0]){
		if (length > 1) {
			strokeLength += Math.sqrt(Math.pow(last().x - pt.x,2) + Math.pow(last().y - pt.y,2));
		} 
		_points.add(pt);
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

	// delegates for List
	Point operator [](int index) => _points[index];
	void operator []=(int index, Point c) { _points[index] = c; }
	Point last() => _points.last();
	List<Point> getRange(int start, int length) => _points.getRange(start, length);

	
}