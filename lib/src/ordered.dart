part of cali;

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

    bool containsOrder(val) => getOrderVal(val) != null;

    insert(el, orderVal) {
        if (!repeated && this.containsOrder(orderVal)) {
            return get(el);
        }
        collection.add(new OrderedEntry(el, orderVal));
    }

    get(order) {
      for (var e in collection){
    		if (e.orderVal == order) {
    			return e.element;
    		}
      }
    	return null;
    }

    getOrderVal(val) {
      for (var e in collection){
        if (e.orderVal == val) {
          return e.orderVal;
        }
      }
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
	    return collection.map((e) => e.element).toList();
    }
}