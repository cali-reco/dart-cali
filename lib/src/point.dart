class Point {
	num x;
	num y;
	num time;

	Point(this.x, this.y, [this.time]);
	
	bool equals(other) {
		if (other == null) { return false; }
	    return (x == other.x && y == other.y);
	}
}

class Vector extends Point {
	Vector(num x, num y) : super(x,y);
}