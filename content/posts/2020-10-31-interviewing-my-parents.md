---
title: "interviewing my parents"
categories:
  - goals
tags:
  - monthly-goals
date: 2020-10-31T09:25:52-05:00
image: 
  path: "../images/parents.png"
  thumbnail: "../images/parents.png"
excerpt: ""
---


Every day in the month of May I conducted recorded interviews with my parents. We faced a host of technical difficulties and sometimes I lost several minutes' worth of precious recording because of them. Here are some interesting lessons I learned.

## a/v problems abounded
I have a new appreciation for people who live code or game on streaming platforms. Getting the audio and video right is tricky. 

The biggest challenge I faced trying to record interviews was making both the interviewer *and* the interviewee audible through the process. I was using my Macbook Pro to do this, and MacOS doesn't support threading streams together, so I had to install and configure a [kernel extension](https://rogueamoeba.com/freebies/soundflower/){:target="blank"} that would handle it for me. 

Setting up the stream every day was no small feat, and admittedly I missed steps some days. Plus, I was already committing between 30 minutes and an hour of interview time each day. I was usually pretty rushed trying to get it all setup beforehand. In retrospect this was a great opportunity to automate the process, but I didn't think of it at the time.

By the end I got things down pretty well. The process went something like this...
1. Connect my [external microphone](https://www.bluemic.com/en-us/products/spark-sl/){:target="blank"} to the computer.
2. Turn on power amplification on my [audio interface](https://focusrite.com/en/usb-audio-interface/scarlett/scarlett-2i2){:target="blank"}.
3. Tune mic levels to make sure I was audible but wasn't clipping.
4. Connect my external headphones (and Ariel's, if she was participating that day) to the computer/audio interface and set levels.
5. Select threaded input streams to record both computer audio (my parents' voices) and microphone audio (our voices).
6. Select threaded output streams to enable hearing the other end of the call through both sets of headphones.
7. Test end-to-end setup by recording (~10 seconds) the screen while playing audio on the computer and speaking into the microphone.
8. Go back through previous steps if anything was wrong.
9. Call my parents on Messenger.
10. Do one additional screen recording (~10 seconds) to sanity-check setup correctness.
11. Conduct interview.
12. Copy video file to external storage (file size added up quickly).

Some days I ended up debugging for >30 additional minutes because something was up with the kernel extension, a cable was not connected properly, or the universe just decided to be against me that day. A few days, I ended up giving up and settled on a subpar recording, where my voice was barely audible or I turned off my camera.

Things I could have done differently:
- **Use different screen recording software**. If I tried to record a 4k screencap on my external monitor, things started falling apart (presumably because I was melting the CPU) and the stream would stop unexpectedly. I don't know for sure, but I'd guess that third-party software would improve my situation and give me more configurability than the standard *cmd+shift+5* Apple offers.
- **Use Zoom meeting recording**. The following month, Ariel made a similar plan and interviewed her parents each day. She opted to use Zoom's built-in recording feature and it usually worked well. I believe that Zoom accomplishes this so seamlessly by recording on one of their own servers instead of locally, but it came at the cost of quality and control. You can't beat easy though; Ariel could record with just her computer, no previous setup required.
- **Automate my setup**. Since we used the same computer we recorded with throughout our day, the configuration never carried over from one day to the next. I should have written code to do it for me, avoiding the headache of debugging and the inconsistency of remembering all of the setup steps.
- **Have a separate machine setup for recording**. In line with the previous thought, if I had a dedicated recording machine I could have set the audio and video up once and left it for the entire month. I already have too many computers around the house, so this should have been a no-brainer.

## saliency is king

Interviewing is a real skill, even when you're interviewing your parents. Having a natural conversation that also goes in the direction you're aiming for is even more challenging. When I began my month of interviewing, I was aiming to hear meaningful stories and build a record for my children and the generations that follow. This is much easier said than done.

For reference, here are a few of the "prompt questions" I started interviews off with:
- If you had to sum up your life advice into one sentence how would you do so? 
- What are the most valuable lessons you learned from your parents?
- What are your biggest regrets?
- What do you remember feeling during 9/11?

I found that the questions that provoked the (subjectively) best responses were the ones that were pointed and invoked feelings and thoughts rather than just events or memories. I got the most meaning when I heard *how* my parents experienced their lives, not just *what* they experienced. As the month went on I think we all got better at asking and answering and ultimately I can say it brought us closer in a time when closeness was needed most.

## family first

The content of our interviews was always meant to be personal. I don't intend to share any details publicly. But one theme seemed to encompass all 31 of our discussions. **My parents were fulfilled as people and successful as parents because they put our family first**. 

It seemed that in every stage of their life thus far, they found the most meaning in the connections they made with their family and the support family offers. My dad shared about his military childhood – a father who disciplined strictly and siblings who were stable friends in a dynamic life. My mom shared about working to be a world-class gymnast and her parents always sacrificing to support her goals. They both shared how the experience of making some of the most important decisions in their lives was colored and enriched by how it would affect our family as a whole. 

And, in reality, I know my parents care. That's such a privilege. Our month of daily – albeit sometimes ill-configured and poorly conducted – interviews made me recognize how much they care even more. 



