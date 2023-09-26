---
title: "mobile security series part 5: cryptographic storage"
categories:
  - programming
  - research
tags:
  - android
date: 2019-03-05T08:25:52-05:00
image: 
  path: "../images/crypto-storage.png"
  thumbnail: "../images/crypto-storage.png"
excerpt: ""
---

*This post is the fifth in a series on mobile security where we are exploring the Android platform, how security is approached in a mobile context, and what that means for future mobile platforms like AR and VR. [part 1](/android-security-pt-1) [part 2](/android-security-pt-2) [part 3](/android-security-pt-3) [part 4](/android-security-pt-4)* 

**Skip the prose and get to the code via [https://github.com/azjkjensen/android-encryption-starter](https://github.com/azjkjensen/android-encryption-starter){:target="_blank"}**

Cryptography: you know it's good, hope it happens, pray it works. But dealing with sensitive information is a topic that has been rising in popularity in recent years, and it's important to understand how encryption is used. As we review cryptographic storage in this post, we'll discuss app implementation specifics and end with a full example app that I have open-sourced to help you get started. There just aren't enough resources out there for how to implement data encryption on Android.

### intro
In order for a mobile device to authenticate to a server using PKI, the device must prove its authentic identity to the server. Like other mainstream operating systems, Android provides tools to make this easy and reliable across devices, so the app developer doesn't have to design key storage infrastructure themselves. PKI key storage is useful in a myriad of applications; some of which are encrypted data storage on device, VPN authentication, enterprise wifi authentication, and secure end-to-end messaging.

### system implementation
#### keystore (https://source.android.com/security/keystore)
Historically, credential storage and management was accomplished on Android through a system daemon called _keystore_, initialized at system startup (in the init.rc file). It exposed a local socket API to clients, which had to manage everything on their own. 

A new Binder-based API was introduced in Android 4.3 to make interacting with the keystore simpler and to centralize service interaction. Since most system services use a binder interface, doing the same for credentials makes accessing the keystore more intuitive as well.

#### credential storage 

_keystore_ saves keys in the `/data/misc/keystore/` directory, and names them according to app UID, key type, and key alias. Centralizing this information is beneficial because it means that _keystore_ will delete keys belonging to an application upon app uninstall. The downside to this is that, at least in devices without a trusted execution environment or secure hardware*, it introduces a single point of failure into the device security model.

That being said, if an attacker gets access to the _keystore_ directory they would still need access to the master device password, which each file is encrypted with on top of its own protection. In general, this means that _keystore_ is considered relatively secure -- especially for the common user.

#### inter-app _keystore_ protection

 _keystore_ protects keys from other apps by filtering on the app UID, making sure that only the creating app has access to its keys. In traditional implementations (those without secure hardware)

#### access restrictions

Because the keystore directory is owned by the _keystore_ user, the developer is required to go through the _keystore_ service to use them. This provides an additional layer of security against directly copying key blobs from the keystore directory. It also prevents the _system_ and _root_ user from having total access to the keystore.

#### keymaster HAL and recent additions
In order to make it easier for OEMs to design their own credential storage solution and especially to allow for a hardware-backed keystore, the _keymaster_ HAL (hardware abstraction layer**) was introduced in 4.1. All operations that _keystore_ performs are implemented in the _keymaster_ HAL module.

_keymaster_ 2 (Android 7.0) added support for key verification outside of the TEE and binding keys to OS and patch versions, protecting against rollbacks that utilize a rollback to exploit a vulnerability in an older version.

_keymaster_ 3 (Android 8.0) shifted the HAL interfaces from C to C++. ID attestation was also added, allowing for key verification according to hardware identifiers like serial number or IMEI.

_keymaster_ 4 (Android 9.0) adds real support for embedded secure elements (via StrongBox, discussed below), secure key import, and support for the 3DES encryption algorithm.

#### [keychain](https://developer.android.com/reference/android/security/KeyChain){:target="_blank"} 
The `KeyChain` class is [used for holding system-wide credentials](https://developer.android.com/training/articles/keystore#WhichShouldIUse){:target="_blank"}. Since most use cases today utilize credentials that are private to an application, we won't look any further at it. `KeyChain` has a minimal API focused on retrieving private keys and checking for compatibility.

### sdk api integration
We've spent a lot of time discussing the system side of credential storage, but such tools are only useful inasmuch as they can be used by developers. Since _keystore_ was exposed as a Binder service, gaining access to it became as easy as requesting it from `ServiceManager`. Nowadays it's even easier to get a reference to the `KeyStore` object by calling one of the various implementations of `KeyStore.getInstance()`, which allows you to specify the keystore type. Here is how you would grab the regular Android keystore implementation:

```js
val keyStore:KeyStore = Keystore.getInstance("AndroidKeyStore")
```

#### [keystore](https://developer.android.com/reference/java/security/KeyStore){:target="_blank"} 
`KeyStore` is the most commonly used credential management tool nowadays since it integrates so well with the _keystore_ system service and it uses standard JCA java cryptography architecture apis. With a reference to a `KeyStore` object and a `KeyPairGenerator` object, you can create, retrieve, and delete credentials owned by your app. 

On Android version 9.0 and up, `KeyStore` offers support for "StrongBox" backed credentials. The qualifications for "StrongBox" support are tighter than hardware-backed solutions; they must have secure hardware with its own processor, secure storage, and a true random number generator. The pixel 2's [security module](https://www.blog.google/products/android-enterprise/how-pixel-2s-security-module-delivers-enterprise-grade-security/){:target="_blank"} used this type of hardware, but explicit Android support for it was just recently added. The pixel 3 [Titan M chip](https://www.blog.google/products/pixel/titan-m-makes-pixel-3-our-most-secure-phone-yet/){:target="_blank"} provides additional hardware security features to further protect credentials and user data. 

### conclusion
Encryption is a fundamental security tool that is easy to use. In a mobile context encryption is crucial for authentication and data protection. As users become increasingly aware of privacy and security concerns, encryption lays the foundation for a deep level of security protection that is for the most part unmatched. As we move to a continuous-vision mobile experience, encryption will be one of the tools ensuring that users are protected while receiving meaningful experiences. 

I've provided a full app example in a repository under GNU GPL at [https://github.com/azjkjensen/android-encryption-starter](https://github.com/azjkjensen/android-encryption-starter){:target="_blank"}, which demonstrates simple RSA encryption and decryption via these APIs. Feel free to use it as a starting point for your own experiments. 

*_In this context secure hardware just means dedicated hardware for trusted execution, or a [Trusted Execution Environment (TEE)](https://en.wikipedia.org/wiki/Trusted_execution_environment){:target="_blank"}._

**_A HAL is an interface definition for OEMs to manufacture their devices to play nicely with AOSP. Android provides the APIs to developers, and behind the scenes the manufacturer hooks those APIs to real drivers to enable new implementations while maintaining compatibility._
