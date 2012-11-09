part of cali_tests;

class TestRecognizer {

  static void run(){

   group('Recognizer Tests', () {
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
     
      test('Recognizes a Circle', () {
        var recognizer = new Recognizer();
        recognizer.addShape(new Circle());
        
        num radius = 50;
        var pt = point(ang) => [ radius * Math.cos(ang), radius * Math.sin(ang)];
  
        List points = [];
        for (var i = 0; i <= 8; i++) {
          points.add(pt(i*Math.PI/4));
        }
        print(points.toString());
        var stroke = new Stroke.from(points);
        
        var shapes = recognizer.recognize(new Scribble([stroke]));
        expect(shapes.length, equals(1));
        expect(shapes[0].name, equals("Circle"));
      });
      
      test('Recognizes a Rectangle', () {
        var recognizer = new Recognizer();
        recognizer.addShape(new Rectangle());
        
        var stroke = new Stroke.from([
                                      [-50,50], [50,50], [50,-50], [-50,-50],[-50,50]
                                      ]);
        var shapes = recognizer.recognize(new Scribble([stroke]));
        expect(shapes.length, equals(1));
        expect(shapes[0].name, equals("Rectangle"));
      });
      
      test('Recognizes a Triangle', () {
        var recognizer = new Recognizer();
        recognizer.addShape(new Triangle());
        
        var stroke = new Stroke.from([
                                      [-50,50], [50,50], [-50,-50],[-50,50]
                                      ]);
        var shapes = recognizer.recognize(new Scribble([stroke]));
        expect(shapes.length, equals(1));
        expect(shapes[0].name, equals("Triangle"));
      });    
      
  /*
  
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
   });
  }
}