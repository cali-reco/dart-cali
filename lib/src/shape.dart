part of cali;

abstract class Shape extends Gesture {
    Features _dashFeature; 
    Features _normalFeature;
    Features _openFeature;
    Features _boldFeature;
    bool _dashed = false;
    bool _bold = false;
    bool _open = false;
    bool _rotated;

    setUp(Scribble sc);   
    
    Shape (String name, [bool rotated = true])
        : this._rotated = rotated, 
          super(name),
          _normalFeature = new Features([
                [Evaluate.Tl_Pch, 0.83, 0.93]
            ]),
          _dashFeature = new Features([
                [Evaluate.Tl_Pch, 0.2, 0.3, 0.83, 0.93],
                [Evaluate.Pch_Ns_Tl, 5, 10]
          ]),
          _openFeature = new Features([
                [Evaluate.Tl_Pch, 0.2, 0.3, 0.83, 0.93]
          ]),
          _boldFeature =  new Features([
                [Evaluate.Tl_Pch, 1.5, 3]
          ]);
    
    
    num evalLocalFeatures(Scribble sc, List shapes) => 1; 
    
    bool get isDashed =>_dashed; 
    bool get isBold =>_bold; 
    bool get isOpen =>_open; 

    /*----------------------------------------------------------------------------+
     | Description: Computes the degree of membership for the scribble, taking
     |              into account the fuzzysets for the current shape.
     |              This evaluation is made based on geometric global features.
     | Input: A scribble
     | Output: degree of membership
     | Notes: This method is the same for all shapes.
     +----------------------------------------------------------------------------*/
    num evalGlobalFeatures(Scribble sc) {
        _dom = _features.call(sc);
        _dashed = false;
        _bold = false;
        _open = false;
        scribble = null;
        if (_dom!= 0.0) {
            setUp(sc);
            if (_normalFeature.call(sc)!=0.0) {
                if (_boldFeature.call(sc)!=0.0)
                    _bold = true;
            }
            else {
                _dom *= _dashFeature.call(sc);
                if (_dom!=0.0)
                    _dashed = true;
            }
        }
        return _dom;
    }
    
}