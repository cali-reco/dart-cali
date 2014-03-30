part of cali;

class Point {
	double x;
	double y;
	num time;

	Point([this.x = 0.0, this.y = 0.0, this.time = 0]);

	toString() => "[$x, $y]";

	bool equals(other) {
		if (other == null) { return false; }
	    return (x == other.x && y == other.y);
	}
}

