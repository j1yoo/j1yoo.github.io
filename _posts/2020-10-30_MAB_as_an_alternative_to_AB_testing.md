---
layout: post
title: "Multi-Armed Bandit (MAB) as an Alternative to A/B Testing"
categories: misc
use_math: true
---

# Multi-Armed Bandit (MAB) as an Alternative to A/B Testing

Imagine an e-commerce retailer that wants to optimize its checkout process or an advertising agency that is trying to make an optimal advertising decision. This is often done in a *test-and-learn* framework via what is popularly known as A/B testing. In an A/B test, firms equally/randomly divide their customer base into two or more groups each of which are assigned to different versions of what is being tested, e.g., layouts in a landing page or ad versions (*explore* phase). After finishing the test, firms then use the best performing version of ad/layout (*exploit* phase). What this means is a large number of customers will be served a suboptimal variant during the test phase which inevitably generates an opportunity cost. Overcoming this apparent limitation, firms can do better by *earning-while-learning* using MAB ([Schwartz et al. 2017](https://pubsonline.informs.org/doi/10.1287/mksc.2016.1023)).

![Multi-Armed%20Bandit%20(MAB)%20as%20an%20Alternative%20to%20A%20B%20%20c3fd21ec9b4e4daf96f5af038bcb53cd/Untitled.png](Multi-Armed%20Bandit%20(MAB)%20as%20an%20Alternative%20to%20A%20B%20%20c3fd21ec9b4e4daf96f5af038bcb53cd/Untitled.png)

Illustration by Eric Nyquist (Source: [https://open.nytimes.com/how-the-new-york-times-is-experimenting-with-recommendation-algorithms-562f78624d26](https://open.nytimes.com/how-the-new-york-times-is-experimenting-with-recommendation-algorithms-562f78624d26))

MAB is a classic adoptive experimentation & a dynamic optimization problem ([Robin 1952](https://doi.org/10.1090/S0002-9904-1952-09620-8); [Thompson 1933](https://doi.org/10.1093/biomet/25.3-4.285)). In a business context, MAB can be used to answer questions like "how should advertising agencies decide what percentage of impressions to allocate to each digital ad version on an ongoing basis to maximize earning while learning?" At its core, these types of questions involve a trade-off between reward later (i.e., exploration) and reward now (i.e., exploitation). MAB alghrithms attempt to strike a balance between the two in a real-time basis to maximize the total reward while continuing to search for the variants that may perform better in the future.

**Schwartz et al. (2017)'s  Model Specification**

A firm has different versions of digital ads to serve on any of a set of websites. Let impressions be denoted by $m_{jkt}$  and conversions, by $y_{jkt}$, for ad $k$ on website $j$ in period $t$. 

$k = 1, 2, ..., K - 1, K$.

$j = 1, 2, ..., J - 1, J$. 
