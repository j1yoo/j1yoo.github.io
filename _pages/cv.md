---
layout: page # cv
permalink: /cv/
title: cv
nav: true
nav_order: 10
description: "Academic CV of Jaewon Yoo: education, publications, research experience, and professional activities."
subtitle: "Automatically generated from [website content](https://j1yoo.github.io) via [Jekyll](https://jekyllrb.com/), [Puppeteer](https://pptr.dev/), and [GitHub Actions](https://github.com/features/actions)."
# toc:
#   sidebar: left
---

{% assign cv_version = site.time | date: '%Y%m%d%H%M%S' %}
{% assign cv_pdf_url = '/assets/pdf/cv_jaewon.pdf' | relative_url | append: '?v=' | append: cv_version %}

<html>
  {% include cv_mobile_styles.liquid %}
  <style>
    .responsive {
      width: 100%;
      /* One US Letter page at the existing content width, plus viewer controls. */
      height: 56px;
      padding-bottom: 129.4118%;
      position: relative;
    }
    .responsive iframe {
      position: absolute;
      width: 100%;
      height: 100%;
    }

    /* Mobile: hide iframe (iOS Safari can't scroll multi-page PDFs in iframes) */
    @media (max-width: 768px) {
      .responsive {
        display: none;
      }
    }

    .last-updated {
      font-size: 0.9rem;
      color: #888;
      margin-bottom: 6px;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      cursor: default;
      transition: color 0.2s;
    }
    .last-updated:hover {
      color: #555;
    }
    .last-updated:hover .fa-rotate {
      animation: spin 1s linear infinite;
    }
    @keyframes spin { 100% { transform: rotate(360deg); } }

    /* Custom Theme Button to match al-folio bibliography style */
    .btn-theme {
      color: var(--global-text-color);
      border: 1px solid var(--global-text-color);
      background-color: transparent;
      text-decoration: none;
      transition: all 0.2s ease-in-out;
    }
    .btn-theme:hover {
      color: var(--global-theme-color) !important;
      border-color: var(--global-theme-color) !important;
      text-decoration: none;
    }
    .btn-theme:focus {
      box-shadow: none;
    }
  </style>

  {% if site.cv_preview %}
  <p style="border-left: 3px solid #a44b1d; padding: 10px 14px;">Local review copy — proposed CV update, not published.</p>
  {% endif %}
  <div style="text-align: center; margin-bottom: 20px;">
    <div class="last-updated" title="Date of the academic profile update" style="margin-bottom: 10px;">
      <i class="fa-solid fa-rotate"></i> Updated on {{ site.data.academic_profile.reviewed_on | date: "%B %d, %Y" }}
    </div>
    <div>
        <a href="{{ cv_pdf_url }}" class="btn btn-theme z-depth-0" target="_blank" rel="noopener">
            <i class="fas fa-file-pdf" aria-hidden="true"></i> Download/Open PDF
        </a>
    </div>
  </div>

  <!-- Desktop: Interactive PDF iframe -->
  <div class="responsive">
    <iframe title="Curriculum vitae of Jaewon Yoo" loading="lazy" src="{{ cv_pdf_url }}#page=1&view=Fit&navpanes=0"></iframe>
  </div>

  <div class="cv-mobile-document" aria-label="Curriculum vitae of Jaewon Yoo">
    {% include cv_body.liquid %}
  </div>

</html>
