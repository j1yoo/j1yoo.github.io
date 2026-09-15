---
layout: cv_clean
permalink: /cv_print/
title: Curriculum Vitae
nav: false
---

### Manuscripts in Revision
{% bibliography --query @*[kind=manuscripts in revision] --template bib_clean %}

### Manuscripts Under Review
{% bibliography --query @*[kind=manuscripts under review] --template bib_clean %}

### Working Papers
{% bibliography --query @*[kind=working papers] --template bib_clean %}

<div class="cv-subsection" markdown="1">

### Work in Progress
<p class="note"><em>Projects in development; authorship to be determined.</em></p>
{% bibliography --query @*[kind=work-in-progress] --template bib_clean %}

</div>

### Publications
{% bibliography --query @*[kind=publications] --template bib_clean %}
