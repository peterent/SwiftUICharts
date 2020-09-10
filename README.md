# SwiftUICharts
Simple, animated, charts using SwiftUI

This project shows one way to use SwiftUI to make some simple charts. There is a `ColumnChart` and a `BarChart` that animate when their data changes. The data for these charts is an array of Double values that represent percentages. To make things a little easier there is a `ChartModel` that can take any array of Double and transform it into percentage values.

An example shows how to use the chart views, including custom data formatters to show values on the charts. Axes and grid lines can also be applied.

## The Charts

The charts themselves are pretty simple. They are composed of SwiftUI `Shape` elements and then layered in a `ZStack` to give the desired effect:
* `GridView` (optional)
* The chart (`BarChart` or `ColumnChart`)
* `AxisView` (optional)

### Model

The data for the chart is an array of `Double` values. The values are percentages of the chart's primary dimension (height for `ColumnChart`, width for `BarChart`). The model, `ChartModel`, converts the user data (temperatures in my example) into percentages so the chart user does not have do that conversion. The model can either use the data or it can be given a specific range (eg, -100°F to +100F) when calculating the percentages.

The percentages are then stored in a very specical data type: `AnimatableVector` (see below) which is `@Published` in the model. When the model's data changes it triggers a new set of percentages and refreshes this vector.

### AnimatableVector

The key to SwiftUI animation is SwiftUI's ability to interpolate between starting and ending values. For example, if you have an offset of 10 and then change it 100, if the element has an `.animation` modifier, SwiftUI will smoothly move the element from the first position to the next position.

SwiftUI makes it easy to animate its own modifiers like offset, scale, and opacity (among others). But you can create your own custom animatable data. Check out Paul Hudon's post on [Animating Simple Shapes](https://www.hackingwithswift.com/books/ios-swiftui/animating-simple-shapes-with-animatabledata).

Unfortunately, SwiftUI does not provide more than animating a single value and a pair (`AnimatablePair`). What's needed for a chart is animating an array, or vector, of values.

This is where Swift's `VectorArithmetic` comes in. I won't go into details here, but thanks to Majiid Jabrayilov, there is `AnimatableVector` which makes chart animation possible (see Acknowledgements below). But giving a set of values to the vector, a change in that set can be animated by SwiftUI, causing the chart to fluctuate. Its a nice effect. And of course, you can play with the effects used (I just use a simple ease-in-out, but you can use others).

## The App

The code in this repository is a runable app using SwiftUI 1.0. The app itself presents both types of charts with some toggles to turn on/off some of the features.

Please feel free to use this code for your projects or to use it as another way to understand animation or just SwiftUI in general. I will probably be updating it from time to time as I learn more and improve my techniques.


## Acknowledgements

Without AnimatableVector this project would not be possible. My thanks to Majiid Jabrayilov for showing me how wonderful Swift math can be. [Check out his article](https://swiftwithmajid.com/2020/06/17/the-magic-of-animatable-values-in-swiftui/) on the magic of animatable values.

My Swift life would not be complete without Paul Hudson's [Hacking with Swift](http://www.hackingwithswift.com) blog. The man must never sleep.
