class Tap extends Command {
	Point _point;

	Tap.fromScribble(Scribble sc)
		:	super("Tap"),
			_point = sc.startingPoint {
		this.scribble = sc;
		_dom = 1;
	}
}
