class TestRecognizer {

  static void run(){

    test('Recognizes a Tap', () {
      var recognizer = new Recognizer();
    	var stroke = new Stroke.from([
        [0,0],[1,1]
      ]);
      
      var shapes = recognizer.recognize(new Scribble([stroke]));
      expect(1, equals(shapes.length));
      expect("Tap", equals(shapes[0].name));
    });
     
    
    test('Recognizes a Line', () {
      var recognizer = new Recognizer();
      recognizer.addShape(new Line());

      var stroke = new Stroke.from([
        [0,0], [50,50], [100,100], [150,150], [200,200]
      ]);
      
      var shapes = recognizer.recognize(new Scribble([stroke]));
      expect(shapes.length, equals(1));
      expect(shapes[0].name, equals("Line"));
    });

/*

  it "Recognizes a Circle", ->
    Circle = require("../src/circle").Circle

    recognizer = new Recognizer()
    recognizer.addShape new Circle()

    radius = 50
    pt = (ang) ->  [
      Math.round(radius*Math.cos(ang)), 
      Math.round(radius*Math.sin(ang)) ]
        
    stroke = (pt(ang) for ang in [0...2*Math.PI] by Math.PI/4)

    shapes = recognizer.recognize [stroke]
    expect(1).toEqual shapes.length, "wrong length"
    expect("Circle").toEqual shapes[0].name, "wrong type. Got a #{shapes[0].type}"

  it "Recognizes a Rectangle", ->
    Rectangle = require("../src/rectangle").Rectangle

    recognizer = new Recognizer()
    recognizer.addShape new Rectangle()

    stroke = [[-50,50], [50,50], [50,-50], [-50,-50]]

    shapes = recognizer.recognize [stroke]
    
    expect(1).toEqual shapes.length, "wrong length"
    expect("Rectangle").toEqual shapes[0].name, "wrong type. Got a #{shapes[0].type}"
    
    # Now add all shapes and test again
    recognizer.addAllShapes() 

    shapes = recognizer.recognize [stroke]
    
    expect(1).toEqual shapes.length, "wrong length"
    expect("Rectangle").toEqual shapes[0].name, "wrong type. Got a #{shapes[0].type}"
      
    });*/
  }
}