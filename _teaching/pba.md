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
communication: "Lecture slides and R scripts are posted on this page under <strong>Materials</strong> as the course progresses. In-class exercises, assignments, grades, and announcements are on <strong><a href=\"https://eeclass.nthu.edu.tw/\" target=\"_blank\" rel=\"noopener noreferrer\">eeclass</a></strong> (NTHU's learning platform; enrolled students are added automatically). For private matters, email the instructor."

updates_note: "This page is updated during the semester. Recently changed items are listed below."

updates:
  - text: "<strong>Sep 14, 2026:</strong> The existing reading list has been clarified across the weekly schedule: <strong>Required reading</strong> identifies preparation for each class, and <strong>Further reading</strong> provides optional references. Direct links and section ranges make the free readings easier to find. An R Basics companion handout adds explanations and worked examples to the reference slides under <strong>Materials</strong>."
  - text: "<strong>Sep 13, 2026:</strong> Lecture slides and R scripts are now posted on this page under <strong>Materials</strong>, starting with Week 2 (<strong>Data Visualization</strong>) and the R Basics reference slides that accompany the Week 1 readings (AAG Ch. 4–6). Week 3 is <strong>Data Wrangling</strong>; there is no class on <strong>Sep 28</strong> (Teachers' Day); exercise E3 is in Week 5."
  - text: "<strong>Sep 6, 2026:</strong> Fall 2026 page published. No class meeting on <strong>Sep 28</strong> (Teachers' Day) and <strong>Oct 26</strong> (Retrocession Day observed); the schedule already reflects this."
  - text: "<strong>No take-home quizzes this year.</strong> The 5% \"Quizzes &amp; In-Class Exercises\" component consists of five in-class exercises (1% each), submitted on eeclass the same day."
  - text: "<strong>Project showcase with Q&amp;A</strong> in the final week."
  - text: "<strong>ISS4066, Mondays.</strong> Graduate students should enroll in <a href=\"/teaching/pba-grad/\">ISS5066 (Graduate)</a>."

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
  - title: "Week 1: Course Introduction and R Programming Basics"
    url: "/assets/courses/pba/PBA_01_Course_Intro_UG.pdf"
  - title: "Week 1(b): R Basics (reference)"
    url: "/assets/courses/pba/PBA_00_R_Basics_Reference.pdf"
    handout_url: "/assets/courses/pba/PBA_00_R_Basics_Handout.pdf"
    script_url: "/assets/courses/pba/PBA_R_Basics_Companion.R"
  - title: "Week 2: Data Visualization"
    url: "/assets/courses/pba/PBA_02_Data_Visualization.pdf"
    script_url: "/assets/courses/pba/PBA_02_Data_Visualization.R"
  - title: "Week 3: Data Wrangling with dplyr"
  - title: "Week 4: No class (Teachers' Day)"
  - title: "Week 5: Causality"
  - title: "Week 6: Relationships, Importing, and Tidying Data"
  - title: "Week 7: Prediction and Iteration"
  - title: "Week 8: No class (Retrocession Day observed)"
  - title: "Week 9: Regression and Model Fit"
  - title: "Week 10: More on Regression"
  - title: "Week 11: Sampling and Sampling Distributions"
  - title: "Week 12: The Bootstrap and Confidence Intervals"
  - title: "Week 13: Hypothesis Testing"
  - title: "Week 14: Models of Uncertainty"
  - title: "Week 15: Inference for Regression"
  - title: "Week 16: Project Showcase, Q&A, and Peer Evaluation"

