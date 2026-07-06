---
layout: page
title: data
permalink: /data/
description: "Catalog of datasets held and maintained by the CADI Lab. Data marked 'on request' can be shared for research collaboration — prospective students and collaborators are encouraged to reach out."
nav: true
nav_order: 5
---

<div class="publications">
{% assign datasets_by_category = site.data.datasets | group_by: 'category' %}
{% for category_group in datasets_by_category %}
  <h2 class="year">{{ category_group.name }}</h2>
  <ul class="talks-list">
    {% for dataset in category_group.items %}
      <li class="mb-4">
        <div class="periodical">
          <b>{{ dataset.name }}</b>
          {% if dataset.status == "public" %}
            <span class="badge font-weight-bold success-color-dark text-uppercase align-middle">public</span>
          {% elsif dataset.status == "on-request" %}
            <span class="badge font-weight-bold primary-color-dark text-uppercase align-middle">on request</span>
          {% else %}
            <span class="badge font-weight-bold text-uppercase align-middle">proprietary</span>
          {% endif %}
        </div>
        <div class="periodical">
          {% if dataset.source %}{{ dataset.source }}.{% endif %}
          {% if dataset.period %} Coverage: {{ dataset.period }}.{% endif %}
          {% if dataset.unit %} Unit: {{ dataset.unit }}.{% endif %}
          {% if dataset.size %} Scale: {{ dataset.size }}.{% endif %}
        </div>
        {% if dataset.description %}
          <div class="periodical">{{ dataset.description }}</div>
        {% endif %}
        {% if dataset.link or dataset.related %}
          <div class="periodical">
            <em>
              {% if dataset.link %}<a href="{{ dataset.link }}" target="_blank" rel="noopener">Documentation / access</a>{% endif %}
              {% if dataset.link and dataset.related %}; {% endif %}
              {% if dataset.related %}
                {% for rel in dataset.related %}<a href="{{ rel.url | relative_url }}">{{ rel.text }}</a>{% unless forloop.last %}; {% endunless %}{% endfor %}
              {% endif %}
            </em>
          </div>
        {% endif %}
        {% if dataset.keywords %}
          <div class="periodical"><em>Keywords: {{ dataset.keywords | join: ", " }}</em></div>
        {% endif %}
      </li>
    {% endfor %}
  </ul>
{% endfor %}
</div>
