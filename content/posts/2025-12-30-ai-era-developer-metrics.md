+++
title = 'AI-Era Developer Metrics'
date = 2025-12-30T00:00:00-07:00
draft = false
+++


For a decade, the DORA metrics were our North Star. They gave us a standardized way to measure the performance of software delivery teams: Deployment Frequency, Lead Time for Changes, Change Failure Rate, and Mean Time to Recovery.

But the 2025 landscape looks different. With >90% of developers now using AI-assisted coding tools, our traditional metrics are starting to break.

The core issue is that DORA was designed for a world where code was expensive to write. In that world, the volume of code was a decent proxy for the volume of effort. Today, code is cheap. When an LLM can generate a significant pull request in seconds, the "writing" phase of development has essentially collapsed.

If we want to understand how a team is actually performing today, we have to look past the activity and focus on the outcome.

---

### Why DORA Metrics are Fading

DORA isn't "wrong," but it is increasingly becoming a measure of organizational bureaucracy rather than engineering health.

* **Lead Time for Changes:** This used to measure the efficiency of the entire pipeline. Now, because AI makes the "coding" part nearly instantaneous, this metric almost exclusively measures how long a human reviewer takes to click "Approve." It’s no longer a measure of dev performance; it’s a measure of meeting schedules.
* **Deployment Frequency:** This has become a vanity metric. It’s easy to game by having AI-assisted agents push dozens of small, automated PRs. High deployment frequency no longer guarantees high value; it often just indicates high noise.
* **Change Failure Rate:** In the AI era, this is often too lagging. AI-generated code is frequently syntactically perfect but contextually flawed, leading to subtle regressions that don’t always trigger a "failed deployment" but do erode the user experience over time.

To navigate this, we need to simplify. In a world where we can generate code faster than we can understand it, only two metrics truly matter.

---

### 1. Mean Time to Prod (MTTP)

AI has solved the "blank page" problem, but it hasn't solved the shipping problem.

If a developer uses an AI tool to finish a feature in an hour, but that code sits in a queue for three days waiting for a review or a slow CI pipeline, the AI hasn't actually improved your delivery. It has simply increased your work-in-progress (WIP) and created a bottleneck.

**MTTP** is the ultimate diagnostic tool because it measures the friction of your *entire* system. If your MTTP is low, it means your automated tests are trustworthy and your review culture is responsive. If it’s high, it doesn't matter how many "AI-driven efficiencies" your developers claim—you aren't actually faster.

### 2. Number of Regressions

The primary risk of AI-assisted coding is context-blindness. LLMs are excellent at writing code that *looks* right but ignores legacy edge cases or architectural constraints.

If your team is shipping faster but your **Number of Regressions** is climbing, you aren't actually more productive. You are simply trading development time for debugging time. This metric acts as the necessary counterbalance to the speed of AI. It measures the "trustworthiness" of your augmented workflow. If you can maintain a low regression rate while code volume increases, your team has successfully integrated AI into a robust QA process.

---

### The Shift to Outcome

When code generation becomes a commodity, the value of an engineer shifts from being a "writer of code" to being a "reviewer of systems."

We have to stop measuring the activity of coding. Activity is now cheap. We need to start measuring the flow of value and the stability of the system. If you keep your MTTP low and your regressions near zero, the specifics of how the code was generated—whether by hand or by a prompt—become secondary to the fact that the system is working.


