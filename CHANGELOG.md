## 2.1.0

### Removing BehaviorType.leadingAndTrailing
This behavior is removed to prevent duplicate callback and reduce confusion between edge modes.

### Removed throttle-related behaviors
Simplified the throttling API by defaulting to leading-edge execution, ensuring a more predictable and consistent throttling pattern.

## 2.0.0

### Debouncer and Throttler Separation
Refactored the code to separate the responsibilities of debouncing and throttling for better code organization and maintainability. This separation enhances clarity and allows users to choose the appropriate mechanism based on their needs.

### Change to Named Parameters from Positional Parameters
Improved the method signature by switching from positional parameters to named parameters. This modification enhances code readability and makes it more user-friendly. Named parameters provide a clear and explicit way to convey the purpose of each argument, making the function calls more self-explanatory and reducing the likelihood of errors.

## 1.3.1

* format lib/src/debouncer.art

## 1.3.0

* Change isLeadingEdge parameter into using BehaviorType enabling more flexibility on leading edge, trailing edge or both

## 1.2.1 - 24 Jul 2023

* Add leading edge to documentation

## 1.2.0 - 20 Jul 2023

* Add leading edge feature

## 1.1.1 - 20 Jul 2023

* Update ReadMe to add Throttle Example

## 1.1.0 - 20 Jul 2023

* Add Throttle

## 1.0.2 - 19 Jul 2023

* Add Documentation

## 1.0.1 - 19 Jul 2023

* Fix homepage not accessible

## 1.0.0 - 19 Jul 2023

* Add Debouncer class
