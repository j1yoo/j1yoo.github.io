// ============================================================
// Enhanced GA4 Custom Event Tracking
// 대상: j1yoo.github.io (개인+ECI) & cadi-lab.github.io (연구실)
//
// 수집하는 커스텀 이벤트:
//   pdf_download      - 논문/슬라이드 PDF 다운로드
//   outbound_click    - 외부 링크 클릭 (Google Scholar, GitHub 등)
//   content_interest  - Research/Blog 개별 항목 클릭
//   scroll_depth      - 스크롤 깊이 (25/50/75/100%)
//   cv_download       - CV 다운로드
//   contact_click     - 이메일 링크 클릭
//   navigation_click  - 네비게이션 메뉴 클릭
//   time_on_page      - 체류 시간 (30s/1m/3m/5m)
//   slide_download    - 강의 슬라이드 다운로드 (ECI 페이지)
//   course_material   - 강의 자료 접근 (ECI 페이지)
//   lab_interest      - 연구실 관심 (CADI Lab: Join Us, People 등)
// ============================================================

document.addEventListener('DOMContentLoaded', function () {
  // Safety check: gtag must exist
  if (typeof gtag !== 'function') return;

  var currentPath = window.location.pathname;
  var currentHost = window.location.hostname;
  // NOTE: do NOT pass `page_location: currentPath` to gtag events. GA4 expects
  // `page_location` to be a full URL; passing just a path strips the hostname
  // and produces empty/NaN hostname rows in GA4 reports. GA4 auto-collects
  // page_location from window.location.href when omitted, which is what we want.

  // ---------------------------------------------------------
  // 1. PDF Download Tracking
  // ---------------------------------------------------------
  // Course-material links point to the loader (/teaching/material/?file=...); the file itself is in
  // data-material-path, so the name and course come from there when it is present.
  document.querySelectorAll('a[href$=".pdf"], a[data-material-path$=".pdf" i]').forEach(function (link) {
    link.addEventListener('click', function () {
      var materialPath = this.getAttribute('data-material-path');
      var filePath = materialPath || this.pathname;
      var fileName = filePath.split('/').pop();
      var courseMatch = filePath.match(/\/assets\/courses\/([^/]+)\//);
      var isSlide = /slide|lecture|week|lec/i.test(fileName);
      var isSyllabus = /syllabus/i.test(fileName);

      gtag('event', 'pdf_download', {
        file_name: fileName,
        file_url: materialPath ? window.location.origin + materialPath : this.href,
        file_type: isSyllabus ? 'syllabus' : isSlide ? 'slide' : 'paper',
        course: courseMatch ? courseMatch[1] : 'none',
      });

      // 강의 슬라이드 별도 추적 (과목은 파일 경로에서)
      if (isSlide && currentPath.includes('/teaching/')) {
        gtag('event', 'slide_download', {
          file_name: fileName,
          course: courseMatch ? courseMatch[1] : 'eci',
        });
      }
    });
  });

  // ---------------------------------------------------------
  // 2. Outbound Link Click Tracking
  // ---------------------------------------------------------
  document.querySelectorAll('a[href^="http"]').forEach(function (link) {
    if (link.hostname !== window.location.hostname) {
      link.addEventListener('click', function () {
        gtag('event', 'outbound_click', {
          link_url: this.href,
          link_domain: this.hostname,
          link_text: this.textContent.trim().substring(0, 100),
        });
      });
    }
  });

  // ---------------------------------------------------------
  // 3. Content Interest Tracking (Research / Blog / Publications)
  // ---------------------------------------------------------
  var contentSelectors = '.publication, .paper, article, .post-card, .card, .project, .news-item';
  document.querySelectorAll(contentSelectors).forEach(function (item) {
    item.addEventListener('click', function () {
      var titleEl = this.querySelector('h2, h3, h4, .title, a');
      var contentType = 'other';
      if (currentPath.includes('/blog')) contentType = 'blog';
      else if (currentPath.includes('/research') || currentPath.includes('/publications')) contentType = 'research';
      else if (currentPath.includes('/projects')) contentType = 'project';

      gtag('event', 'content_interest', {
        content_title: titleEl ? titleEl.textContent.trim().substring(0, 150) : 'unknown',
        content_type: contentType,
      });
    });
  });

  // ---------------------------------------------------------
  // 4. Scroll Depth Tracking (25%, 50%, 75%, 100%)
  // ---------------------------------------------------------
  var scrollThresholds = [25, 50, 75, 100];
  var scrollFired = {};

  window.addEventListener('scroll', function () {
    var docHeight = document.body.scrollHeight - window.innerHeight;
    if (docHeight <= 0) return;
    var scrollPercent = Math.round((window.scrollY / docHeight) * 100);

    scrollThresholds.forEach(function (threshold) {
      if (scrollPercent >= threshold && !scrollFired[threshold]) {
        scrollFired[threshold] = true;
        gtag('event', 'scroll_depth', {
          depth_percentage: threshold,
          page_title: document.title,
        });
      }
    });
  });

  // ---------------------------------------------------------
  // 5. CV Download Tracking
  // ---------------------------------------------------------
  document.querySelectorAll('a[href*="cv" i], a[href*="resume" i]').forEach(function (link) {
    link.addEventListener('click', function () {
      gtag('event', 'cv_download', {
        file_url: this.href,
      });
    });
  });

  // ---------------------------------------------------------
  // 6. Contact / Email Click Tracking
  // ---------------------------------------------------------
  document.querySelectorAll('a[href^="mailto:"]').forEach(function (link) {
    link.addEventListener('click', function () {
      gtag('event', 'contact_click', {
        contact_method: 'email',
        site: currentHost,
      });
    });
  });

  // ---------------------------------------------------------
  // 7. Navigation Click Tracking
  // ---------------------------------------------------------
  document.querySelectorAll('nav a, .navbar a, .nav-link').forEach(function (link) {
    link.addEventListener('click', function () {
      gtag('event', 'navigation_click', {
        nav_target: this.textContent.trim(),
        nav_url: this.href,
        from_page: currentPath,
      });
    });
  });

  // ---------------------------------------------------------
  // 8. Time on Page (30s, 1m, 3m, 5m)
  // ---------------------------------------------------------
  var timeThresholds = [30, 60, 180, 300];
  var timeFired = {};
  var pageLoadTime = Date.now();

  setInterval(function () {
    var elapsed = Math.floor((Date.now() - pageLoadTime) / 1000);
    timeThresholds.forEach(function (threshold) {
      if (elapsed >= threshold && !timeFired[threshold]) {
        timeFired[threshold] = true;
        gtag('event', 'time_on_page', {
          seconds: threshold,
          page_title: document.title,
        });
      }
    });
  }, 5000);

  // ---------------------------------------------------------
  // 9. ECI Course-Specific: Lecture Material Access
  // ---------------------------------------------------------
  if (currentPath.includes('/teaching/eci')) {
    // 섹션 네비게이션 추적 (Overview, Schedule, Materials 등)
    document.querySelectorAll('a[href^="#"]').forEach(function (link) {
      link.addEventListener('click', function () {
        gtag('event', 'course_material', {
          section: this.textContent.trim(),
          course: 'eci',
          action: 'section_navigate',
        });
      });
    });
  }

  // ---------------------------------------------------------
  // 10. CADI Lab-Specific: Lab Interest Signals
  // ---------------------------------------------------------
  if (currentHost.includes('cadi-lab')) {
    // "Join Us" 또는 "People" 페이지 방문은 잠재 학생/포닥 신호
    if (currentPath.includes('/join') || currentPath.includes('/people') || currentPath.includes('/contact')) {
      gtag('event', 'lab_interest', {
        interest_type: currentPath.includes('/join') ? 'recruitment' : currentPath.includes('/people') ? 'team_browse' : 'contact',
      });
    }
  }
});
