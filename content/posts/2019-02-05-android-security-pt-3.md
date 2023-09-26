---
title: "mobile security series part 3: package management"
categories:
  - programming
  - research
tags:
  - android
date: 2019-02-05T08:25:52-05:00
image: 
  path: "../images/packages.png"
  thumbnail: "../images/packages.png"
excerpt: ""
---

*This post is the third in a series on mobile security where we are exploring the Android platform, how security is approached in a mobile context, and what that means for future mobile platforms like AR and VR. [part 1](/android-security-pt-1) [part 2](/android-security-pt-2)*

Lately I've been spending a lot of time seeking to understand Android at a lower level to drive the research I am doing on privacy and security in augmented reality. In the last week I've bricked and revived devices more times than I can count. In the process I've been studying up on this post's topic -- package management -- and the two have worked in tandem to drive my understanding of Android as a system and framework. As a result, I will try to bring a more practical approach to how these system-level components affect Android developers. We will begin by seeking to understand the elusive APK and how it is packaged.

But first, here's how an Android application is typically installed from the user's perspective:
they open an application distribution platform (most likely the Google Play Store or the Amazon App Store) and then find the application they want to install. They select the application, confirm permission access, provide some sort of authentication, wait some time for download and installation, and poof! the app is now available for use. The user experience feels streamlined and minimal, allowing a low barrier of entry for trying out apps and an uncomplicated way to customize the mobile experience. The package managment system, though, is anything but uncomplicated. The various components in both user- and kernel-space dance harmoniously to provide a simplified experience while securing user and developer data. System services, daemons, and applications work in tandem to confidently install application packages called APKs. 

### the APK
The Android Application Package Format, or APK is a binary wrapper that contains code, resources, and metadata.
Think of the APK as a fancy compressed (zip, tar) file, because that's as precise an analog we can assign it. The APK format is an extension of Java's JAR format, which is an extension of the zip format. In short, the APK is a compressed archive.

APKs can be identified by the .apk file extension.
<!-- https://en.wikipedia.org/wiki/Android_application_package -->
<!-- https://dzone.com/articles/depth-android-package-manager -->

