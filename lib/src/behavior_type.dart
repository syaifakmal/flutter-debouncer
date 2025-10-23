/// Specifies the behavior type for debouncing or throttling function calls.
///
/// The [BehaviorType] enum is used to define how function calls are handled
/// within the context of debouncing or throttling mechanisms. It provides
/// options for specifying when and how the callback function is executed.
///
/// - [BehaviorType.trailingEdge] : The callback function is executed after the
///   specified duration has passed without any new calls.
/// - [BehaviorType.leadingEdge] : The callback function is executed immediately
///   on the first call, and subsequent calls within the specified duration are
///   ignored.
enum BehaviorType {
  /// The callback function is executed after the specified duration has passed
  /// without any new calls.
  trailingEdge,

  /// The callback function is executed immediately on the first call, and
  /// subsequent calls within the specified duration are ignored.
  leadingEdge,
}
