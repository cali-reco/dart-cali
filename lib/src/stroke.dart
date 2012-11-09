part of cali;

class Stroke extends ListWrapper<Point> {
	num strokeLength = 0;
	num drawingSpeed = 0;
	
	Stroke() : super();

	/** Creates a stroke from a list of points or a list of [x, y] */
	Stroke.from(List pts) : super() {
		pts.forEach( (pt) {
			if (pt is! Point) {
				pt = new Point(pt[0], pt[1]);
			}
			add(pt);
		});
	}

	void add(Point pt, [num time = 0]){
    if (length > 0) {
      strokeLength += Math.sqrt(Math.pow(last.x - pt.x,2) + Math.pow(last.y - pt.y,2));
    } 
		super.add(pt);
	}

	
}