schedule_content: |
  ## Weekly Schedule (Undergraduate, Mondays)

  *Assignments are due before class starts (14:20); Sunday deadlines are 23:59. Two Mondays are university holidays with no make-up class (Sep 28, Oct 26). The schedule is tentative; eeclass announcements take precedence. Use the resource links under each week to open slides and handouts or download R scripts.*

  **Before every class:** complete that week's **Required reading** and work through the examples, including any R code. This preparation is expected in the syllabus and supports your participation in class discussions and exercises. **Further reading** is optional. All required readings are freely accessible online.

  ### Part I: Working with Data in R

  **Week 1 (Sep 7): Course Introduction and R Programming Basics**
  <a class="badge-slides" href="/assets/courses/pba/PBA_01_Course_Intro_UG.pdf">Slides</a> <a class="badge-slides" href="/assets/courses/pba/PBA_00_R_Basics_Reference.pdf">R basics (reference)</a> <a class="badge-slides" href="/assets/courses/pba/PBA_00_R_Basics_Handout.pdf">R basics (handout)</a>
  - Course aims, organization, and expectations
  - Working in R and RStudio: objects, functions, and packages
  - Reproducible reports with Quarto
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [MD §§1.1–1.4](https://moderndive.com/1-getting-started.html#r-rstudio) (R/RStudio, objects, functions, packages, and data frames). Install R and RStudio before class.
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> AAG §§4.3, 5, 6 (R basics); VT Ch. 1–2 (working with and communicating data).

  **R Basics reference materials:** The reference slides and companion handout under Materials cover operators, data types, data structures, and writing functions, with explanations and examples to consult throughout the semester.
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Self-introduction on the eeclass discussion board by Fri Sep 11</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Swirl tutorials 1–3 by Week 2</em>
  </div>

  **Week 2 (Sep 14): Data Visualization**
  <a class="badge-slides" href="/assets/courses/pba/PBA_02_Data_Visualization.pdf">Slides</a> <a class="badge-slides" href="/assets/courses/pba/PBA_02_Data_Visualization.R" download>R script</a>
  - Exploring college education and poverty in Midwest counties
  - Building plots layer by layer with ggplot2: geoms, labels, scales, and mapping versus setting aesthetics
  - Comparing distributions with histograms, density plots, boxplots, and facets
  - Plotting grouped data and trends over time with Gapminder
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [MD §§1.2–1.4](https://moderndive.com/1-getting-started.html#code) (review); [MD §§2.1–2.7](https://moderndive.com/2-viz.html#grammarofgraphics) (grammar of graphics, scatterplots, line graphs, histograms, facets, and boxplots).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> AAG §7.2 (ggplot2); AAG Ch. 3–5 (additional R background); VT Ch. 3–4 (tools and patterns over time).
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>In-class exercise E1 (gapminder)</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Assignment 1 released</em><br>
  <span class="badge-due">Due:</span> Group formation survey, Sun Sep 20
  </div>

  **Week 3 (Sep 21): Data Wrangling with dplyr**
  - Operating on rows, columns, and groups
  - Bar plots
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [MD §§3.1–3.6](https://moderndive.com/3-wrangling.html#piping), [MD §3.8](https://moderndive.com/3-wrangling.html#other-verbs) (pipes, filtering, summaries, groups, new variables, sorting, and selecting columns); [MD §2.8](https://moderndive.com/2-viz.html#geombar) (bar plots).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> AAG §§12.1–12.9 (dplyr); VT Ch. 7 (visual comparisons).
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>In-class exercise E2</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>GitHub setup guide posted</em>
  </div>

  **Week 4 (Sep 28): No class (Teachers' Day)**
  - Use the week for Assignment 1, the R basics reference slides, and swirl; TAs hold office hours as usual


  ### Part II: Causality, Prediction, and Regression

  **Week 5 (Oct 5): Causality**
  - What is a causal effect?
  - Randomized experiments; calculating effects
  - Observational studies
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [IMS §§2.2–2.3](https://openintro-ims1.netlify.app/data-design#experiments) (experiments and observational studies); course notes on potential outcomes, average treatment effects, and comparisons of group means (to be posted before class).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> QSS §§2.1–2.5.
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>In-class exercise E3</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>20-minute debrief of E3</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Assignment 2 released</em><br>
  <span class="badge-due">Due:</span> Assignment 1<br>
  <span class="badge-due">Due:</span> Milestone 1: GitHub repository, Sun Oct 11
  </div>

  **Week 6 (Oct 12): Relationships, Importing, and Tidying Data**
  - Z-scores and correlation
  - Writing reusable functions for standardization
  - Pivoting longer; joining datasets
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [MD §§4.1–4.2](https://moderndive.com/4-tidy.html#csv) (importing and tidy data); [MD §§3.7.1–3.7.3](https://moderndive.com/3-wrangling.html#matching-key-variable-names) (joins); [MD §5.1.1](https://moderndive.com/5-regression.html#model1EDA) (correlation); [IMS §13.2.2](https://openintro-ims1.netlify.app/foundations-mathematical#standardizing-with-z-scores) (Z-scores).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> AAG §§6.1, 15.2–15.3, 18.2; QSS §§3.5–3.6.
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Optional, Oct 12–23: <a href="https://calendar.app.google/AkutVLBQks1gnJ9a7" target="_blank" rel="noopener noreferrer">book a slot via Google Calendar</a> to discuss your research question before the proposal</em><br>
  <span class="badge-due">Due:</span> Milestone 2: data and proposal, Sun Oct 25
  </div>

  **Week 7 (Oct 19): Prediction and Iteration**
  - Predicting election outcomes
  - Loops; evaluating predictions; time-series plots
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> Course notes and R examples on election prediction, loops, and storing and evaluating predictions (to be posted before class); review [MD §2.4](https://moderndive.com/2-viz.html#linegraphs) (line graphs).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> QSS §4.1; AAG Ch. 10 (loops); VT Ch. 4 (patterns over time).

  **Week 8 (Oct 26): No class (Retrocession Day observed)**

  **Week 9 (Nov 2): Regression and Model Fit**
  - Modeling with a line; linear regression in R
  - Model fit
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [MD §5.1](https://moderndive.com/5-regression.html#model1) and [MD §5.3.2](https://moderndive.com/5-regression.html#leastsquares) (linear regression, fitted values, residuals, and least squares); [IMS §7.2.5](https://openintro-ims1.netlify.app/model-slr#r-squared) (R-squared).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> QSS §§4.2.1–4.2.4, 4.2.6; [IMS §§7.1–7.3](https://openintro-ims1.netlify.app/model-slr#fit-line-res-cor) for additional explanation and practice.
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Assignment 3 and Problem Set 1 (IMS Ch. 7) released</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Course withdrawal period Nov 2–20</em><br>
  <span class="badge-due">Due:</span> Assignment 2
  </div>

  **Week 10 (Nov 9): More on Regression**
  - Multiple regression
  - Categorical predictors
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [MD §5.2](https://moderndive.com/5-regression.html#model2) (categorical predictors); [MD §§6.1–6.2](https://moderndive.com/6-multiple-regression.html#model4) (multiple regression).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> QSS §§4.2.6–4.3.2; [MD §6.3](https://moderndive.com/6-multiple-regression.html#mult-reg-related-topics) (model comparison and related topics).
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>In-class exercise E4 (NYC condominiums)</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Problem Set 2 (IMS Ch. 8) released</em><br>
  <span class="badge-due">Due:</span> Problem Set 1, Sun Nov 15<br>
  <span class="badge-due">Due:</span> Milestone 3: first visualization, Sun Nov 15
  </div>

  ### Part III: Statistical Uncertainty

  **Week 11 (Nov 16): Sampling and Sampling Distributions**
  - Sampling framework
  - Random variables; the normal distribution and the central limit theorem
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [MD §§7.1–7.3](https://moderndive.com/7-sampling.html#sampling-activity) and [MD §7.5](https://moderndive.com/7-sampling.html#sampling-conclusion-central-limit-theorem) (sampling, sampling distributions, and the central limit theorem).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> [IMS §§13.1–13.3](https://openintro-ims1.netlify.app/foundations-mathematical#CLTsection) (normal models and standard errors).
  <div class="schedule-deliverables">
  <span class="badge-due">Due:</span> Assignment 3<br>
  <span class="badge-due">Due:</span> Problem Set 2, Sun Nov 22
  </div>

  **Week 12 (Nov 23): The Bootstrap and Confidence Intervals**
  - Resampling; bootstrap CIs for means and ATEs
  - Computing and interpreting CIs
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [MD §§8.1–8.5](https://moderndive.com/8-confidence-intervals.html#resampling-tactile) (resampling and confidence intervals); [IMS §20.2](https://openintro-ims1.netlify.app/inference-two-means#bootstrap-confidence-interval-for-the-difference-in-means) (bootstrap intervals for a difference in means).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> AAG §21.4; [MD §8.6](https://moderndive.com/8-confidence-intervals.html#case-study-two-prop-ci) (a worked comparison of two groups).
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Assignment 4 released</em>
  </div>

  **Week 13 (Nov 30): Hypothesis Testing**
  - Hypothesis tests with infer; two-sample and permutation tests
  - Issues with hypothesis testing; power
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [MD §§9.1–9.4](https://moderndive.com/9-hypothesis-testing.html#ht-activity) (randomization tests and interpretation); [IMS §20.1](https://openintro-ims1.netlify.app/inference-two-means#rand2mean) (two-means randomization test); [IMS §14.4](https://openintro-ims1.netlify.app/decerr#pow) (power).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> [MD §§9.5–9.6](https://moderndive.com/9-hypothesis-testing.html#ht-case-study) (worked example and issues with testing).
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>In-class exercise E5</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Problem Set 3 (IMS Ch. 11–12) released</em><br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Team consultations Nov 30–Dec 4: <a href="https://calendar.app.google/AkutVLBQks1gnJ9a7" target="_blank" rel="noopener noreferrer">book a slot via Google Calendar</a></em><br>
  <span class="badge-due">Due:</span> Milestone 4: first analysis, Sun Dec 6
  </div>

  **Week 14 (Dec 7): Models of Uncertainty**
  - Normal approximation and standard errors for confidence intervals and hypothesis tests
  - Comparing groups: confidence intervals and two-sample tests for experiments
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [IMS §§13.1–13.3](https://openintro-ims1.netlify.app/foundations-mathematical#CLTsection) and [IMS §13.6](https://openintro-ims1.netlify.app/foundations-mathematical#casestent) (normal models, standard errors, and confidence intervals); [IMS §20.4](https://openintro-ims1.netlify.app/inference-two-means#mathematical-model-for-estimating-the-difference-in-means) (intervals for a difference in means).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> [IMS §§13.4–13.5](https://openintro-ims1.netlify.app/foundations-mathematical#caseopp) (additional examples).
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Assignment 5 released</em><br>
  <span class="badge-due">Due:</span> Assignment 4<br>
  <span class="badge-due">Due:</span> Problem Set 3, Sun Dec 13
  </div>

  **Week 15 (Dec 14): Inference for Regression**
  - Uncertainty for regression coefficients
  - Presenting OLS regressions
  - <span class="badge-read badge-read-required"><i class="fas fa-book-open" aria-hidden="true"></i>Required reading:</span> [MD §§10.1–10.3](https://moderndive.com/10-inference-for-regression.html#regression-refresher) (regression tables, uncertainty, and conditions for inference); [IMS §25.1](https://openintro-ims1.netlify.app/inf-model-mlr#inf-mult-reg-soft) (multiple-regression output).
  - <span class="badge-read badge-read-optional"><i class="fas fa-book-open" aria-hidden="true"></i>Further reading (optional):</span> QSS §7.3; [MD §10.4](https://moderndive.com/10-inference-for-regression.html#infer-regression) (simulation-based inference).

  ### Part IV: Showcase

  **Week 16 (Dec 21): Project Showcase, Q&A, and Peer Evaluation**
  - Teams present at stations; the instructor and TAs rotate for Q&A
  - Peer evaluation
  - **Preparation:** Review the project instructions and evaluation rubric on eeclass, and prepare your presentation and responses to questions.
  <div class="schedule-deliverables">
  <span class="badge-due">Due:</span> Final report, Sun Dec 20<br>
  <span class="badge-due">Due:</span> Assignment 5, Sun Dec 27
  </div>


textbooks_content: |
  ## Reading Materials

  Completing the assigned reading before each class is part of your responsibility throughout the semester, as set out in the syllabus. The weekly schedule now distinguishes **Required reading (before class)** from **Further reading (optional)**. Work through the required sections and their examples, running any accompanying R code, and arrive ready to participate in discussions and exercises. Bring questions from your preparation so we can work through them in class.

  We learn R through practical data-analysis questions. Class time will focus on working through code, interpreting results, and making changes to answer new questions. Programming foundations such as objects, operators, data structures, and functions will be explained and revisited as we use them in visualization, data wrangling, and later analyses. Questions about these foundations are welcome throughout the course.

  ### Required reading: freely accessible resources

  - **[MD]** Ismay, Chester and Albert Y. Kim. [Statistical Inference via Data Science: A ModernDive into R and the Tidyverse](https://moderndive.com/1-getting-started.html). The schedule links to the first-edition online text and specifies the sections to read.
  - **[IMS]** Çetinkaya-Rundel, Mine and Johanna Hardin. 2021. [Introduction to Modern Statistics, 1st ed.](https://openintro-ims1.netlify.app/). OpenIntro. Use this linked edition for the section numbers in the reading list.
  - **Course materials:** lecture slides, R scripts, and handouts are linked under Materials. The [R Basics reference slides](/assets/courses/pba/PBA_00_R_Basics_Reference.pdf) and [companion handout](/assets/courses/pba/PBA_00_R_Basics_Handout.pdf) explain the programming foundations and remain available throughout the semester. Additional course notes named in the schedule will be posted before the relevant class.

  ### Further reading: optional references

  These books provide additional explanations and examples. Purchasing them is not required.

  - **[QSS]** Imai, Kosuke and Nora Webb Williams. 2022. *Quantitative Social Science: An Introduction in tidyverse*. Princeton University Press.
  - **[AAG]** Lander, Jared P. 2017. *R for Everyone: Advanced Analytics and Graphics*, 2nd ed. Addison-Wesley Professional.
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

  ### Sample Evaluation

  To give you a clear sense of expectations and grading criteria, here is a sample final report with the instructor's evaluation from last year's graduate section (names and student IDs removed):

  - [Sample Final Report (PDF)](/assets/courses/pba/PBA_Sample_Final_Report.pdf){:target="_blank"}: "Occupational Abilities and Wage Outcomes", a team project combining O*NET ability measures with BLS wage data, from visualization through regression to interpretation
  - [Sample Instructor Evaluation (PDF)](/assets/courses/pba/PBA_Sample_Evaluation.pdf){:target="_blank"}: rubric scores by section, comments, and suggestions (92/100)

  ### Project Milestones

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

This course teaches you to turn messy business data into defensible answers with R. You will learn to wrangle and visualize data, evaluate claims about causality, fit and interpret linear regressions, and quantify how much you should trust an estimate through sampling distributions, the bootstrap, confidence intervals, and hypothesis tests. We practice these methods with real datasets and simulated examples, and the semester culminates in a team project published as a portfolio-ready article with a public GitHub repository.

Agentic AI now writes much of the code. The skill that matters has shifted from writing code to directing and verifying it: without the underlying building blocks, you cannot tell when an analysis is wrong, and you end up steered by the tool rather than steering it. The course therefore builds programming and visualization foundations first, then turns to statistical inference, and every in-class exercise ends with a verification step.

This is the undergraduate course (ISS4066, Mondays). Graduate students take ISS5066 on Thursdays, which carries research-oriented project requirements. Students may not receive credit for both.

## Preparation and Participation

Completing the assigned reading before class is part of your responsibility **every week**, as set out in the syllabus. Follow the **Required reading** listed for each week in the **Schedule** tab, work through the examples, and run any accompanying R code. Class discussions and exercises build on this preparation, so come ready to use the ideas and discuss questions that arise from the reading.

We will use class time to work through analysis code, interpret results, compare approaches, and adapt examples to new questions. We will explain and revisit R fundamentals, including objects, operators, data structures, and functions, as we use them in visualization, data wrangling, and later topics. Questions about these foundations are welcome throughout the course.

Required readings are freely accessible online. **Further reading** is optional and provides additional explanation and depth; purchasing those books is not required. The **R Basics companion handout** provides fuller explanations and worked examples to consult as needed throughout the semester.

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

<div class="ta-grid">
  <div class="ta-card">
    <span class="ta-photo">
      <img src="/assets/courses/pba/ta_anh_tran.jpg" alt="Tuan Anh Tran" class="photo-clickable" data-full="/assets/courses/pba/ta_anh_tran.jpg">
    </span>
    <div class="ta-info">
      <p class="ta-name">Tuan Anh Tran</p>
      <p class="ta-affiliation">Ph.D. Student, ISS</p>
      <p class="ta-contact"><i class="fas fa-envelope"></i> anhtranpt [at] iss.nthu.edu.tw</p>
    </div>
  </div>
  <div class="ta-card">
    <span class="ta-photo">
      <img src="/assets/courses/pba/ta_daffa_onielda.jpg" alt="Daffa Onielda" class="photo-clickable" data-full="/assets/courses/pba/ta_daffa_onielda.jpg">
    </span>
    <div class="ta-info">
      <p class="ta-name">Daffa Onielda</p>
      <p class="ta-affiliation">IBBA</p>
      <p class="ta-contact"><i class="fas fa-envelope"></i> daffaonielda [at] gapp.nthu.edu.tw</p>
    </div>
  </div>
  <div class="ta-card">
    <span class="ta-photo">
      <img src="/assets/courses/pba/ta_tba.png" alt="Third teaching assistant, to be announced">
    </span>
    <div class="ta-info">
      <p class="ta-name">To be announced</p>
      <p class="ta-affiliation">Third teaching assistant, to be announced once enrollment is final (after the add/drop period, Sep 20)</p>
      <p class="ta-contact">&nbsp;</p>
    </div>
  </div>
</div>

## Course Platforms

| Purpose | Platform |
|:--------|:---------|
| Syllabus, weekly schedule, policies, lecture slides, R scripts | This website |
| Announcements, in-class exercise and assignment submissions, grades, discussion board | eeclass |
| Office hours and project consultations | [Google Calendar booking](https://calendar.app.google/AkutVLBQks1gnJ9a7) |
| Private matters | Email |
