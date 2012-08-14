#library("helper");

distance(p1, p2) => Math.sqrt( Math.pow(p2.x-p1.x,2) + Math.pow(p2.y-p1.y,2) );

triangleArea(p1, p2, p3) {
	var area = p1.x * p2.y - p2.x * p1.y;
	area += p2.x * p3.y - p3.x * p2.y;
	area += p3.x * p1.y - p1.x * p3.y;
	return (area/2).abs();
}

theta(p,q) {
	var dx = q.x - p.x,
		ax = dx.abs(),
		dy = q.y - p.y,
		ay = dy.abs();
	
	var t = (ax + ay == 0)? 0 :  dy / (ax + ay);
	
	if (dx < 0) {
		t = 2 - t;
	} else if (dy < 0) { 
		t = 4 + t;
	}

	return t*90;
}

left(a, b, c) =>
	(a.x * b.y - a.y * b.x + a.y * c.x - a.x * c.y + b.x * c.y - c.x * b.y) > 0;

cross(a, b) {
    var dx1 = a.end.x - a.start.x,
    	dx2 = b.end.x - b.start.x,
    	dy1 = a.end.y - a.start.y,
    	dy2 = b.end.y - b.start.y;
    return dx1 * dy2 - dy1 * dx2;
}

dot(a, b) {
    var dx1 = a.end.x - a.start.x,
    	dx2 = b.end.x - b.start.x,
    	dy1 = a.end.y - a.start.y,
    	dy2 = b.end.y - b.start.y;
    return dx1 * dx2 + dy1 * dy2;
}

angle(a, b) {
	if ((a is Vector) && (b is Vector)) {
		return Math.atan2(cross(a, b), dot(a, b));
	} else { 
		return Math.atan2(b.y - a.y, b.x - a.x);
	}
}

/** Returns point on line (p1, p2) which is closer to p3 */
closest(p1, p2, p3) {
	
	var d = p2.x - p1.x;
	
	if (d == 0)
		return new Point(p1.x, p3.y);  
	
	if (p1 == p3)
		return p3; 
	        
	if (p2 == p3)
		return p3;
	        
	var m = (p2.y - p1.y) / d;
	
	if (m == 0)
		return new Point(p3.x, p1.y); 

	var b1 = p2.y - m * p2.x,
		b2 = p3.y + 1/m * p3.x,
		x = (b2 - b1) / (m + 1/m),
		y = m * x + b1;
	
	return new Point(x.round(), y.round());
}

quadArea(p1, p2, p3, p4) {
	var area = p1.x * p2.y - p2.x * p1.y;
	area += p2.x * p3.y - p3.x * p2.y;
	area += p3.x * p4.y - p4.x * p3.y;
	area += p4.x * p1.y - p1.x * p4.y;
	
	return (area/2).abs();
}
