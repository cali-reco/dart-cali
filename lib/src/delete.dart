part of cali;

class Delete extends Command {

  Point _point;

  Delete(): super("Delete") {

    _point = new Point(0.0, 0.0);

    _features = new Features([
      [Evaluate.Her_Wer,0.06, 0.08, 1.0, 1.0],
      [Evaluate.Tl_Pch, 1.5, 1.9],
      [Evaluate.Hollowness, 0.0, 3.0],
      [Evaluate.Ns, 1.0, 1.0, 1.0, 1.0]
    ]);
  }


  setUp(scribble) {
    _point = scribble.startingPoint;
    _dom = 1;
    scribble = scribble;
  }
}
