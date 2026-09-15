---
layout: post
date: 2025-05-09
inline: true
related_posts: false
---

{% assign award = site.data.academic_profile.awards | where: 'id', 'emerging_scholar_2025' | first %}
Received the [_`{{ award.year }} {{ award.title }}`_]({{ award.url }}) from the {{ award.organization }} (NTHU).
