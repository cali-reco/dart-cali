/**
 * This class represents the features that will classify a gesture (shape/command).
 * Notes: It works as a way to simplify the definition of features for each gesture.
 */
class Features {
	List _nodeList;

    /** nodes = [fn, awa, a, b = Number.MAX_VALUE, bwb = Number.MAX_VALUE]* */
    Features(List nodes) {
        _nodeList = nodes.map((n) {
            var idx = 0;
            var fn = n[idx++],
                awa = n[idx++],
                a = n[idx++],
                b = (idx  < n.length)? n[idx++] : double.INFINITY,
                bwb = (idx < n.length)? n[idx] : double.INFINITY,
                wb = (b == double.INFINITY)? double.INFINITY : bwb-b;
            var fuzzySet = new FuzzySet(a, b, a-awa, wb);
            return new FuzzyNode(fuzzySet, fn);
        });
    }

    num call(Scribble scribble) {
        if (_nodeList == null) { return; }
        var dom = 1;
        for (var i = 0; i < _nodeList.length; i++) {
          FuzzyNode node = _nodeList[i];
          var tmp = node.degOfMember(scribble);
          if (tmp < dom) {
              dom = tmp;
          }
          if (dom == 0) {
              break;
          }
        }
        return dom;
    }
}