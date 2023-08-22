extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}

// This is a Dart extension on the Stream<List<T>> type.
// Extensions in Dart allow you to add new functionality to existing classes.
// In this case, the extension is adding a new method called filter to
// any instance of Stream<List<T>>.

// The filter method takes a function as an argument.
// This function should take an instance of T (the generic type of the list) and
// return a boolean. This function is used as a condition to filter the items in the list.

// The filter method returns a new stream.
// This stream is created by mapping over the items in the original stream.
// For each item (which is a list), it applies the where method.
// The where method returns a new iterable that contains all the items for
// which the provided function returns true.
// This iterable is then converted back into a list.

// So, in summary, this extension allows you to filter the items in the
// lists that are emitted by a Stream<List<T>>,
// based on a condition provided as a function.
// The result is a new stream that emits the filtered lists


// step by step with OpenAI
// 1: extension Filter<T> on Stream<List<T>> { ... }:
// This line defines a Dart extension named Filter for the Stream<List<T>> type.
// This means that you can use the filter method on any object that is a Stream<List<T>>.
// 2: Stream<List<T>> filter(bool Function(T) where) => ...:
// This line defines a new method called filter for the extended Stream<List<T>> type.
// This method takes a single argument,
// which is a boolean function where that accepts a T (the type of elements in the list)
// and returns a boolean value. The filter method returns a new Stream<List<T>>.
// 3: map((items) => items.where(where).toList()):
// Inside the filter method, it uses the map function to transform the original stream.
// For each element (which is a list of type List<T>) in the original stream,
// it performs the following operations:
// a. items.where(where): It applies the where function (provided as an argument to filter)
// to filter the elements of the list items. The where function determines which elements
// should be included in the filtered list.
// b. .toList(): It converts the filtered iterable produced by where into a list.
// This whole expression essentially filters each list in the stream
// based on the provided where function and converts the filtered result into a list
// Summary : So, when you use this extension on a Stream<List<T>>,
// you can chain the filter method to it, providing a custom filtering function.
// It will create a new stream that emits lists where each list contains only the
// elements that satisfy the filtering criteria specified by the where function.

// This is the more complicated example below

extension FilterNestedList<T> on Stream<List<List<T>>> {
  Stream<List<List<T>>> filter(bool Function(T) where) =>
      map((listOfLists) => listOfLists
          .map((list) => list.where(where).toList())
          .toList());
}
