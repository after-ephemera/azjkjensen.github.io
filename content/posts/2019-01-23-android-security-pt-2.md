---
title: "mobile security series part 2: permissions"
categories:
  - programming
  - research
tags:
  - android
date: 2019-01-23T08:25:52-05:00
image: 
  path: "../images/permissions.png"
  thumbnail: "../images/permissions.png"
excerpt: ""
---

*This post is the second part of a series on mobile security where we will explore the Android platform, how security is approached in a mobile context, and what that means for future mobile platforms like AR and VR. [part 1](/android-security-pt-1)*

Permissions are a fundamental part of any computer system's security model and mobile systems are no exception. We briefly addressed them briefly in the [last post on architecture](/android-security-pt-1), but here we will go into detail on what permissions are and how they are enforced. We will explore how this affects both system and application development. Digging deep into the mobile permissions model allows us to gain intuition for the interaction between different parts of the operating system, and in particular how Android is designed to protect against attacks.

<!-- With the Android platform tools (included in Android Studio) installed, you are equipped to inspect some of the internals of Android permissions. From time to time I will provide a prompt to perform these inspections on your own device or emulator.  -->

In an Android shell, you can run `pm list permissions` to list all of the permissions known to the device. Spoiler alert: there are a lot of them. I count about 600 on my emulated device running Pie.
We won't go into the details of why this output is formatted the way it is, but each line corresponds to a unique permission, either defined by the system or by an application.

### permissions at the user level

