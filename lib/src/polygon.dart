part of cali;

class Polygon extends ListWrapper<Point> {
    num _area = null;
    num _perim = null;

    Polygon([List<Point> points]) : super(points);

    toString() => Strings.join(map((pt) => pt.toString()), ",");
    
    /*----------------------------------------------------------------------------+
    | Description: Computes the area of the polygon, using a general algorithm.
    | Output: the area
    +----------------------------------------------------------------------------*/
    num get area {
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
    num get perimeter {
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
}