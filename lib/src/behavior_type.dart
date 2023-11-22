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
/// - [BehaviorType.leadingAndTrailing] : The callback function is executed both
///   on the leading and trailing edges of the timer. It is invoked immediately
///   on the first call and after the specified duration has passed without any
///   new calls.
enum BehaviorType {
  /// The callback function is executed after the specified duration has passed
  /// without any new calls.
  trailingEdge,

  /// The callback function is executed immediately on the first call, and
  /// subsequent calls within the specified duration are ignored.
  leadingEdge,

  /// The callback function is executed both on the leading and trailing edges
  /// of the timer. It is invoked immediately on the first call and after the
  /// specified duration has passed without any new calls.
  leadingAndTrailing,
}
