#library("evaluate");

#import('helper.dart', prefix:'Helper');

typedef double EvaluationFn(scribble);

Tl_Pch(sc) => sc._len / sc.convexHull.perimeter;
Pch2_Ach(sc) => Math.pow(sc.convexHull.perimeter,2) / sc.convexHull.area;
Pch_Ns_Tl(sc) => sc.convexHull.perimeter/(sc.scribbleLength/sc.length);
Hollowness(sc) => sc.ptsInSmallTri;
Ns(sc) => sc.length;
Hm_Wbb(sc) {
    var pbb = sc.boundingBox;
    return ((pbb[0].x - pbb[1].x) / sc.hMovement()).abs();
}
Vm_Hbb(sc) {
    var pbb = sc.boundingBox;
    return abs((pbb[2].y - pbb[1].y) / sc.vMovement()).abs();
}
Hbb_Wbb(sc) {
    var pbb = sc.boundingBox().getPoints();
    
    var dw = pbb[1].x - pbb[0].x;
    var dh = pbb[2].y - pbb[1].y;

    if (dw == 0 || dh == 0)
        return 0;

    var tmp = (dh / dw).abs;
    if (tmp > 1)
        tmp = 1 / tmp;
    return tmp;
}
Her_Wer(sc) {
    var pbb = sc.enclosingRect;

    var dw = Helper.distance(pbb[2], pbb[1]);
    var dh = Helper.distance(pbb[1], pbb[0]);

    if (dw == 0 || dh == 0)
        return 0;

    var tmp = dh / dw;
    if (tmp > 1)
        tmp = 1 / tmp;
    return tmp;
}

// Area ratios
Alt_Ach(sc) => sc.largestTriangle.area / sc.convexHull.area;
Ach_Aer(sc) => sc.convexHull.area / sc.enclosingRect.area;
Alt_Aer(sc) => sc.largestTriangle.area / sc.enclosingRect.area;
Ach_Abb(sc) => sc.convexHull.area / sc.boundingBox.area;
Alt_Abb(sc) => sc.largestTriangle.area / sc.boundingBox.area;
Alq_Ach(sc) => sc.largestQuad.area / sc.convexHull.area;
Alq_Aer(sc) => sc.largestQuad.area / sc.enclosingRect.area;
Alt_Alq(sc) => sc.largestTriangle.area / sc.largestQuad.area;
    
// Perimeter ratios
Plt_Pch(sc) => sc.largestTriangle.perimeter / sc.convexHull.perimeter;
Pch_Per(sc) => sc.convexHull.perimeter / sc.enclosingRect.perimeter;
Plt_Per(sc) => sc.largestTriangle.perimeter / sc.enclosingRect.perimeter;
Pch_Pbb(sc) => sc.convexHull.perimeter / sc.boundingBox.perimeter;
Plt_Pbb(sc) => sc.largestTriangle.perimeter / sc.boundingBox.perimeter;
Plq_Pch(sc) => sc.largestQuad.perimeter / sc.convexHull.perimeter;
Plq_Per(sc) => sc.largestQuad.perimeter / sc.enclosingRect.perimeter;
Plt_Plq(sc) => sc.largestTriangle.perimeter / sc.largestQuad.perimeter;