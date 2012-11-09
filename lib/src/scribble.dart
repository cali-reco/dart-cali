part of cali;

class Scribble extends ListWrapper<Stroke>{
    num _len = 0; // Scribble length
    num _totalSpeed = 0;
    
    Polygon _boundingBox;    // The points are order
    Polygon _convexHull;
    Polygon _largestTriangleOld;
    Polygon _enclosingRect;
    Polygon _largestQuadOld;
    Polygon _largestTriangle;
    Polygon _largestQuad;

    Scribble([List<Stroke> strokes] ) 
        : super([])  {
        if (?strokes) {
          strokes.forEach(add);
        }
    }

    num get avgSpeed => _totalSpeed / length;

    add(Stroke stroke) {
        _len += stroke.strokeLength;
        _totalSpeed += stroke.drawingSpeed;
        super.add(stroke);
    }

    num get scribbleLength => _len;

    Stroke removeLast() {
        var strk = super.removeLast();

        _len -= strk.strokeLength;
        _totalSpeed -= strk.drawingSpeed;

        _boundingBox = null;
        _convexHull = null;
        _largestTriangle = null;
        _largestTriangleOld = null;
        _largestQuadOld = null;
        _largestQuad = null;
        _enclosingRect = null;

        return strk;
    }

    /*----------------------------------------------------------------------------+
      | Description: Computes the correct timeout, based on the drawing speed.
      | Output: Timeout, in milliseconds
      | Notes: Actually it returns a constant value, because the formula used to
      |        the "best" timeout is not very good. We are searching for a better one :-)
      +----------------------------------------------------------------------------*/
    int get timeOut {
        return 550; // to delete <<<<<<<<<<
        /*
           double avs = getAvgSpeed();
           if (avs >= 900)
           return TIMEOUT_BASE + 0;
           else if (avs <= 100)
           return TIMEOUT_BASE + 400;
           else // y=-0.5*x+450
           return (int) (TIMEOUT_BASE + (-0.5*avs + 450));
           */
    }

//	------------- Polygons

    /**
      * Description: Computes the convex hull of the scribble, using the Graham's
      *           algorithm. After the computation of the convex hull, we perform
      *              a simple filtration to eliminate points that are very close.
      * Output: A polygon that is the convex hull.
      *----------------------------------------------------------------------------*/
    Polygon get convexHull {

        // Order all scribble points by angle.
        List ordPoints(Point min) {
            var ordedPoints = new OrderedCollection(false);
            ordedPoints.insert(min, 0);
    
            this.forEach((stroke) {
                stroke.forEach((point) {
                    var ang = Helper.theta(min, point);
                    if (ordedPoints.containsOrder(ang)) {
                        // there is another point with the same angle
                        var ptr = ordedPoints.get(ang);

                        // so we compute the distance and save the big one.
                        if (Helper.distance(min, point) > Helper.distance(min,ptr)) {
                            ptr.x = point.x;
                            ptr.y = point.y;
                        }
                    } else {
                        ordedPoints.insert(point, ang);
                    }
                });
            });

            return ordedPoints.toList();
        }

        // Filter based on distance
        filter(Polygon polygon) {
            var cvxhull = new Polygon();

            for (var i = 0; i < polygon.length; i++) {
                var point = polygon[i];
                var prev;

                if (i == 0) {
                    prev = point;
                    continue;
                }

                if (Helper.distance(point, prev) > 5) {
                    cvxhull.add(point);
                    prev = point;
                } else if (i == polygon.length-1) {
                    cvxhull.add(point);
                }
            }

            return cvxhull;
        }

        if (_convexHull == null) {
            _convexHull = new Polygon();
            var ordedPoints = ordPoints(findLowest()),
                np = ordedPoints.length;

            _convexHull.addAll([
                ordedPoints[np-1],
                ordedPoints[0]]);

            // try to push all but the first point
            var nc  = _convexHull.length;
           
            for (var i = 1; i < np; i++) {
                var pt = ordedPoints[i];
                if (Helper.left(
                        _convexHull[_convexHull.length-2], 
                        _convexHull[_convexHull.length-1], 
                        pt)) {
                    _convexHull.add(pt);
                    nc++;
                } else { 
                    _convexHull.removeLast();
                    nc--;
                }
            }

            //_convexHull = filter(@_convexHull) # reduce the number of points
        }
        return _convexHull;
    }


