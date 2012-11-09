part of cali;

/**
 * Base class for all commands.
 */
abstract class Command extends Gesture {
	
	Command(String name) : super(name);
	
	num evalLocalFeatures(Scribble scribble, List _shapes) => 1; 
	
	num evalGlobalFeatures(Scribble sc) {
		_dom = _features.evaluate(sc);
		if (_dom > 0) {
			_this.scribble = sc;
		} else { 
			this.scribble = null;
		}
		return _dom;
	} 
}


