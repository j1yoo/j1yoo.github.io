---
layout: page
permalink: /gallery/
title: photos
description: "Conferences, workshops, presentations, and the people around them."
nav: false
---

{% assign photo_albums = site.gallery_events | sort: "date" | reverse %}
{% assign conference_albums = photo_albums | where: "category", "conference" %}
{% assign talk_albums = photo_albums | where: "category", "talk" %}
{% assign hosted_albums = photo_albums | where: "category", "hosted" %}
{% assign award_albums = photo_albums | where: "category", "award" %}

<nav class="photo-filters" aria-label="Filter photo albums">
  <button class="photo-filter is-active" type="button" data-photo-filter="all" data-photo-filter-label="all" aria-pressed="true">
    all <span>{{ photo_albums.size }}</span>
  </button>
  <button class="photo-filter" type="button" data-photo-filter="conference" data-photo-filter-label="conferences and workshops" aria-pressed="false">
    conferences &amp; workshops <span>{{ conference_albums.size }}</span>
  </button>
  <button class="photo-filter" type="button" data-photo-filter="talk" data-photo-filter-label="invited talks" aria-pressed="false">
    invited talks <span>{{ talk_albums.size }}</span>
  </button>
  <button class="photo-filter" type="button" data-photo-filter="hosted" data-photo-filter-label="hosted seminars" aria-pressed="false">
    hosted seminars <span>{{ hosted_albums.size }}</span>
  </button>
  <button class="photo-filter" type="button" data-photo-filter="award" data-photo-filter-label="awards" aria-pressed="false">
    awards <span>{{ award_albums.size }}</span>
  </button>
</nav>
<p class="sr-only" id="photo-filter-status" aria-live="polite"></p>

<div class="photo-albums">
  {% for album in photo_albums %}
    <article class="photo-album" data-photo-category="{{ album.category }}">
      <a class="photo-album__cover" href="{{ album.url | relative_url }}">
        <img
          src="{{ album.img | relative_url }}"
          alt="{{ album.card_alt | default: album.title }}"
          loading="{% if forloop.index <= 3 %}eager{% else %}lazy{% endif %}"
          style="--photo-position: {{ album.cover_position | default: 'center' }};"
        >
      </a>
      <div class="photo-album__caption">
        <h2><a href="{{ album.url | relative_url }}">{{ album.title }}</a></h2>
        <p>
          {{ album.date | date: "%b %Y" }}
          · {{ album.location }} ·
          {{ album.photos.size }} {% if album.photos.size == 1 %}photo{% else %}photos{% endif %}
        </p>
      </div>
    </article>
  {% endfor %}
</div>

<script defer src="{{ '/assets/js/gallery-filter.js' | relative_url }}"></script>
