---
layout: page
permalink: /research/
title: research
description: The corresponding author is denoted by *. Video summaries 🎬 generated with NotebookLM. 
subtitle: >-
  Video summaries 🎬 generated with NotebookLM.<br>
  <span class="d-inline-block mt-2">The <strong>corresponding author</strong> is denoted by *.</span>
categories: ['manuscripts in revision', 'manuscripts under review', 'working papers', 'work-in-progress', 'publications']
catprint: ['', 'manuscripts in revision', 'manuscripts under review', 'working papers', 'work-in-progress', 'publications']
nav: true
nav_order: 2
---

<div class="publications">

  {% comment %} Set up dynamic years {% endcomment %}
  {% assign current_year = site.time | date: "%Y" | plus: 0 %}
  {% assign max_year = current_year | plus: 2 %}
  {% assign base_year = 2015 %}
  {% assign special_years = "current,forthcoming" | split: "," %}
  {% assign numeric_years = '' | split: '' %}
  {% for year in (base_year..max_year) reversed %}
    {% assign numeric_years = numeric_years | push: year %}
  {% endfor %}
  {% assign years = special_years | concat: numeric_years %}

  {% for cat_ in page.categories  %}
    {% assign ind = forloop.index %}
    {%- capture cat -%}
    <code>{{ page.catprint[ind] }}</code>
    {% if page.catprint[ind] == "work-in-progress" -%}
        <h6 class="mb-n4 mt-3 pt-2 mp-5">(correct authoring will be determined later)</h6>
    {% endif %}
    {%- endcapture -%}
    
    <h4 class="font-weight-bolder mb-n4 mt-5 mp-5">{{ cat }}</h4>
    {% for y in years %}
      {%- capture citecount -%}
        {% bibliography_count -f papers -q @*[kind={{ cat_ }} && year={{ y }}]* %}
      {%- endcapture -%}
  
      {% if citecount != "0" %}  
        {% bibliography -f papers -q @*[kind={{ cat_ }} && year={{ y }}]* %}
      {% endif %}
    {% endfor %}
  {% endfor %}

</div>
