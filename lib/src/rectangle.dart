part of cali;

class Rectangle extends Shape {

    List<Point> _points;

    Rectangle([bool rotated = true]) 
        :   super("Rectangle",rotated),
            _points = new List<Point>(4) {

        if (rotated) {
            _features = new Features([
                [Evaluate.Ach_Aer, 0.75, 0.85, 1, 1], // separate from diamonds
                [Evaluate.Alq_Aer, 0.72, 0.78, 1, 1],
                [Evaluate.Hollowness, 0, 0, 1, 1]
            ]);
        }
        else {
            _features = new Features([
                [Evaluate.Ach_Abb, 0.8, 0.83, 1, 1],
                [Evaluate.Pch_Pbb, 0.87, 0.9, 1, 1],
                [Evaluate.Alt_Abb, 0.45, 0.47, 0.5, 0.52]//,
                    //&CIEvaluate::scLen_Pch, 0, 0, 1.5, 1.7
            ]);
        }
    }
    
    Point getPoint(int i) { return _points[i];}


    setUp(Scribble sc) {
        _points = sc.enclosingRect.points;
    }

}
