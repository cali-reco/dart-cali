part of cali;

class Line extends Shape {

	List<Point> _points;

	Line([bool rotated = true])
	 : super("Line", rotated) {
		_normalFeature = new Features([[Evaluate.Tl_Pch, 0.4, 0.45]]);
		_dashFeature = new Features([
			[Evaluate.Tl_Pch, 0, 0, 0.4, 0.45],
			[Evaluate.Pch_Ns_Tl, 5, 10]
		]);
		_features = new Features([[Evaluate.Her_Wer, 0, 0, 0.06, 0.08]]);
	}

    Point getPoint(int i) =>  _points[i];

	/**
	 * Computes the points of the recognized line
	 */
	setUp(Scribble sc) {
		this.scribble = sc;
		_points = [];
		_points.add(sc.enclosingRect[0]);
		_points.add(sc.enclosingRect[2]);

	}


}