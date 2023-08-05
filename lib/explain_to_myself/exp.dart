// FutureBuilder
// FutureBuilder is used to build a widget tree based on the result of a single asynchronous
// operation (i.e., a Future). It takes a Future and a builder function as input, and builds
// a widget tree based on the state of the Future. The builder function is called with an
// AsyncSnapshot object, which contains the current state of the Future
// (e.g., whether it is still loading, whether it has completed successfully,
// or whether it has encountered an error). You can use the AsyncSnapshot object to
// build different UI components based on the current state of the Future.
// The builder function passed to FutureBuilder is called each time the state of the Future changes.
// This means that you can use FutureBuilder to create UI components
// that update automatically as the Future progresses.
// The AsyncSnapshot object passed to the builder function contains all the information you
// need to respond to different states of the Future. This includes the current
// connection state (e.g., ConnectionState.waiting), the result of the Future,
// and any errors that were encountered.

// StreamBuilder
// StreamBuilder is used to build a widget tree based on a stream of asynchronous data (i.e., a Stream).
// It takes a Stream and a builder function as input, and builds a widget tree based on the state of the
// Stream. The builder function is called with an AsyncSnapshot object,
// which contains the current state of the Stream
// (e.g., whether it is still waiting for data, whether it has received new data,
// or whether it has encountered an error).
// You can use the AsyncSnapshot object to build different UI components based on the current
// state of the Stream.
// The Stream provided to StreamBuilder is a continuous source of asynchronous data that can be
// consumed in real-time. This is useful for creating UI components that update automatically
// as new data becomes available.
// you might use a StreamBuilder to display a real-time chart that updates as new data is received
// from a live data source.

// Factory Constructors
// In Flutter, factory constructors are special types of constructors that are used to create new
// instances of a class using a different mechanism than the default constructor.
// The factory constructor is a static method that returns an instance of the class,
// unlike the default constructor which returns a new instance of the class.
// The factory constructor is useful in cases where you want to create objects using a custom logic,
// such as caching or recycling existing instances of the class,
// or creating instances from a different data source.
// It provides a way to customize the process of object creation while still preserving the benefits of using a class.

// Some points about Factory Constructors
// 1.Factory constructors are static methods: Unlike regular constructors,
// factory constructors are static methods of a class.
// This means that they can't access instance variables or methods of a class,
// and they can't use the this keyword
// 2.Factory constructors can return cached or recycled objects:
// Because factory constructors are static methods, they can return existing instances of
// a class instead of creating new ones. This can be useful in cases where you need to
// reuse previously created objects to save memory or improve performance
// 3.Factory constructors can use different parameter types: Factory constructors are not
// limited to using the same parameter types as the default constructor.
// They can use different parameter types or even no parameters at all.
// This gives you more flexibility in how you create objects of a class
// 4.Factory constructors can throw exceptions: Just like regular methods,
// factory constructors can throw exceptions if there is an error during object creation.
// You can catch these exceptions using a try-catch block
// 5.Factory constructors can be used as named constructors: You can give a factory constructor
// a name and use it as a named constructor.
// This can be useful if you need to create different types of objects from the same class
// using different logic