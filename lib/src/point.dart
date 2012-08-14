class Point {
	num x;
	num y;
	num time;

	Point([this.x = 0, this.y = 0, this.time = 0]);
	
	bool equals(other) {
		if (other == null) { return false; }
	    return (x == other.x && y == other.y);
	}
}

class Vector extends Point {
	Vector(num x, num y) : super(x,y);
}