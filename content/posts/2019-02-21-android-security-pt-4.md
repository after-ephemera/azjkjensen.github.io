---
title: "mobile security series part 4: network security"
categories:
  - programming
  - research
tags:
  - android
date: 2019-02-05T08:25:52-05:00
image: 
  path: "../images/network-security.png"
  thumbnail: "../images/network-security.png"
excerpt: ""
---

*This post is the fourth in a series on mobile security where we are exploring the Android platform, how security is approached in a mobile context, and what that means for future mobile platforms like AR and VR. [part 1](/android-security-pt-1) [part 2](/android-security-pt-2) [part 3](/android-security-pt-3)*

Network security is an enormous and ever-changing field, but some things have remained effectively constant for a while now. Except for the threat that quantum computing poses to it, high-complexity encryption has consistently been shown to protect sensitive data from prying eyes. This, for our purposes, is how Android manages network security. The mobile system is able to provide network protection through public key infrastructure ([PKI](https://en.wikipedia.org/wiki/Public_key_infrastructure)).

### pki
Public Key Infrastructure, commonly referred to as PKI, is a method for transmitting data between two parties securely, without either party's private key (similar to a password) being compromised. PKI works because of trapdoor functions, which are easy to compute in one direction, and difficult to compute in the other. One party can thus "lock" a message with the other's public key, but "unlocking" can be virtually impossible (depending on the length of the keys used). It is not my intention to describe the structure of encryption or why it works; there are many youtube videos out there that explain it concisely and in a way that most can understand. What we need to know is that 1. one party can seal messages and 2. the other party exclusively* can open them.

### tls and ssl
Transport Layer Security (TLS) and Secure Socket Layer (SSL) are commonly-used protocols designed to carry out secure exchanges of data between two computing environments, typically over a network like the internet. When you see the tiny lock next to the URL in your web browser, the website you are visiting uses one of these protocols. In reality every site should be secured like this. Tools like [Caddy](https://caddyserver.com/) make it extremely simple.

We won't delve into the details of certificate management, but it is both *robust* and *well thought out*. The user has no access to the system certificate store, but there are some modifications that can be made to add certificates to trusted zones. 

### keystore
Android provides APIs to make using cryptographic keys easy, but that isn't specifically applicable to the topic. Feel free to explore [the docs](https://developer.android.com/training/articles/keystore) to find out more about how to use them in your app.

### problems with the current way of doing things
Compromised certificates are a growing concern due to relatively [recent](https://en.wikipedia.org/wiki/DigiNotar) [events](https://en.wikipedia.org/wiki/Verisign). Since the entire trust of the certificate system is based on CAs being reliable, if they are compromised the entire system goes to 0. A malicious party with the ability to issue fraudulent certificates has the power to install malware, monitor network access, and -- in the worst case -- gain root access to the target system. This is clearly a concern if that party were, say, the national government. 

At this point CAs aren't actually restricted by any automated system from issuing false certificates. Thus there is no system in place to track or monitor it either. 

One possible solution to these concerns is [DNSSEC](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions), which utilizes a sort of authentication system to verify domain lookup. Its utilization is sparse, but it seems like a good partial solution.

Another solution called *certificate pinning* whitelists some allowed DNSs that are assumed to be trusted. Of course this entails making sure that the provider of trusted sources is also trustworthy.

### conclusion
There is no easy solution when it comes to network security. The problems are broad and deep and growing. But encryption is a reliable buffer and should be used at every opportunity. Today's device hardware is optimized for it, making it easier than ever to secure network communication.


*_In reality, it is the **key** that makes PKI secure, so if the **key** is compromised, the entire exchange is compromised._
