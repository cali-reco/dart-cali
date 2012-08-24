/**
 * Represents a circle. (solid, dashed or bold)
 */
class Circle extends Shape {
    double radius;
    Point center;
    List<Point> _points;

	/**
	 * In this constructor we define all the features that are used to identify circles.
	 * @param rotated tells if the shapes are rotated or not
	 */
    Circle ([bool rotated]) 
        :   super("Circle", rotated),
            center = new Point(), 
            _points = new List<Point>(4) {
        _features = new Features([
            [Evaluate.Pch2_Ach, 12.5, 12.5, 13.2, 13.5],
            [Evaluate.Hollowness, 0.0, 0.0, 0.0, 0.0]
          ]);
    }
    


    setUp(Scribble sc) {
        this.scribble = sc;
        _points = scribble.boundingBox;

        var d1 = Math.sqrt(
            Math.pow(_points[0].x-_points[1].x,2) + 
            Math.pow(_points[0].y-_points[1].y,2));

        var d2 = Math.sqrt(
            Math.pow(_points[2].x-_points[1].x,2) + 
            Math.pow(_points[2].y-_points[1].y,2));
        
        radius = ((d1+d2)/2/2).floor();
        
        center = new Point(
            x: (_points[0].x + d2/2).floor(),
            y: (_points[0].y + d1/2).floor()
        );
    }
}
