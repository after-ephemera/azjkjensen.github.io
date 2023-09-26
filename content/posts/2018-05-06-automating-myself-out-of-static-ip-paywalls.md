---
title: "automating myself out of static IP paywalls"
categories:
  - programming
  - networking
tags:
  - python
image: 
  path: "../images/ship.png"
  thumbnail: "../images/ship-thumb.png"
date: 2018-05-06T14:25:52-05:00
excerpt: ""   
---

For a while I had an itch to set up my own home server. Not Plex or Kodi or anything like that. I just wanted a machine that I could access from anywhere and tinker with. I am by no means a network genius though; thus the itch went unscratched. Until now.

**Skip the prose and get to the code via this [Github repository](https://github.com/azjkjensen/cruiseshIP){:target="_blank"}.**

Let's start with a little background. 

Not long ago I volunteered at a meetup called [DevNano](https://www.meetup.com/Learn-Computer-Programming-DevNano/){:target="_blank"} in the heart of Silicon Slopes. I got the chance to help people of various ages and from a wide range of backgrounds learn to program from the ground up. It was incredible to see the dedication these people had to learn outside of their regular dayjobs. At one meeting we were discussing how the internet works and one of the instructors touched on dynamic vs. static IP addresses. Having worked in Network Operations for my school during my undergrad I was familiar with the concepts he taught. What I was not familiar with was that dynamic IP addresses aren't really all that dynamic. He said he ran a server from home and he didn't have a static IP address. The only inconvenience was that every few months he would have to adjust anything that pointed to the server. For home projects this is no problem; pet project SLOs are nonexistent so downtime is inconvenient but acceptable.

It turns out that even though the dynamic-ness of your IP address is up to your Internet Service Provider, it is in their best interest to leave it be for as long as they can (think about it: less moving parts, less coordination, less automated network management, less network devices, less power, less $$$). For the typical residential network this means that your IP address will only change under two conditions.

1. When your ISP is "required" to release the address they will do so and assign you a new one. The conditions for release are still fuzzy to me, but it almost seems arbitrarily chosen. Some say that ISPs do this simply to separate the residential and business tiers of service, but I haven't found a definitive answer on this. The important thing is that the "release and renew" process can happen anywhere from every few months to once every year or so.*

2. When your modem loses power for some (again arbitrary) period of time, it is likely that your previous IP address will get released and you will be assigned a new one when the modem regains power again. This is usually only a thing that happens when you manually need to reset the modem or there is a power outage.

So last week I decided to conduct an experiment if I could set up my home server without paying for my ISP's "business" tier, which is required if you want a static IP. The first step in this process was to make sure my router would forward a port on the public network to one on my private network.

On first attempt, I couldn't log into my local network router. The default credentials weren't correct, and I didn't know the credentials we established when the network was set up. After 30 minutes or so of trying both username/password combinations and security question answers, I finally got the security questions right. This is a good time to remind you that security question answers should be relatively secure, not something anyone could guess or search about you online. Once I put the right answers in, my router showed me the original password in plain text. 

At this point all I had to do was go into the port forwarding section on the router settings, set a public port to forward from, and select the device to forward to from a dropdown list of connected devices. For my first test I forwarded the port to my laptop's port 3000, set up a simple http server, and tried to access it from my phone without using wifi. Hoorah! It worked! This was a rewarding moment for the small amount of work it took to learn about and set up port forwarding. 

The next step was to set up a server on a device (that didn't have all of my schoolwork/personal information on it) that would stay connected to the home network. I had an old Dell Optiplex running Windows 10 lying around, so I decided to try that. I again ran some tests with port forwarding to the new machine, and it worked well. 

Finally I was at the point where I could write some code. Despite the research I had done I wasn't sure how often my IP address would change and I wanted to see if I could automate myself out of having to check it every day/month/few months. Some more reading and investigation led me to write this Python script, which I call cruiseshIP:

<script src="https://gist.github.com/azjkjensen/44296f08dc85e012d1147f496292f4d2.js"></script>
**Full code available at [github.com/azjkjensen/cruiseshIP](https://github.com/azjkjensen/cruiseshIP){:target="_blank"}**

My solution is simple. It uses the site [icanhazip.com](http://icanhazip.com){:target="_blank"} to determine my current IP address, and it compares that address with the previous one, written to a file. If they are the same, the script exits; but if they differ, it uses Python's standard library email module to send me an email** containing the new one.

The last thing I wanted to do was to schedule a cron job to run cruiseshIP periodically. The cron job will now run this script every day at midnight, and email me if a change occurs, allowing me to change anything pointing to the server within a day or so. 

This mini project provided me the opportunity to learn a little more about networking and to automate away a personal inconvenience. I had a lot of fun automating something real in my own life and I feel empowered to take on something a little bigger next time. 

--- 

\* *As a caveat to this rule, it sounds like some ISPs will release more often if there is significant amount of external traffic coming in to your public IP, so again for pet projects this shouldn't be a worry, but running a business (or anything that requires a real SLO)  on a dynamic IP address is likely not a good idea.* 

** *The email is unverified, so you may need to do as I did and create a whitelist filter to always let it through.*

--- 

*To make things easy I've provided a ```setup.sh``` bash script to set up a cron job for you. Follow the instructions over on [the repository](https://github.com/azjkjensen/cruiseshIP){:target="_blank"} to get it set up on your local machine, and please [reach out to me](/about) with any improvements on my design.*