Complying with the principle of least privilege, [Android only allows permissions](https://developer.android.com/guide/topics/permissions/overview){:target="_blank"} as granted by the user, not by default. Therefore, any access to system resources, hardware, or other applications requires _permission_. This 

Android permissions are just strings listed in the application manifest file, bundled with the application at compile time. This list of strings defines the permissions that the user grants when the app is installed. 

As a measure to further protect users, version 6.0 (Marshmallow) and higher requires that some permissions that are considered dangerous must be granted both at install time and at runtime. This approach was introduced in an effort to increase awareness of permission approval among users, though as we will see it only provides minimal protection against malicious apps. 

Instead, this two-layer approval method exposes the user to a clearer picture of how the application developer intends to use the permission (or claims to intend to use the permission), and I think often drives growth of apps that use system resources in creative ways.

### permissions at the application level
Adding a permission to an application is as simple as adding a `<uses-permission>`{:.xml} tag to the application's `AndroidManifest.xml` file. For example, the 
```xml
<uses-permission android:name="android.permission.INTERNET" />
```
tag adds permission for the application to use the internet, a "normal" or non-dangerous permission that is automatically granted at install time. Dangerous permissions are declared the same way, but the user is required to grant permission at install time and runtime.

### permission at the system level

**_brief aside: selinux_**
Since Android is based on Linux, many familiar security concepts apply either directly or analogously also to Android. For example, instead of representing physical system users, UIDs (_User_ IDs) represent different applications on the system, giving applications all of the same isolation protections as user accounts do on Linux. Android uses Security-Enforced Linux (SELinux) policies in order to define at the kernel-level access control policies. Fine-grained controls can be used to protect various kernel-level components of the OS like processes, sockets, and the filesystem. We will delve a little deeper into SELinux on Android in a future post.

#### permission storage
The system manages a database of all known permissions on the device, all installed packages on the device, and each of their attributes such as the signing certificate, version, and assigned permissions in `/data/system/packages.xml` (you can view this file by copying it to your local machine with `adb` or from the device explorer in Android Studio). A system service called package manager manages this database. 

Each package is listed under its own `package` tag. You can see as properties on this tag the system configuration for this app - its UID, version, and assigned permissions.

#### protection levels

A permission's [_protection level_](https://developer.android.com/guide/topics/manifest/permission-element#plevel){:target="_blank"}  corresponds to the level of risk it presents to the user if granted. Thus, the more dangerous a permission, the more a user should be aware of its use.

**normal:**
Normal is the default protection level. Permissions marked normal are not considered dangerous and are granted automatically.

**dangerous**
Dangerous permissions are defined as those that "[could potentially affect the user's privacy or the device's normal operation](https://developer.android.com/guide/topics/permissions/overview#normal-dangerous){:target="_blank"}."
On the play store, dangerous permissions are shown but normal ones are not.

**signature**
Permissions with the signature level are considered more secure because they are signed with the same signing key that the application that declared the permission is signed with. In order to successfully grant this permission the developer must own the signing key.

**signatureOrSystem**
In addition to securing access behind a key, the signatureOrSystem level adds upon the definition of the signature level by also allowing applications that were built with the system to grant it without the key. OEMs then are able to declare system-specific permissions that can be shared without sharing signing keys.

### permission assignment
The package manager service assigns each app a UID at install time
/etc/permissions/platform.xml contains GIDs for each permission.
When a permission is granted for an app, that app is given the associated supplementary GID. *Note: Android GIDs are static, no /etc/group file exists on the android system.*

An app's associated GIDs can be viewed by using

 ```js
 ➜ adb shell ps | grep {app package}

u0_a91       13087  1873 3787932 167244 0                   0 D haulynx.com.haulynx2_0
 ```
 to get the app's pid, and then
 ```js
 ➜ adb shell cat /proc/13087/status

...
Gid:	10091	10091	10091	10091
...
 ```
to see the process status. The app's GIDs are listed under the `Gid` heading.

Becuase system processes don't have packages associated with them, their permissions are listed in the `platform.xml` file, but under `<assign-permission>` tags. Each of these tags assigns the permission to the process' static UID.

**_brief aside: the zygote process_**
Each Android app runs in the android runtime (ART). In an effort to save memory, the zygote process starts on system initialization and loads system libraries into memory. Each application that is created is a fork of the  zygote process. Since Android copies-on-write when forking, all apps share common system resources like the Java standard library.
After forking, OS scheduling, security context, and the process' assigned resources are configured before finally launching the actual application code.

### enforcement: policing permissions
Now that we have seen how Android assigns permissions to a given application or system process, we can move on to how the operating system enforces permissions.

#### low-level enforcement
At the kernel level, process GIDs are inspected to verify matching capabilities before allowing access to kernel-level constructs like sockets and the Android VPN driver.

System daemons use local sockets to communicate with each other and the rest of the system, and a definition of these few core sockets and their permissions is listed in the kernel `init.rc` file that runs at system initialization. This configuration is designed to be unchangeable at runtime.

#### framework-level enforcement
At the framework level, permissions are checked by querying the package manager mentioned above for the given context's permissions. If the permission in question is in the list returned by the package manager, the permission is assumed to be granted. If one application component (an activity or service) uses another, the calling component must have the declared permissions of the called component. Otherwise a `SecurityException` will be thrown.

We won't dig into how permission enforcement happens with _pending intents_, but their behavior is similar enough to what we've described about activities and services that for the sake of brevity we will broadly assume a similar approach -- callee requires the permissions of the caller. The actual implementation is slightly more complex than this but is beyond the scope of my current interest to explain.

Permissions checks also occur during BroadcastReceiver transmissions. If a sender declares a required permission in their call to `sendBroadcast()`, the receiver will not be delivered the broadcast unless they have been granted it. This can also be declared in the opposite direction, where recievers may require certain permissions from broadcasts that would like to target them; enforcement for this case happens in the same way.

### conclusion
Running each application as its own process is clearly not enough to protect system, application, and users from targeted attacks, particularly at the interfaces between applications and between application and system. The evolving Android permissions model is thus designed to give the developer flexibility in their design choices while providing access to only capabilities explicitly requested -- the one fatal flaw being that once granted, the application has unchecked access to system resources. 

<!-- In addition to separating processes by isolating applications from one another, each application is given its own directory to write to and read from. Linux file permissions by default don't allow multiple users to access files, and Android application directories act the same, separating one application's data from reads and writes by another. -->
