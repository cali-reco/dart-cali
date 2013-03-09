part of cali;

/**
 * Base class for all gestures, shapes and commands.
 */
abstract class Gesture{
    Scribble scribble;
    Features _features;
    num _dom = 0.0;
    Gesture _prevGesture = null;
    String name;

    Gesture([this.name]);

    num evalGlobalFeatures(Scribble sc);

    num evalLocalFeatures(Scribble sc, List shapes);

    void resetDom() { _dom = 0.0; }
}