    /**---------------------------------------------------------------------------+
      * Description: Computes the bounding box of the convex hull.
      * Output: A polygon that is the bounding box.
      *----------------------------------------------------------------------------*/
    Polygon get boundingBox {
        if (_boundingBox == null) {
            var x1 = convexHull[0].x,
                y1 = convexHull[0].y,
                x2 = x1,
                y2 = y1;
      
            convexHull.forEach((point) {
                if (point.x < x1) { x1 = point.x; }      
                if (point.x > x2) { x2 = point.x; } 
                if (point.y < y1) { y1 = point.y; }  
                if (point.y > y2) { y2 = point.y; }  
            }); 
            
            // Tranfer the points to a polygon
            _boundingBox = new Polygon([
                new Point(x1, y1),
                new Point(x2, y1),
                new Point(x2, y2),
                new Point(x1, y2),
                new Point(x1, y1)
            ]);
        }
        return _boundingBox;
    }

    // Selects the point with the lowest y
    findLowest() {
    
        var min = this[0][0]; // gets the first point of the first stroke
        
        this.forEach((stroke) {
            stroke.forEach((point) {
                if ( (point.y < min.y) || (point.y == min.y && point.x > min.x) ) {
                    min = point;
                }
            });
        });

        return min;
    }

    /*--------------------------------------------------------------------------------+
    | Description: Computes the largest quadrangular that fits inside the convex hull
    | Output: A polygon that is the largest quadrangular.
    +---------------------------------------------------------------------------------*/


    Polygon get largestQuad {
        
      var pts = convexHull,
        np = convexHull.length;
  
      num ripa = 0, ripb = 0, ripc = 0; // indexes for rooted triangle
  
      if (_largestQuad == null) {
        if (np <= 5){
          _largestQuad = new Polygon();
          for(var i = 0; i < np; i++){  
            _largestQuad.add(pts[i]);
          }
          for (var i = np; i < 5; i++){ 
            _largestQuad.add(pts[0]);
          }
          return _largestQuad;
        }
    
      // computes one rooted triangle
        num ia = 0, area = 0, triArea = 0;
        for (num ib = 1; ib <= np-2; ib++){ // in [1..np-2]
          num ic;
          if (ib >= 2){
            ic = ib + 1;
          } else {
            ic = 2;
          }
          var res = compRootedTri (pts,ia, ib, ic,np);
          area = res[0];
          ic = res[1];
          if (area > triArea){
            triArea = area;
            ripa = ia;
            ripb = ib;
            ripc = ic; 
          }
        }
    
    
        // computes the rooted quadrilateral based on a rooted triangle
        num fipa = 0, fipb = 0, fipc = 0, fipd = 0, // indexes for final values
          id = 0, ib0 = 0, quadArea = 0, ic0 = 0;
    
        for (num ib = ripa + 1; ib <= ripb; ib++){ // ib in [ripa+1..ripb]
          if (ib == ripb){
            ic0 = ripb + 1;
          }
          else{
            ic0 = ripb;
          }
          for (num ic = ic0; ic <= ripc; ic++){ //ic in [ic0..ripc]
            if (ic == ripc){
              id = ripc + 1;
            }
            else{
              id = ripc;
            }
            var res = compRootedQuad(pts, ia, ib, ic, id, np);
            area = res[0];
            ic = res[1];
            if (area > quadArea){
              quadArea = area;
              fipa = ia;
              fipb = ib;
              fipc = ic;
              fipd = id;
            }
          }
        }
        
        // computes other quadrilaterals and choose the largest one
        num finalArea = quadArea,
        pf0 = fipa,
        pf1 = fipb,
        pf2 = fipc,
        pf3 = fipd;
        ripa = fipa;
        ripb = fipb;
        ripc = fipc;
        num ripd = fipd;
    
        for (num ia = ripa+1; ia <= ripb; ia++){ //ia in [ripa+1..ripb]
          if (ia == ripb){
            ib0 = ripb + 1;
          }
          else {
            ib0 = ripb;
          }
          quadArea = 0;
          area = 0;
          num ic0;
          for (var ib = ib0; ib <= ripc; ib++){ // ib in [ib0..ripc]
            if (ib == ripc){
              ic0 = ripc + 1;
            }
            else{ 
              ic0 = ripc;
            }
            for (num ic = ic0; ic <= ripd; ic++){ //ic in [ic0..ripd]
              if (ic == ripd){
                id = ripd + 1;
              }
              else{
                id = ripd;   
              }
              var res = compRootedQuad(pts, ia, ib, ic, id, np);
              area = res[0];
              id = res[1];
              if (area > quadArea){
                quadArea = area;
                fipa = ia;
                fipb = ib;
                fipc = ic;
                fipd = id;
              }
            }
          }
          if (quadArea > finalArea){
            finalArea = quadArea;
            pf0 = fipa;
            pf1 = fipb;
            pf2 = fipc;
            pf3 = fipd;
          }
        }
        //Tranfer the points to a polygon
        _largestQuad = new Polygon();
        _largestQuad.add(convexHull[pf0]);
        _largestQuad.add(convexHull[pf1]);
        _largestQuad.add(convexHull[pf2]);
        _largestQuad.add(convexHull[pf3]);
        _largestQuad.add(convexHull[pf0]);
      }
      return _largestQuad;
    } 
      
