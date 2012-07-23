class OrderedEntry {
	var orderVal;
	var element;
	OrderedEntry(this.element, this.orderVal);

	bool equals(other) => element == other.element;
}

class OrderedCollection {
	List collection;
    bool repeated;

	OrderedCollection([this.repeated = true]) : collection = new List();

    bool contains(el) => collection.indexOf(el) != -1;

    insert(el, orderVal) {
        if (!repeated && this.contains(el)) {
            return get(el);
        }
        collection.add(new OrderedEntry(el, orderVal));
    }

    get(el) {
    	collection.forEach((e) {
    		if (e.element == el) {
    			return e.element;
    		}
    	});
    	return null;
    }

    List toList() {

		// Order by orderVal    
	    collection.sort( (a, b) {
            if (a.orderVal < b.orderVal) { return -1; }
            if (a.orderVal == b.orderVal) {return 0; }
            return 1;
        });

	    // Get only the elements
	    return collection.map((e) => e.element);
    }
}