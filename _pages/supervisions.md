---
layout: page
permalink: /supervision/
title: supervision
description: "My thesis supervisions, past and present."
nav: true
nav_order: 8
---

> Students in my group are part of the <a href="https://cadi-lab.github.io" target="_blank" style="font-weight: bold;">CADI Lab</a>. Prospective students and collaborators can find more about our research directions and how to <a href="https://cadi-lab.github.io/join/" target="_blank">join us</a> on the lab page.
{:.research-question}

<div class="publications">
{%- assign students_by_year = site.data.supervision | group_by: 'year' | sort: 'name' | reverse -%}
{%- for year_group in students_by_year -%}
  <h2 class="year">{{ year_group.name }}</h2>
  {%- for student in year_group.items -%}
    <div id="{{ student.name | slugify }}" class="student-entry">
      {%- if student.photo -%}
        <!-- Circular photo layout (instructor-card style) -->
        <div class="student-row">
          <div class="student-photo">
            <img src="{{ student.photo | prepend: '/assets/img/student_photos/' | relative_url }}" alt="{{ student.name }}">
          </div>
          <div class="student-details">
            <div class="title"><strong>{{ student.name }}</strong></div>
            <div class="author">{{ student.info }}</div>
            {%- if student.thesis and student.thesis != "" -%}
            <div class="periodical">
              <em>Thesis title:</em> {{ student.thesis }}
            </div>
            {%- endif -%}
            {%- if student.note and student.note != "" -%}
            <div class="periodical">
              <em>Note:</em> {{ student.note }}
            </div>
            {%- endif -%}
            <div class="links">
            {%- if student.abstract and student.abstract != "" -%}
              <a class="abstract btn btn-sm z-depth-0" role="button">Abstract</a>
            {%- endif -%}
            {%- if student.thesis_url -%}
              <a href="{{ student.thesis_url }}" class="btn btn-sm z-depth-0" role="button" target="_blank" rel="external nofollow noopener">Thesis</a>
            {%- endif -%}
            {%- if student.linkedin -%}
              <a href="{{ student.linkedin }}" class="btn btn-sm z-depth-0" role="button" target="_blank" rel="external nofollow noopener">LinkedIn</a>
            {%- endif -%}
            {%- if student.github -%}
              <a href="{{ student.github }}" class="btn btn-sm z-depth-0" role="button" target="_blank" rel="external nofollow noopener">GitHub</a>
            {%- endif -%}
            {%- if student.cv -%}
              <a href="{{ student.cv }}" class="btn btn-sm z-depth-0" role="button" target="_blank" rel="external nofollow noopener">CV</a>
            {%- endif -%}
            {%- if student.website -%}
              <a href="{{ student.website }}" class="btn btn-sm z-depth-0" role="button" target="_blank" rel="external nofollow noopener">Website</a>
            {%- endif -%}
            </div>
            {%- if student.abstract and student.abstract != "" -%}
            <div class="abstract hidden">
              <p>{{ student.abstract }}</p>
            </div>
            {%- endif -%}
          </div>
        </div>
      {%- else -%}
        <!-- Clean single-column layout without photos/badges -->
        <!-- Student Name -->
        <div class="title"><strong>{{ student.name }}</strong></div>
        
        <!-- Institution Info -->
        <div class="author">{{ student.info }}</div>

        <!-- Thesis Title -->
        {%- if student.thesis and student.thesis != "" -%}
        <div class="periodical">
          <em>Thesis title:</em> {{ student.thesis }}
        </div>
        {%- endif -%}

        <!-- Co-supervision Note -->
        {%- if student.note and student.note != "" -%}
        <div class="periodical">
          <em>Note:</em> {{ student.note }}
        </div>
        {%- endif -%}

        <!-- Interactive Buttons -->
        <div class="links">
        {%- if student.abstract and student.abstract != "" -%}
          <a class="abstract btn btn-sm z-depth-0" role="button">Abstract</a>
        {%- endif -%}
        {%- if student.thesis_url -%}
          <a href="{{ student.thesis_url }}" class="btn btn-sm z-depth-0" role="button" target="_blank" rel="external nofollow noopener">Thesis</a>
        {%- endif -%}
        {%- if student.linkedin -%}
          <a href="{{ student.linkedin }}" class="btn btn-sm z-depth-0" role="button" target="_blank" rel="external nofollow noopener">LinkedIn</a>
        {%- endif -%}
        {%- if student.github -%}
          <a href="{{ student.github }}" class="btn btn-sm z-depth-0" role="button" target="_blank" rel="external nofollow noopener">GitHub</a>
        {%- endif -%}
        {%- if student.cv -%}
          <a href="{{ student.cv }}" class="btn btn-sm z-depth-0" role="button" target="_blank" rel="external nofollow noopener">CV</a>
        {%- endif -%}
        {%- if student.website -%}
          <a href="{{ student.website }}" class="btn btn-sm z-depth-0" role="button" target="_blank" rel="external nofollow noopener">Website</a>
        {%- endif -%}
        </div>

        <!-- Hidden Content Blocks -->
        {%- if student.abstract and student.abstract != "" -%}
        <div class="abstract hidden">
          <p>{{ student.abstract }}</p>
        </div>
        {%- endif -%}
      {%- endif -%}
    </div>
  {%- endfor -%}
{%- endfor -%}
</div>