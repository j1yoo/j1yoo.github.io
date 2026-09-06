---
layout: course-eci
order: 1
title: "Programming for Business Analytics (Undergraduate)"
description: "An undergraduate introduction to data analysis with R for business: wrangling and visualizing data, evaluating causal claims, linear regression, and quantifying uncertainty."
semester: "Fall 2026"
semester_dates: "Sep 7 – Dec 26, 2026"
first_offered: "Fall 2021"
course_number: "ISS4066"
series: "Skills"
accent: "#2698ba"
logo: /assets/courses/pba/pba_badge.png
favicon_base: /assets/courses/pba/pba_favicon
og_image: https://j1yoo.github.io/assets/courses/pba/pba_badge.png
permalink: /teaching/pba/
day: "Monday"
time: "14:20–17:20"
location: "TSMC Bldg. R421"
instructor_office: "TSMC Bldg. R828B"
instructor_email: "jaewon.yoo [at] iss.nthu.edu.tw"
communication: "Lecture slides, handouts, in-class exercises, assignments, and grades are on <strong><a href=\"https://eeclass.nthu.edu.tw/\" target=\"_blank\" rel=\"noopener noreferrer\">eeclass</a></strong> (NTHU's learning platform; enrolled students are added automatically). Announcements go out through eeclass. For private matters, email the instructor. Slides are not posted on this public page."

updates_note: "This page is updated during the semester. Recently changed items are listed below."

updates:
  - text: "<strong>ISS4066, Mondays.</strong> Graduate students should enroll in <a href=\"/teaching/pba-grad/\">ISS5066 (Graduate)</a>."
  - text: "<strong>Sep 6, 2026:</strong> Fall 2026 page published. No class meeting on <strong>Sep 28</strong> (Teachers' Day, taught asynchronously with recordings and exercise E3) and <strong>Oct 26</strong> (Retrocession Day observed); the schedule already reflects this."
  - text: "<strong>No take-home quizzes this year.</strong> The 5% \"Quizzes &amp; In-Class Exercises\" component consists of five in-class exercises (1% each), submitted on eeclass the same day."
  - text: "<strong>Project showcase with Q&amp;A</strong> in the final week."

syllabus: /assets/courses/pba/ISS4066_PBA_Undergrad_Syllabus_Fall_26.pdf

features:
  - title: "Data Wrangling & Viz"
    icon: "fas fa-chart-bar"
    description: "Transforming messy data into tidy formats and communicating insights with ggplot2."
  - title: "Causality & Regression"
    icon: "fas fa-balance-scale"
    description: "Evaluating causal claims and using simple and multiple linear regression."
  - title: "Statistical Uncertainty"
    icon_svg: "gaussian"
    description: "Sampling distributions, the bootstrap, confidence intervals, and hypothesis tests."
  - title: "Professional Workflow"
    icon: "fab fa-github"
    description: "R, RStudio, Quarto, git, and GitHub, plus directing and verifying AI-assisted analysis."

materials:
  - title: "Slides and handouts are distributed on eeclass to enrolled students (not posted here)."
  - title: "Week 1: Course Introduction and R Programming Basics"
  - title: "Week 2: Data Types, Data Structures, and Visualization I"
  - title: "Week 3: Functions and Visualization II"
  - title: "Week 4: Data Wrangling with dplyr (asynchronous week: recordings on eeclass)"
  - title: "Week 5: Causality"
  - title: "Week 6: Relationships, Importing, and Tidying Data"
  - title: "Week 7: Prediction and Iteration"
  - title: "Week 9: Regression and Model Fit"
  - title: "Week 10: More on Regression"
  - title: "Week 11: Sampling and Sampling Distributions"
  - title: "Week 12: The Bootstrap and Confidence Intervals"
  - title: "Week 13: Hypothesis Testing"
  - title: "Week 14: Models of Uncertainty"
  - title: "Week 15: Inference for Regression"

