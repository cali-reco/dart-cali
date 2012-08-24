class Unknown extends Shape {
	
	Unknown.from(Scribble sc) : super("Unknown") { 
		setUp(sc);
	}
	

	setUp(Scribble scribble) {
		this.scribble = scribble;
		_dashed = false;
		_bold = false;
		_open = false;
		_dom = 1;
		
		if (this._dashFeature.call(scribble) != 0.0) {
		  this._dashed = true;
		}
		else if (this._openFeature != null) {
			if (this._openFeature.call(scribble) != 0.0) {
			  this._open = true;
			}
			else {
				if (this._boldFeature.call(scribble) != 0.0) {
				  this._bold = true;
				}
			}
		}
	}
}

