---
title: "mobile security series part 1: the android platform"
categories:
  - programming
  - research
tags:
  - unity
  - android
date: 2019-01-07T14:25:52-05:00
excerpt: ""
---

*This post is the first part of a new series on mobile security where we will explore the Android platform, how security is approached in a mobile context, and what that means for future mobile platforms like AR and VR.*

# android architecture

In order to understand mobile security one must become familiar with the mobile platform itself. We will start at the lowest level and review the form and function of each section of the platform. The diagram below shows the architecture of Android, with the lowest level components at the bottom.

![Android Architecture](/images/android_arch.png "Android Architecture")

#### kernel
The Android operating system is built on top of the Linux Kernel, meaning that many principles from Linux tie nicely to those of Android. The basic structure of the filesystem, permissions, processes, and scheduling builds upon the structure established in Linux. Therefore understanding how to use Linux lays a solid foundation for understanding Android architecture and security.

Even though the Android kernel is based on the mainline Linux kernel, it is not an exact copy of the Linux Kernel that runs on full-size computing environments. The Android kernel includes platform-specific utilities like `ashmem`, a unique-to-Android shared memory solution, and `Binder`, an interprocess communication service. We will discuss some of the security features and potential vulnerabilities in a future post.

#### hal
The Hardware Abstraction Layer (HAL) allows OEMs to interface their own hardware with Android drivers without knowing all of the specifics about how they are implemented. The HAL provides well-defined interfaces for how to connect low-level software with hardware on the device, simplifying the development process for new hardware.

#### dalvik and art
Through Android 4.4 Kitkat, Java code running on Android was executed by a Java virtual machine (JVM) runtime called [Dalvik](https://source.android.com/devices/tech/dalvik). Dalvik was created specifically for Android. It utilized just in time compilation to transform Dalvik Executable (DEX) bytecode to machine-readable instructions. Dalvik has since been [replaced by Android RunTime (ART)](https://infinum.co/the-capsized-eight/art-vs-dalvik-introducing-the-new-android-runtime-in-kit-kat).

ART was also created specifically for Android, but among other improvements it increases application battery performance by compiling bytecode at install time (ahead of time, or AOT). ART also adds [improved garbage collection](https://source.android.com/devices/tech/dalvik).

Both Dalvik and ART include performance enhancements for mobile computing. Instead of the typical JVM stack-based approach Android's runtimes use a register-based approach, in general reducing the number of instructions required for computation and therefore improving interpretation efficiency.

#### android framework
The Android Framework contains all platform-level tools you fnd in the `android` package. It contains app APIs for system services like bluetooth and location.

#### system apps
System apps are default system applications that are packaged with the operating system. These apps include the camera, calendar, and home screen, among many other standard apps.
System apps are intended to be permanent and can't be uninstalled by the user, providing them with an additional layer of security over installed apps.

#### installed apps
[The principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege){:target="_blank"} is applied liberally in the Android security ecosystem, and this is especially evident for installed apps. Apps installed by the user have a number of standard protections in place to prevent them from accessing other applications' data and system resources. Resource permissions (such as camera or location) are explicitly declared by the application and typically requested from the user either at install-time or at runtime.

# conclusion
The Android platform is complex, but each of the components serves a purpose, balancing developer flexibility with user security. As we move forward we will dig deeper into Android's security methodology and how mobile security differs from traditional computing security.