    List compRootedQuad(pts,ripa,ripb,ripc,ripd,np){
      num trigArea = 0;
      // computes one rooted triangle        
      var pa = pts[ripa],
        pb = pts[ripb],
        pc = pts[ripc]; 
      num area;
      num new_ripd = ripd;
      for (num id = ripd; id < np - 1; id++){ // id in [ripd...np - 1]
        var pd = pts[id];
        if ((area = Helper.quadArea(pa,pb,pc,pd)) > trigArea){
          new_ripd = id;
          trigArea = area;
        }
        else {
          break;
        }
      }
      return [trigArea, new_ripd];
    }
    
    List compRootedTri(List pts, int ripa, int ripb, int ripc,int np) {
      double trigArea = 0.0;

      //  computes one rooted triangle        
      int ia = ripa,
          ib = ripb;

      for(var ic=ripc; ic < np - 1; ic++ ) {
        var pa = pts[ia],
            pb = pts[ib],
            pc = pts[ic];
        var area=Helper.triangleArea(pa, pb, pc);
        if( area > trigArea ) {
          ripc = ic;
          trigArea = area;
        } else {
          break;
        }
      }
      return [trigArea, ripc];
    }  
      
    /*----------------------------------------------------------------------------+
          | Description: Computes the largest triangle that fits inside the convex hull
          | Output: A polygon that is the largest triangle.
          | Notes: We used the algorithm described by J.E. Boyce and D.P. Dobkin.
          +----------------------------------------------------------------------------*/
    Polygon get largestTriangle { 

        if (_largestTriangle == null) {
          //var pts = convexHull,
          //  np = convexHull.length;
          int ia, ib, ic, i;
          int ripa = 0, ripb = 0, ripc = 0; // indexes of rooted triangle
          double area, triArea;

          int numPts = convexHull.length;
          List pts = _convexHull.points;

          if (numPts <= 3) {
              _largestTriangle = new Polygon();
              for (i=0; i < numPts; i++) {
                  _largestTriangle.add(pts[i]);
              }
              for (i= numPts; i < 4; i++) {
                  _largestTriangle.add(pts[0]);
              }
              return _largestTriangle;
          }

//				computes one rooted triangle with root in the first point of the convex hull
          ia = 0;
          area = 0.0;
          triArea = 0.0;
          for(ib=1; ib <= numPts-2; ib++) {
              if (ib >= 2) {
                  ic = ib + 1;
              }
              else {
                  ic = 2;
              }
              var res =  compRootedTri (pts, ia, ib, ic, numPts);
              area =  res[0];
              ic= res[1];

              if (area > triArea) {
                  triArea = area;
                  ripa = ia;
                  ripb = ib;
                  ripc = ic;
              }
          } // ripa, ripb and ripc are the indexes of the points of the rooted triangle


//				computes other triangles and choose the largest one
          double finalArea = triArea;
          int pf0, pf1, pf2;   // indexes of the final points
          int fipa=0, fipb=0, fipc=0;
          int ib0;
          pf0 = ripa;
          pf1 = ripb;
          pf2 = ripc;

          for(ia = ripa+1; ia <= ripb; ia++) {
              triArea = 0.0;
              if (ia == ripb) {
                  ib0 = ripb + 1;
              }
              else {
                  ib0 = ripb;
              }
              area = 0.0;
              for(ib = ib0; ib <= ripc; ib++) {
                  if (ib == ripc) {
                      ic = ripc + 1;
                  }
                  else {
                      ic = ripc;
                  }
                  var res = compRootedTri (pts, ia, ib, ic, numPts);
                  area =  res[0];
                  ic= res[1];

                  if (area > triArea) {
                      triArea = area;
                      fipa = ia;
                      fipb = ib;
                      fipc = ic;
                  }
              }
              if(triArea > finalArea) {
                  finalArea = triArea;
                  pf0 = fipa;
                  pf1 = fipb;
                  pf2 = fipc;
              }
          }

          // Tranfer the points to a polygon
          _largestTriangle = new Polygon();
          _largestTriangle.add(pts[pf0]);
          _largestTriangle.add(pts[pf1]);
          _largestTriangle.add(pts[pf2]);
          _largestTriangle.add(pts[pf0]);
        }
        return _largestTriangle;
    }