Important components of the APK archive include:
* The [Android Manifest](https://developer.android.com/guide/topics/manifest/manifest-intro){:target="_blank"} (`AndroidManifest.xml`), a file containing metadata about the application that is used during the build process, by the Play Store during the publishing process, and on the system for package management. 
* `classes.dex`, a file containing executable bytecode used by the runtime interpreter.
* `resources.arsc`, a set of compiled resources from files in the project's `values` directory you may recognize such as `strings.xml`, `colors.xml`, `styles.xml`.
* The assets directory, containing raw assets like images, videos, audio files.
* The `lib` directory, with files for compiled native code. Within `lib`, there are subdirectories for each architecture the APK was built for.
* The `res` directory, composed of resources used from code like layouts and animations.
* The `META-INF` directory, containing code signatures and the package manifest file. This directory is used for _package_ metadata (concerning the entire APK), whereas `AndroidManifest.xml` is just for _application_ metadata. 

### code signing

Code is signed for the purposes of 1. assuring that the code was authentically created by who it says it was created by and 2. confirming that the code hasn't been altered in some way between creation and distribution. And the entire APK is actually signed, making similar (but not exactly the same) guarantees for application code, resources, and metadata.

This is an incredibly useful aspect of the mobile system, because code signing is a standard part of the development process; however, **there is no guarantee that the contained code is not malicious**. It is paramount to understand that _the security of code signing is limited by the amount of trust between the user and the developer_. Since Android signing certificates are self generated (not by a Certificate Authority, or CA), there is (almost) no inspection of certificate signing other than that the each component of the package is signed with the same certificate as the others. This is a significant departure from Java's established way of using CA-signed code as a security tool. 

When a package is signed, two archive manifest files (a main manifest and a signature file) are created and inserted into the `META-INF` directory. The main manifest (usually `MANIFEST.SF`)  contains digests for each segment of the package, allowing for signing verification. The signature file consists of the same information, in addition to the key for the whole `MANIFEST.SF` file.

Here is a sample signature file:

```
Signature-Version: 1.0
Created-By: 1.0 (Android)
SHA-256-Digest-Manifest: Cx6V2h05NErM82qLrb2lJoKmP2nylZ56RdweeB+J0RM=
X-Android-APK-Signed: 2

Name: AndroidManifest.xml
SHA-256-Digest: hgDZmgvi0v3LOYNTLBY9Cls7y1Iv1hYoBJwESKM37XU=
```

Manual verification of these digests can be accomplished with the `openssl` command-line tool like this:

```js
// Produce the SHA1 key for MANIFEST.MF
➜ openssl sha1 -binary MANIFEST.MF |openssl base64u 
zb0XjEhVBxE0z2ZC+B4OW25WBxo=
// Use the produced key to generate the expected result found in the signature file.
➜ echo -en "Name: res/drawable-xhdpi/ic_launcher.png\r\nSHA1-Digest: \ K/0Rd/lt0qSlgDD/9DY7aCNlBvU=\r\n\r\n"|openssl sha1 -binary |openssl base64v 
jTeE2Y5L3uBdQ2g40PB2n72L3dE=
```

In the next step in the signing process the signature file is combined with a digital signature and a signature block file is generated as a binary file. Signature block files are identified by the `.RSA`, `.DSA`, or `.EC` extension and comprise the actual _package signature_. This is what the APK is signed with.

After the final APK is generated you can see the signing information about it with the `keytool` command:

```js
➜ keytool -printcert -jarfile app.apk
Signer #1:

Signature:

Owner: O=Haulynx, L=Phoenix
Issuer: O=Haulynx, L=Phoenix
Serial number: 18f98c23
Valid from: Wed May 10 12:56:25 MST 2017 until: Sun May 04 12:56:25 MST 2042
Certificate fingerprints:
	 SHA1: 2F:E0:EA:49:F2:56:85:B3:8F:E0:2A:8E:09:BA:32:A8:34:FA:79:81
	 SHA256: 13:E7:0D:E3:49:51:33:5B:B3:D9:05:9D:1E:A9:7F:53:CE:F3:40:AE:09:38:06:F9:A9:C3:22:4C:25:8D:F8:BF
Signature algorithm name: SHA256withRSA
Subject Public Key Algorithm: 2048-bit RSA key
Version: 3

Extensions:

#1: ObjectId: 2.5.29.14 Criticality=false
SubjectKeyIdentifier [
KeyIdentifier [
0000: 8F 37 CA 84 09 C5 A7 B8   D0 B6 1C A0 D0 0D 42 C7  .7............B.
0010: A3 2E 8A 3B                                        ...;
]
]
```

Android also supports whole-file signing for over the air (OTA) updates. 

### package installation

Apps can be installed to a device via any of the following methods:
- An application distribution store like the Google Play Store.
- Via the devloper tool `adb` using `adb install`.
- With the Android shell. You can copy the APK file into the proper directory and the `appDirObserver` system process (discussed below) will detect the change and finish the installation.
- By opening an APK on the device itself via a file explorer.

The installation process is relatively complex because it involves many moving parts. Let's discuss each component individually to examine its role.

#### installation directory
System apps are only allowed on the `system` partition, which is read-only (without rooting). They can be found in `/system/app` or `/system/priv-app` or `/system/vendor/app`, depending on the type of system app. 

User installed apps reside on the _userdata_ partition mostly in `/data/app` directory.

Application data is in the `/data/data` directory on the _userdata_ partition.
Other application data and metadata are also included on the _userdata_ partition.

#### installation system

Other than the installation directories, every component of the installation system contains code that accomplishes at most a handful of small tasks. Designing the system in this way provides various security checks and isolates permission access to where it is needed. This stands in opposition to a monolithic service design that would be given all required permissions and have fewer protections in place. The complexity of such a design is higher, but the system designers chose to trade off complexity for security. This is a common tradeoff that exists in most large systems.

**AppDirObserver** is a multi-instance process that monitors changes to application directories and starts installation/removal when the monitored directory changes. 

**The PackageInstaller app** is a system app with associated UI that's used for showing a preview of application permissions and the installation confirmation. On the majority of Android devices today, the PackageInstaller app is started when you install apps from a source other than the Play Store, provided you have allowed apps to be installed from "unknown sources" in your device's system settings. When the user confirms an install through PackageInstaller and "unknown sources" is selected, the PackageManager service is notified to install the application. This app is also shown when the user chooses to uninstall a user-installed app from the system settings.


**The `pm` tool** [issues commands to the PackageManager service](https://developer.android.com/studio/command-line/adb#pm){:target="_blank"} to perform all sorts of package-related actions, such as installation and revoking permissions. `pm` doesn't need "unknown sources" and doesn't show any UI (it is not an app).

**`installd`** is a daemon that runs natively on the system, but has enhanced privileges that allow it to manage the application and data directories. One of the main responsibilities of `installd` is to generate optimized native code from the compiled bytecode. The `installd` local socket is provided as a method for processes running under the `system` UID to interface with the daemon. 

**Package Manager Service** as the name implies, does the bulk of package management. The service can be accessed in a third-party app via `PackageManager`, a class that provides an abstraction layer over the actual service, but with reduced access to functionality. Package Manager Service runs in the system process (with the `system` UID), and thus doesn't have root access. Instead it communicates with the system-level installer daemon via its own socket called `/dev/socket/installd`.

**MountService** mounts external storage on the device, like SD cards or external drives. Device-level encryption also starts here.

**The `vold` daemon** manages logical volumes on device. It runs as root and is accessible to members of the `mount` group via the `/dev/socket/vold` local socket.

**MediaContainerService** manages the moving of APKs to their installed directories on device and gives `PackageManagerService` access to external storage.

Each of these components plays a vital role in some part of the installation process. Here is a brief step-by-step walkthrough of how installation typically happens:

1. An APK is selected for installation via one of the methods mentioned above.
2. `PackageInstallerActivity` collects metadata about the app from `AndroidManifest.xml`. (The manifest file is hashed here and the hash is passed down and validated at each step afterward, providing a method of checking that the APK was not removed or replaced during installation).
3. `PackageManagerService` receives the install command from `PackageInstallerActivity` and determines where the package will be installed. `PackageManagerService` creates a directory for it and hands control to `MediaContainerService`.
4. `MediaContainerService` copies the APK to its install location, sets the `.apk` file permissions, and gives it SELinux context.
5. A new scan is activated in `PackageManagerService`, allowing it to create a new package entry in the package settings and give the app a UID.
6. `installd` is called by `PackageManagerService` to create the app data directory.
7. `installd` generates native machine code from the APK's included bytecode.
8. `PackageManagerService` creates a new entry for the package in the package database, with its associated permissions and attributes.
9. The application is installed and ready for use. It appears in the application drawer for the user to access.

Various steps may change if the APK is encrypted, forward-locked, or from an unknown source, but for the most part the process remains the same. One component verifies the manifest hash, handles a small portion of the duty, and hands control to the next component. 

As the mobile world evolves, so do the systems we use to provide secure package management. When considering the _future_ of mobile applications like those for VR or AR, package installation may be improved upon by performing static analysis of application code to identify vulnerabilities or by including a more fine-grained control mechanism for permission access control. A future in which the next mobile platform replaces the smartphone we know will require improvements like this in order to provide a good experience with reasonable security.
