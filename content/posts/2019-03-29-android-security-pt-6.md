---
title: "mobile security series part 6: device security"
categories:
  - programming
  - research
tags:
  - android
date: 2019-03-05T08:25:52-05:00
image: 
  path: "../images/device_security.jpg"
  thumbnail: "../images/device_security.jpg"
excerpt: ""
---

*This post is the sixth in a series on mobile security where we are exploring the Android platform, how security is approached in a mobile context, and what that means for future mobile platforms like AR and VR. [part 1](/android-security-pt-1) [part 2](/android-security-pt-2) [part 3](/android-security-pt-3) [part 4](/android-security-pt-4) [part 5](/android-security-pt-5)* 



### intro
In the previous posts in this series we've discussed a slew of security features on Android, mostly focusing on protecting the user from malicious *software*. 

But how is the platform designed to protect the device itself against attacks? This is the question we will answer today.

### hardware attacks
If an attacker gains physical access to a device but isn't able to authenticate they may inspect the device components individually in an attempt to gain access to what is stored in storage or memory. Yes, this requires physically disassembling the device to some extent, and no, you're probably not at risk. But these types of attacks are very real in the case of high-profile data theft so Android includes fundamental protections against them. One of the best methods used to protect against hardware attacks is disk encryption. 

#### disk encryption
[Full disk encryption](https://source.android.com/security/encryption/full-disk.html){:target="_blank"} has been an Android feature since version 3.0. In theory, full disk encryption means that every block on the device is encrypted according to some secret key tied to the user's lock screen authentication information. When put into practice, some parts of the operating system must remain unencrypted so the device can offer the user the opportunity to decrypt the rest of the disk. As an added layer of protection, the key used for disk encryption is typically itself encrypted with a key encryption key (KEK), which is the key that is protected behind user authentication, and sometimes also behind secure hardware. You can read more about the authentication-encryption relationship in [this blog post](https://dustri.org/b/android-encryptions-resistance-against-bruteforce-explain-it-like-im-five.html){:target="_blank"}.

Here is a brief overview of the history of disk encryption on Android:
- 3.0 added support for full-disk encryption, encrypting all of the *userdata* partition, regardless of usage patterns.
- 5.0 added support for full-disk encryption with fast encrypt, which only encrypts used blocks.
- 7.0 added file-based encryption, which allows encryption of individual files with their own keys.
- 9.0 added metadata encryption, preventing access to file and directory metadata (creation time, size, permissions, etc).

With disk encryption and a secure authentication method, devices are significantly more secure against attackers who gain physical access to them 

### device boot
The *bootloader* is the first bit of code that runs when a device is started. Its job is to initialize all device components, kick off the operating system, and potentially provide a non-UI interface for OSless configuration. As you might expect, most of the time the bootloader is designed specifically for the hardware it runs on. So the OEM typically decides what kind of protections exist at this level.

Thankfully, all consumer devices (at least that I'm aware of) come with the bootloader *locked*. A locked bootloader doesn't allow new device images to be installed except for in special circumstances such as if the image to be installed was signed by the manufacturer themselves. A locked bootloader can be unlocked, but (again in most cases) the process involves a full format of the *userdata* partition, protecting any existing user data from an attacker unlocking the bootloader and installing a custom image. Usually you can relock the bootloader again after an image update and pretend everything is fine again.*

### recovery mode
In addition to the bootloader, devices may include a *recovery OS*, which handles similar tasks to the bootloader, but with more functionality. A recovery OS includes a kernel and usually some minimal UI to manage recovery or updates. Most modern desktop devices also include a recovery OS.

The recovery OS resides on its own *recovery* partition, providing a layer of separation from the main operating system. If an attacker has access to the bootloader, they can put the device in download mode and install a custom recovery OS. Many Android root tools such as [TWRP](https://twrp.me/about/){:target="_blank"} use this method to replace the recovery OS and allow root user access in the main OS. The recovery OS has access to other partitions, including the *userdata* partition, but if the *userdata* partition is encrypted it is protected from such an attack. However, the *system* partition is vulnerable to malicious rootkit installation, potentially even allowing an attacker remote access to the device. This type of attack can be prevented with the verified boot process, which uses an unchangeable hardware-backed key to verify that the *boot* partition hasn't been modified since signing.

### ui security
Android uses a *lockscreen* application to protect the user interface from unauthorized users. It is shown to the user each time the device is powered on or brought out of sleeping (when the screen is turned on). The lockscreen application is rendered above all other application-level UI components and intercepts hardware keypresses, preventing at a basic level UI attacks. As stated above, the lockscreen authentication data is used to derive the KEK for disk encryption, so the encryption is only as good as the authentication method.

Many unlock methods are offered by Android, and some devices allow multiple methods to be active at once. Fingerprint readers and face authentication have been rising in popularity recently, but devices typically still offer password or pin unlock methods as well.

Protection against brute-force UI attacks is as simple as enforcing timeouts after so many attempts. This may vary by device, but typically endless attempts are not allowed without significant wait times between. It's a simple approach, but it works.

<!-- ### adb security
#### why secure the debugging interface?
#### current protections -->

### conclusion
Our phones contain some of the most sensitive information about us, and protecting against loss or theft is just as important as protecting against malicious software. As these devices become more essential to and prevalent in our personal, social, and vocational lives, people will want more assurance that their information is protected against bad actors. Google does a great job at improving device security with each iteration of Android, but an augmented reality future requires that each of these systems be adjusted to meet much more diverse usage patterns and protect sensitive user data.


*_This is what happens behind the scenes when a custom image is installed on a device. The bootloader is unlocked, a new image is installed, and the bootloader is relocked._