    /**
     * Computes the enclosing rectangle (rotated) that includes the
     * convex hull
     * @return A polygon that is a rotated rectangle.
     */
    Polygon get enclosingRect {
        if (_enclosingRect == null) {

            if (convexHull.length < 2) {  // is just a point
                _enclosingRect = new Polygon([
                    convexHull[0],
                    convexHull[0],
                    convexHull[0],
                    convexHull[0],
                    convexHull[0]]);
            }
            else if (convexHull.length < 3) {  // is a line with just two points
                _enclosingRect = new Polygon([
                    convexHull[0],
                    convexHull[1],
                    convexHull[1],
                    convexHull[0],
                    convexHull[0]]);
            }
            else {  // ok it's normal :-)
                var minx,maxx,miny,maxy,minxp,maxxp,minyp,maxyp,
                  min_area,p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y;
                for(int i=0; i < convexHull.length - 1; i++) {
                    
                    for(int a=0; a < convexHull.length; a++) { 

                        var v1 = new Helper.Vector(convexHull[i], convexHull[i+1]);
                        var v2 = new Helper.Vector(convexHull[i], convexHull[a]);
                        var ang = Helper.angle(v1, v2);

                        var dis = v2.length;
                        var xx = dis*Math.cos(ang);
                        var yy = dis*Math.sin(ang);
                        
                        if(a==0) {
                            minx=maxx=xx;
                            miny=maxy=yy;
                            minxp=maxxp=minyp=maxyp=0;
                        }
                        if(xx<minx) {
                            minxp=a;
                            minx=xx;
                        }
                        if(xx>maxx) {
                            maxxp=a;
                            maxx=xx;
                        }
                        if(yy<miny) {
                            minyp=a;
                            miny=yy;
                        }
                        if(yy>maxy) {
                            maxyp=a;
                            maxy=yy;
                        }

                        //delete v1;
                        //delete v2;
                    }
                    var p1 = Helper.closest(
                        convexHull[i],
                        convexHull[i+1],
                        convexHull[minxp]);
                    var p2 = Helper.closest(
                        convexHull[i],
                        convexHull[i+1],
                        convexHull[maxxp]);
                    var ch = convexHull;
                    var paux = new Point(convexHull[i].x + 100, convexHull[i].y);
                    var v3= new Helper.Vector(convexHull[i], paux);
                    var v4= new Helper.Vector(convexHull[i], convexHull[i+1]);
                    var ang = Helper.angle(v3, v4);
                    num M_PI_2 = Math.PI / 2;
                    var paux1 = new Point(p1.x+100*Math.cos(ang+M_PI_2), p1.y+100*Math.sin(ang+M_PI_2));
                    var paux2 = new Point(p2.x+100*Math.cos(ang+M_PI_2), p2.y+100*Math.sin(ang+M_PI_2));

                    var p3 = Helper.closest(p2,paux2, convexHull[maxyp]);
                    var p4 = Helper.closest(p1,paux1, convexHull[maxyp]);

                    num area = Helper.quadArea(p1,p2,p3,p4);

                    if ((i==0)||(area < min_area))
                    {
                        min_area = area;
                        p1x=p1.x;
                        p1y=p1.y;
                        p2x=p2.x;
                        p2y=p2.y;
                        p3x=p3.x;
                        p3y=p3.y;
                        p4x=p4.x;
                        p4y=p4.y;
                    }

                }
                _enclosingRect = new Polygon([
                    new Point(p1x, p1y),
                    new Point(p2x, p2y),
                    new Point(p3x, p3y),
                    new Point(p4x, p4y),
                    new Point(p1x, p1y)]);
            }
        }

        return _enclosingRect;
    }

