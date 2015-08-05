DHFoundation
============

[![Circle CI](https://circleci.com/gh/dhardiman/DHFoundation/tree/master.svg?style=svg&circle-token=c937df2f6f9c74c2406117885b43ad86c515c32f)](https://circleci.com/gh/dhardiman/DHFoundation/tree/master) [![Coverage Status](https://coveralls.io/repos/dhardiman/DHFoundation/badge.svg?branch=master&service=github)](https://coveralls.io/github/dhardiman/DHFoundation?branch=master)

Common repository of useful iOS code.

## `DHNotificationStore`
This is a mechanism to make dealing with `NSNotificationCenter`'s block based methods simpler.

Instead of

```
// We need to hang on to this observer object to remove later
id observer =
[[NSNotificationCenter defaultCenter] addObserverForName:DHNotificationName
                                                  object:nil
                                                   queue:[NSOperationQueue currentQueue]
                                              usingBlock:^(NSNotification *note) {
                                                  // Handle notification
                                              }];
[[NSNotificationCenter defaultCenter] removeObserver:observer];
```

`DHNotificationStore` wraps this, and using associated objects and weak references, allows the object lifecycle to handle removing the notification observer, leaving us with

```
[self.dh_notificationStore addObserverForName:DHNotificationName usingBlock:^(NSNotification *note) {
    // Handle notification
}];
```

## `DHConfiguration`
I wish I could remember the blog post where I discovered this idea so I could credit it. If it was your idea, please let me know so I can.

`DHConfiguration` is a class for wrapping access to a plist configuration file. It uses the objective-c runtime to add accessor methods at runtime to read the class. Simply subclass `DHConfiguration`, add your own properties to your subclass of the correct type, and declare them as `@dynamic` in the implementation. Out of the box, this supports integers, floats, bools, any type natively supported by the plist format, as well as converting a string value to `NSURL`. It is trivial to extend to support further type conversion from string inputs in future.

## `DHReachabilityEventHandler`
This is a simple way to handle reachability changes within a class. Via a category on `NSObject`, each class is given a `dh_reachability` class that exposes both a `DHReachability` object, which is simply Apple's `Reachability` class but namespaced, as well as a `changed` event handler block that will be fired whenever the reachability status changes.

## `UIViewController+DHPrepareForSegue`
Category method to try to avoid endless `if/else` blocks in `prepareForSegue:sender:` methods. Simply call `dh_prepareSegueWithIdentifier:destinationViewController:sourceViewController:sender` within `prepareForSegue:sender:` and the method will try to call a method with the same name as the segue identifier. For example, if a segue within a view controller has the identifier `showDetailViewController:`, we can simply write

```
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self dh_prepareSegueWithIdentifier:segue.identifier
              destinationViewController:segue.destinationViewController
                   sourceViewController:segue.sourceViewController
                                 sender:sender];
}

- (void)showDetailViewController:(UIViewController *)viewController {
    // Configure the destination view controller in this method.
    // No need for if statements above.
}
```

Depending on the number of colon-separated sections in the selector name, the method above can pass different arguments to your method. Zero colons will pass no arguments, one will pass the destination, two will pass destination and source, and three will also pass the sender. The sender can be passed with fewer colons if there is a section called sender. For example
```
- (void)showDetailViewController:(UIViewController *)destination source:(UIViewController *)source {
}
```
will receive the destination and source view controllers, whereas
```
- (void)showDetailViewController:(UIViewController *)destination sender:(id)sender {
}
```
will receive the destination and sender.

## Categories
There are various useful categories in this library, see the documentation for more info.
