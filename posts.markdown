---
layout: default
title: Posts
permalink: /JaewonYoo/Posts/
---

<table>
  {% for post in site.posts %}
    <tr>
      <td><span style="color:grey">{{ post.date | date:"%Y-%m-%d" }}: </span></td>
      <td><a href="{{ post.url }}" target="_blank">{{ post.title }}</a></td>
    </tr>
  {% endfor %}
</table>