    Point get startingPoint => this[0][0];
    Point get endingPoint => last.last;


    /*----------------------------------------------------------------------------+
          | Description: Computes the number of points inside a small triangle, computed
          |              from the largest triangle.
          | Output: Number of points inside.
          | Notes: Some of the lines commented were used to return a list with the points
          |        inside.
          +----------------------------------------------------------------------------*/
    int get ptsInSmallTri {
        int empty = 0; // number of points inside the triangle

        var tri = smallTriangle;
        
        var m = new List<double>(3);
        var x = new List<double>(3);

        double dx, dy;
        
        for(var i = 0; i < 3; i++) { 
            dx = tri[i].x - tri[(i + 1) % 3].x;
            if (dx == 0) {
                m[i] = double.INFINITY;
                continue;
            }
            dy = tri[i].y - tri[(i + 1) % 3].y;
            m[i] = dy / dx;
        }

        for (var stroke in this){
          for (var cp in stroke){
                var inter = 0;
                if (cp.x >= tri[0].x && cp.x >= tri[1].x && cp.x >= tri[2].x) {
                    continue;
                }
                else if (cp.x <= tri[0].x && cp.x <= tri[1].x && cp.x <= tri[2].x) {
                    continue;
                }
                else if (cp.y >= tri[0].y && cp.y >= tri[1].y && cp.y >= tri[2].y) {
                    continue;
                }
                else if (cp.y <= tri[0].y && cp.y <= tri[1].y && cp.y <= tri[2].y) {
                    continue;
                }

                for (var i=0; i<3; i++) {
                    if (m[i] == 0) {
                        continue;
                    }
                    if (m[i] >= double.INFINITY) {
                        x[i] = tri[i].x;
                        if (x[i] >= cp.x) {
                            inter++;
                        }
                    } else {
                        x[i] = (cp.y - tri[i].y + m[i]*tri[i].x)/m[i];
                        if (x[i] >= cp.x && (x[i] < ((tri[i].x > tri[(i+1) %3].x) ? tri[i].x : tri[(i+1) %3].x))) {
                            inter++;
                        }

                    }
                }
                if ((inter%2)!=0) {
                    empty++;
                }
                
            }
        }

        return empty;
    }


    /*----------------------------------------------------------------------------+
    | Description: Return the number of points of the scribble
    +----------------------------------------------------------------------------*/
    int get numPoints {
        int nPoints;
        this.forEach((stroke) => nPoints += stroke.length );
        return nPoints;
    }


    
   
    /*----------------------------------------------------------------------------+
          | Description: Computes a small triangle that is 60% of the largest triangle.
          | Output: A polygon
          | Notes:
          +----------------------------------------------------------------------------*/
    Polygon get smallTriangle {
        var tri = largestTriangle,
            p1 = tri[0],
            p2 = tri[1],
            p3 = tri[2],
            m1 = new Point( p3.x + (p1.x - p3.x)/2,
                            p3.y + (p1.y - p3.y)/2),
            m2 = new Point( p1.x + (p2.x - p1.x)/2,
                            p1.y + (p2.y - p1.y)/2),
            m3 = new Point( p2.x + (p3.x - p2.x)/2,
                            p2.y + (p3.y - p2.y)/2),
            t1 = new Point( m3.x + (p1.x - m3.x)*0.6,
                            m3.y + (p1.y - m3.y)*0.6),
            t2 = new Point( m1.x + (p2.x - m1.x)*0.6,
                            m1.y + (p2.y - m1.y)*0.6),
            t3 = new Point( m2.x + (p3.x - m2.x)*0.6,
                            m2.y + (p3.y - m2.y)*0.6);

        return new Polygon([t1, t2, t3, t1]);
    }

}
	
