Overview
========

iOS Framework make-up, as I understand it

1. UIKit contains everything that you need in order to just build a standard UI
2. UIView is the superclass of nearly everything
3. Use ViewControllers, (VCs) to determine behavior of the view
4. Delegates and Datasources also control behavior of view (these are actually included in a view controller)
5. Views are in a hierarchy (superview -> view that contains a given view), add views to another view by calling addSubview

Autolayout

1. (A big pain in the butt)
2. Two ways of making constraints
  - Write them in Autolayout Visual Format Language
  - Use Storyboard to lay it out
3. Always seem to be making things complicated and buggy
4. But also good if you're trying to support multiple different kinds of views (i.e. the multiple types of screens supported by Apple -> iPhone 7, 7 Plus, 6, 6 Plus, 5, 5s, SE, etc.)
5. If autolayout not working, set translatesAutoresizingMaskIntoConstraints to false

Storyboard

1. Allows you to map out the flow of views
2. Drag and drop elements into the view controller
  - All sorts of useful widgets rae in the lower right hand corner of the screen
3. Determine the types of segues that the app will use


Programmatically Creating and Pushing Views

1. Really useful if you're not into clicking a lot
2. Can make a superclass for all of your view controllers that gives you all of the functionality that you need, making your code readily digestible and short


First Project

1. Start off with a single-view application - we can get into segues and views and things later
2. Go over UITableViews and UITableViewControllers - probably the most important UIView in UIKit