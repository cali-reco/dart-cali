class FuzzyNode {
    FuzzySet fuzzySet;
    Evaluate.EvaluationFn evaluationFn;
    
    FuzzyNode (this.fuzzySet, this.evaluationFn);
    
    /**
     * Computes the degree of membership for the current scribble,
     * using the fuzzyset and the function feature of the FuzzyNode.
     * @param sc a scribble
     * @return the value of the degree of membership
     */    
    num degOfMember(Scribble sc) {
        if (evaluationFn != null) {
            var d = evaluationFn(sc);
            if (fuzzySet!=null) {
                return fuzzySet.degOfMember(d);
            } 
        }
        return 0;
    }
}

/**
 * Linear representation of Fuzzy Sets.
 * A fuzzy set is represented by four values as we can see in the
 * next figure.
 * 
 *
 *
 *   N(u)
 *    |
 *  1 +            .+---+.                    a - wa <= a <= b <= b + wb
 *    |           /       \
 *  0 +----------+--+---+--+----------> u     0 <= N(u) <= 1 for all u
 *               ^  a   b  ^
 *               |         |                  wa >= 0, wb >= 0
 *             a - wa      b + wb
 *
 */
class FuzzySet {
    num a, b, wa, wb;

    FuzzySet(this.a, this.b, this.wa, this.wb);

    num degOfMember(num value) {
        if ((value < (a - wa)) || (value > (b + wb)) )
            return 0;
        if (value >= a && value <= b)
            return 1;
        if (value > b && (value <= b + wb))
            return 1.0 - (value - b) / wb;
        if (value < a && (value >= a - wa))
            return 1.0 + (value - a) / wa;
        
        return 0.0;
    }
}