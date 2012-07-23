class Unknown extends Shape {
	
	Unknown.from(Scribble sc) : super("Unknown") { 
		setUp(sc);
	}
	

	setUp(Scribble scribble) {
		this.scribble = sc;
		_dashed = false;
		_bold = false;
		_open = false;
		_dom = 1;
		
		if (_dashFeature.evaluate(sc) != 0.0) {
			_dashed = true;
		}
		else if (_openFeature != null) {
			if (_openFeature.evaluate(sc) != 0.0) {
				_open = true;
			}
			else {
				if (_boldFeature.evaluate(sc) != 0.0) {
					_bold = true;
				}
			}
		}
	}
}