schedule_content: |
  ## Weekly Schedule (Undergraduate, Mondays)

  *Assignments are due before class starts (14:20); Sunday deadlines are 23:59. Two Mondays are university holidays with no make-up class (Sep 28, Oct 26); the week of Sep 28 is taught asynchronously. Readings should be completed before class. The schedule is tentative; eeclass announcements take precedence.*

  ### Part I: Working with Data in R

  **Week 1 (Sep 7): Course Introduction and R Programming Basics**
  - How the course works
  - A first look at R and RStudio; Quarto
  - Getting started: programming errors, operators, variables
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> MD Ch. 1; AAG Ch. 4.3, 5, 6; VT Ch. 1–2. Install R and RStudio before class.
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Self-introduction on the eeclass discussion board by Fri Sep 11</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Swirl tutorials 1–3 by Week 2</em>
  </div>

  **Week 2 (Sep 14): Data Types, Data Structures, and Visualization I**
  - Numeric, character, logical, factor, dates
  - Vectors, lists, data frames; reading data
  - Building plots by layers with ggplot2
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> MD Ch. 2; AAG Ch. 3, 4, 7.1, 9, 10, 27, 28; VT Ch. 3–4
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>In-class exercise E1</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Assignment 1 released</em><br>
  <span class="badge-due">Due:</span> Group formation survey, Sun Sep 20
  </div>

  **Week 3 (Sep 21): Functions and Visualization II**
  - Writing and reading functions
  - Histograms, facets, boxplots; principles of analytic graphics
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> AAG Ch. 7.2, 11; VT Ch. 5–6
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>In-class exercise E2 (gapminder)</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>GitHub setup guide posted</em>
  </div>

  **Week 4 (Sep 28): Data Wrangling with dplyr, asynchronous (Teachers' Day, no class meeting)**
  - Operating on rows, columns, and groups
  - Bar plots
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> AAG Ch. 14–16; VT Ch. 7; MD Ch. 3
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Watch the Lecture 5 recordings on eeclass; TAs hold extra office hours this week</em><br>
  <span class="badge-due">Due:</span> Exercise E3, Sun Oct 4
  </div>

  ### Part II: Causality, Prediction, and Regression

  **Week 5 (Oct 5): Causality**
  - What is a causal effect?
  - Randomized experiments; calculating effects
  - Observational studies
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> QSS Ch. 2.1–2.5
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>20-minute debrief of E3</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Assignment 2 released</em><br>
  <span class="badge-due">Due:</span> Assignment 1<br>
  <span class="badge-due">Due:</span> Milestone 1: GitHub repository, Sun Oct 11
  </div>

  **Week 6 (Oct 12): Relationships, Importing, and Tidying Data**
  - Z-scores and correlation
  - Pivoting longer; joining datasets
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> AAG Ch. 11; MD Ch. 4; QSS Ch. 3.5–3.6
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Optional, Oct 12–23: <a href="https://calendar.app.google/AkutVLBQks1gnJ9a7" target="_blank" rel="noopener noreferrer">book a slot via Google Calendar</a> to discuss your research question before the proposal</em><br>
  <span class="badge-due">Due:</span> Milestone 2: data and proposal, Sun Oct 25
  </div>

  **Week 7 (Oct 19): Prediction and Iteration**
  - Predicting election outcomes
  - Loops; evaluating predictions; time-series plots
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> AAG Ch. 4.7, 12; VT Ch. 8–9

  **Week 8 (Oct 26): No class (Retrocession Day observed)**

  **Week 9 (Nov 2): Regression and Model Fit**
  - Modeling with a line; linear regression in R
  - Model fit
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> MD Ch. 5; QSS Ch. 4.1, 4.2.1–4.2.4
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Assignment 3 and Problem Set 1 (IMS Ch. 7) released</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Course withdrawal period Nov 2–20</em><br>
  <span class="badge-due">Due:</span> Assignment 2
  </div>

  **Week 10 (Nov 9): More on Regression**
  - Multiple regression
  - Categorical predictors
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> MD Ch. 6.1–6.2; QSS Ch. 4.2.6–4.3.2
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>In-class exercise E4 (NYC condominiums)</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Problem Set 2 (IMS Ch. 8) released</em><br>
  <span class="badge-due">Due:</span> Problem Set 1, Sun Nov 15<br>
  <span class="badge-due">Due:</span> Milestone 3: first visualization, Sun Nov 15
  </div>

  ### Part III: Statistical Uncertainty

  **Week 11 (Nov 16): Sampling and Sampling Distributions**
  - Sampling framework
  - Random variables; the normal and the central limit theorem
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> MD Ch. 7
  <div class="schedule-deliverables">
  <span class="badge-due">Due:</span> Assignment 3<br>
  <span class="badge-due">Due:</span> Problem Set 2, Sun Nov 22
  </div>

  **Week 12 (Nov 23): The Bootstrap and Confidence Intervals**
  - Resampling; bootstrap CIs for means and ATEs
  - Computing and interpreting CIs
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> AAG Ch. 18–19; MD Ch. 8; IMS Ch. 12
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Assignment 4 released</em>
  </div>

  **Week 13 (Nov 30): Hypothesis Testing**
  - Hypothesis tests with infer; two-sample and permutation tests
  - Issues with hypothesis testing; power
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> MD Ch. 9; IMS Ch. 11
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>In-class exercise E5</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Problem Set 3 (IMS Ch. 11–12) released</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Team consultations Nov 30–Dec 4: <a href="https://calendar.app.google/AkutVLBQks1gnJ9a7" target="_blank" rel="noopener noreferrer">book a slot via Google Calendar</a></em><br>
  <span class="badge-due">Due:</span> Milestone 4: first analysis, Sun Dec 6
  </div>

  **Week 14 (Dec 7): Models of Uncertainty**
  - Using the normal for inference
  - CIs for experiments
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> IMS Ch. 13
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Assignment 5 released</em><br>
  <span class="badge-due">Due:</span> Assignment 4<br>
  <span class="badge-due">Due:</span> Problem Set 3, Sun Dec 13
  </div>

  **Week 15 (Dec 14): Inference for Regression**
  - Uncertainty for regression coefficients
  - Presenting OLS regressions
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> QSS Ch. 7.3

  ### Part IV: Showcase

  **Week 16 (Dec 21): Project Showcase, Q&A, and Peer Evaluation**
  - Teams present at stations; the instructor and TAs rotate for Q&A
  - Peer evaluation
  <div class="schedule-deliverables">
  <span class="badge-due">Due:</span> Final report, Sun Dec 20<br>
  <span class="badge-due">Due:</span> Assignment 5, Sun Dec 27
  </div>


textbooks_content: |
  ## Textbooks

  Readings are assigned from the following books (see the syllabus for the week-by-week list):

  - **[MD]** Ismay, Chester and Albert Y. Kim. 2022. [Statistical Inference via Data Science: A ModernDive into R and the Tidyverse](https://moderndive.com/).
  - **[QSS]** Imai, Kosuke and Nora Webb Williams. 2022. *Quantitative Social Science: An Introduction with Tidyverse*. Princeton University Press.
  - **[IMS]** Çetinkaya-Rundel, Mine and Johanna Hardin. 2021. [Introduction to Modern Statistics](https://openintro-ims.netlify.app/). OpenIntro.
  - **[AAG]** Lander, Jared P. 2017. *R for Everyone: Advanced Analytics and Graphics*, 2nd ed. O'Reilly.
  - **[VT]** Yau, Nathan. 2011. *Visualize This: The FlowingData Guide to Design, Visualization, and Statistics*. Wiley.

  ## Software

  - [R](https://cloud.r-project.org/) and [RStudio Desktop](https://posit.co/download/rstudio-desktop/). Visual Studio Code is fine as an editor.
  - Quarto (bundled with RStudio) for reproducible reports; git and GitHub for the final project.
  - AI tools (ChatGPT, Claude, Gemini, agentic coding assistants) are permitted and expected; see the AI use policy.

assignments_content: |
  ## Grading

  | Component | Weight |
  |:---|:---:|
  | Final project (report, showcase Q&A, milestones, peer evaluation) | 40% |
  | Assignments (5) | 20% |
  | Problem sets (3) | 15% |
  | In-class exercises (5) | 5% |
  | Attitude / participation | 10% |
  | Attendance | 10% |

  Within the final project: written report, showcase presentation with Q&A, four milestones, and peer evaluation. A rubric is provided on eeclass.

  ## Final Project

  A team project on a topic of your choice. Develop a research question, locate and prepare data (a pre-cleaned dataset from an R package is not sufficient), apply the methods from the course, and publish a portfolio-ready article or webpage with a linked GitHub repository containing all code.

  | Milestone | Due |
  |:---|:---|
  | GitHub repository | Sun Oct 11 |
  | Data and proposal | Sun Oct 25 |
  | First visualization | Sun Nov 15 |
  | First analysis | Sun Dec 6 |
  | Final report | Sun Dec 20 |
  | Showcase and Q&A | Mon Dec 21 |

  ## Assignments

  Five assignments, each a short Quarto report on a provided dataset applying the method just covered (data wrangling and visualization, causality, regression and prediction, the bootstrap, hypothesis testing). Late submissions lose 1 percentage point of the assignment's weight per day.

  ## Problem Sets

  Three problem sets drawn from *Introduction to Modern Statistics* (Ch. 7; Ch. 8; Ch. 11–12), submitted as a single PDF.

  ## In-Class Exercises

  Five short exercises done during class without generative AI and uploaded to eeclass the same day. Each ends with a verification step: check what your code actually did before you trust the output.

policies_content: |
  ## Course Policies

  ### AI Use Policy
  Students are permitted to use AI tools, including large language models and agentic coding assistants (e.g., ChatGPT, Claude, Gemini), for assignments and the final project. You are fully responsible for everything you submit. The final project is designed so that a high-quality result requires genuine understanding; AI accelerates competent work but does not substitute for it. However, it is imperative that the final submission predominantly reflects the student's understanding and personal input. Students who use AI tools must adhere to the following guidelines:

  - **Thorough explanation:** provide a detailed explanation of how the AI tool was used in completing the work.
  - **Original AI responses:** submit the original responses generated by the AI tool alongside your submission.
  - **Critical evaluation and personal input:** critically evaluate the AI-generated content and clearly indicate the portions modified or expanded with your own insights and understanding.
  - **Proper attribution:** give proper attribution to AI-generated content, clearly indicating the sections that are AI-generated.

  Attempting to cheat the system by relying heavily on AI-generated content without substantial personal input is ultimately the student's loss, as it undermines the learning process.

  In line with NTHU's Implementation Guidelines on AI Ethics Statements and Learning Assessment (Sep 2026): if AI use is identified but not disclosed as required, the work may be re-evaluated or assigned no credit. In-class exercises are completed without generative AI. When the instructor uses AI to produce teaching materials or learning resources, this is indicated in the materials. By enrolling in this course, students are considered to have agreed to this statement.

  ### Academic Honesty
  All submitted work must be your own. A first violation results in a zero for that assignment; subsequent violations result in a failing grade. Cheating, plagiarism, self-plagiarism, and misrepresentation of authorship all count. Submissions may be checked with Turnitin.

  ### Attendance and Participation
  Attend every class with your laptop. Attendance is recorded from Week 2 and counts for 10%; each missed class costs about 1% of the final grade. Notify the instructor or a TA before class if you must miss it. Participation is assessed through in-class discussion and the eeclass discussion board.
---

## Course Overview

This course teaches you to turn messy business data into defensible answers with R. You will learn to wrangle and visualize data, evaluate claims about causality, fit and interpret linear regressions, and quantify how much you should trust an estimate through sampling distributions, the bootstrap, confidence intervals, and hypothesis tests. Every method is practiced on real datasets, and the semester culminates in a team project published as a portfolio-ready article with a public GitHub repository.

Agentic AI now writes much of the code. The skill that matters has shifted from writing code to directing and verifying it: without the underlying building blocks, you cannot tell when an analysis is wrong, and you end up steered by the tool rather than steering it. The course therefore builds programming and visualization foundations first, then turns to statistical inference, and every in-class exercise ends with a verification step.

This is the undergraduate course (ISS4066, Mondays). Graduate students take ISS5066 on Thursdays, which carries research-oriented project requirements. Students may not receive credit for both.

## Learning Objectives

- **Data wrangling and visualization:** filter, summarize, group, join, and reshape data with the tidyverse, and build clear exploratory graphics with ggplot2.
- **Causality and regression:** distinguish randomized experiments from observational studies, and use simple and multiple linear regression to reach defensible conclusions.
- **Statistical uncertainty:** reason with sampling distributions, the bootstrap, confidence intervals, and hypothesis tests, including permutation tests and power.
- **Professional workflow:** R, RStudio, Quarto, git, and GitHub, plus the habit of checking what AI-assisted code actually did.

## Who Should Take This Course

No prerequisites. The course is designed for students from any background who want a working foundation in data analysis for business. Graduate students should enroll in ISS5066.

## Teaching Team

### Instructor

<div class="instructor-card">
  <img src="/assets/img/prof_jaewon_yoo.jpg" alt="Jaewon Yoo" class="photo-clickable" data-full="/assets/img/prof_jaewon_yoo.jpg">
  <div class="instructor-info">
    <p><strong><a href="https://j1yoo.github.io/" target="_blank" rel="noopener noreferrer">Jaewon Yoo</a></strong> · Assistant Professor</p>
    <p>Institute of Service Science, College of Technology Management<br>National Tsing Hua University</p>
    <ul class="info-list" style="margin-top: 0.5rem;">
      <li><i class="fas fa-door-open"></i> TSMC Bldg. R828B</li>
      <li><i class="fas fa-envelope"></i> jaewon.yoo [at] iss.nthu.edu.tw</li>
      <li><i class="fas fa-calendar-check"></i> Office hours by appointment: <a href="https://calendar.app.google/AkutVLBQks1gnJ9a7" target="_blank" rel="noopener noreferrer">book a slot via Google Calendar</a>.</li>
    </ul>
  </div>
</div>

### Teaching Assistants

| Name | Affiliation | Contact |
|:---|:---|:---|
| Tuan Anh Tran | Ph.D. student, ISS | anhtranpt [at] iss.nthu.edu.tw |
| Daffa Onielda | IBBA | daffaonielda [at] gapp.nthu.edu.tw |

## Course Platforms

| Purpose | Platform |
|:--------|:---------|
| Syllabus, weekly schedule, policies | This website |
| Slides, handouts, in-class exercises, assignment submissions, grades, announcements | eeclass |
| Office hours and project consultations | [Google Calendar booking](https://calendar.app.google/AkutVLBQks1gnJ9a7) |
| Private matters | Email |
