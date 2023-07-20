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