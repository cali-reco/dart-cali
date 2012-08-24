class Triangle extends Shape {
	List<Point> _points;
	
	Triangle([bool rotated = true])
		:	super("Triangle",rotated),
			_points = new List<Point>(3)
			{
		  this._features = new Features([ 
		                            [Evaluate.Alt_Ach, 0.67, 0.77, 1, 1],
		                            [Evaluate.Plt_Pch, 0.95, 0.98, 1, 1],
		                            [Evaluate.Hollowness, 0, 0, 1, 1],
		                            [Evaluate.Pch_Per, 0.78, 0.8, 0.89, 0.945], // Not Lines Dashed
		                            [Evaluate.Alt_Alq, 0.81, 0.87, 1, 1]       // Not Copy
		                            ]);
		}
	
	setUp(Scribble sc) {
		this.scribble = sc;
		_points = sc.largestTriangle.points;
	}
		
	Point operator [](int index) => _points[index];
}
