---
title: "using the NewInstance pattern in kotlin"
categories:
  - programming
tags:
  - kotlin
  - android
image: 
  path: "../images/kotlin-android.png"
  thumbnail: "../images/kotlin-android-thumb.png"
date: 2018-04-05T14:25:52-05:00
excerpt: ""
---

Kotlin has a handful of fundamental differences from Java, not the least of which being the omission of static members and methods. This can cause a bit of a headache when trying to duplicate typical Android patterns using Android’s [newest official language](https://developer.android.com/kotlin/index.html){:target="_blank"}.

**Skip the prose and get to the code via this [Github gist](https://gist.github.com/azjkjensen/cf094c79726bab08b68f01dcc2e82a71#file-myfragment-kt){:target="_blank"}.**

## Java Example

In Java Android development it is common to add a static method called newInstance() to a fragment class like this:

<script src="https://gist.github.com/azjkjensen/785ad31cd5c8ec96dac5d4c01e581c2c.js"></script>

The API documentation [recommends following this pattern](https://developer.android.com/reference/android/app/Fragment.html){:target="_blank"} because it allows you to vertically separate the fragment from it’s hosting activity. It keeps your application components modular.

Since the fragment code knows nothing of its hosting activity, you won’t have to deal with refactoring if you decide to host this same fragment elsewhere in the future. All of the information required to create your fragment is self-contained within the fragment code.

Kotlin does not have static members and methods, so duplicating this principle requires some creativity. Here is my method for writing idiomatic Kotlin while maintaining these object-oriented principles.

## Kotlin Companion Object

Kotlin introduces the [companion object](https://kotlinlang.org/docs/reference/object-declarations.html#companion-objects){:target="_blank"} to your Android code, which may [sound familiar if you know Scala](http://docs.scala-lang.org/tutorials/tour/singleton-objects.html#companions){:target="_blank"}. When a variable (or function) is declared as part of the companion object you can use it just like you would a static member in Java. The difference here is that companion objects in Kotlin are more versatile. Items declared on the companion object are instances of real objects, which means they can implement interfaces. But they act essentially identical to the Java static objects you know and love.

Here is how you might write fragment code in Kotlin:

<script src="https://gist.github.com/azjkjensen/cf094c79726bab08b68f01dcc2e82a71.js"></script>

Voila! We’ve successfully accomplished the same purpose as our Java code above. The hosting activity can still use ```MyFragment.newInstance()```, maintaining modularity and reusability. The fragment doesn’t need to know about it’s calling activity and all information about creating the fragment is contained within its own code.

This pattern can also be used for other commonly static data in Android development like ```getIntent()``` or class identifiers.

Object-oriented principles drive quality Android development. Kotlin takes those principles and builds upon them, adding features like null safety, a collection of language tools for using the functional programming paradigm, and interoperability with existing Java code. That all goes without saying that Kotlin is now [officially supported](https://developer.android.com/kotlin/index.html){:target="_blank"} by the Android team at Google. Learn more about using Kotlin with Android [here](https://kotlinlang.org/docs/reference/android-overview.html){:target="_blank"}.

---

*As is the case with most Android principles, converting your fragments to Kotlin requires a slight learning curve and some experimentation. Please reach out to me with any improvements on my design.*
