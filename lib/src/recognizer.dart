class Recognizer {
  List shapes;
  num _alfaCut;
  
  /**
   * Constructor 
   * @param rotated Looks like this doesn't do anything
   * @param alfaCut If the probability of a shape is below this 
   * threshold, it will not be returned
   */
  Recognizer ([bool rotated = true, num alfaCut = 0])
          :   shapes = [];

  addShape(Shape shape) => shapes.add(shape);

  addAllShapes([bool rotated = true] ) {
      //  Commands 
      //_shapesList.add(new Delete());
      //_shapesList.add(new CIWavyLine());
      //_shapesList.add(new CICopy());
      //_shapesList.add(new CIMove());
      //_shapesList.add(new CICross());
      
      // Shapes 
      //_shapesList.add(new Line(rotated));
      //_shapesList.add(new Triangle(rotated));
      //_shapesList.add(new Rectangle(rotated));
      //_shapesList.add(new Circle(rotated));
      //_shapesList.add(new CIEllipse(rotated));
      //_shapesList.add(new CIDiamond(rotated));
      //_shapesList.add(new CIArrow(rotated));


  }
  
  /**
   * Identifies shapes based on a scribble. It starts by looking
   * for global geometric features and then for local features
   * 
   * Notes: If the application wants to manipulate the gestures returned as new
   * entities, it must clone them, because the gestures return by the
   *        recognizer are always the same. (The gestures returned are the ones
   *        created in the recognizer constructor)
   * 
   * @param sc A scribble
   * @return A list of plausible shapes ordered by degree of certainty.
   *
   */
  List recognize(Scribble scribble) {
      double val, val2;
      
      shapes.forEach((s) => s.resetDom());

      if (scribble.scribbleLength < 2) {
          return [new Tap.fromScribble(scribble)];
      }

      var ordered = new OrderedCollection();
      shapes.forEach((shape) {
          val = shape.evalGlobalFeatures(scribble);
          print("${shape.name} -> $val");
          if (val > _alfaCut) {
              val2 = shape.evalLocalFeatures(scribble, _shapes);
              if (val2 < val) {
                  val = val2;
              }  
              if (val > _alfaCut) {
                  ordered.insert(shape, 1 - val);
              }
          }
      });
      
      
      // Get only the shapes
      var result = ordered.toList();

      if (result.isEmpty()) {
          result.add(new Unknown.from(scribble));
      }
      
      return result;
  }
}