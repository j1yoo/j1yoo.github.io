---
layout: course-eci
title: Experiments and Causal Inference
description: A graduate seminar on experimental and quasi-experimental designs for causal inference.
semester: "Spring 2026"
semester_dates: "Feb 23 – Jun 15, 2026"
first_offered: "Spring 2022"
course_number: "ISS5096"
series: "Methods"
day: "Thursday"
time: "14:20–17:20"
location: "TSMC Bldg. R406"
instructor_office: "TSMC Bldg. R828B"
instructor_email: "jaewon.yoo [at] iss.nthu.edu.tw"
communication: "All course communication goes through <strong><a href=\"https://teams.microsoft.com/l/team/19%3AJP2R-tTEDQeUB1xDpd33-nu4Qo21bv_c8NkSr5XxMaM1%40thread.tacv2/conversations?groupId=b48faca7-6855-4284-b7ef-b9ba\" target=\"_blank\" rel=\"noopener noreferrer\">MS Teams</a></strong>. Homework submissions and grades are on <strong>Canvas</strong>. For private matters, email or DM the instructor."

updates_note: "I update the ECI GitHub Page regularly throughout the semester. Items below have been recently revised and need your attention."

updates:
  - text: "<strong>Paper presentations</strong> now follow a hybrid format: each student presents one paper live in class and one as a recorded video, with a short in-class round-table afterwards (see <strong>Evaluation</strong> → Paper Introduction Presentations)."
  - text: "<strong>AI Use Policy: useful guidance on using AI in academic writing.</strong> Practical insights added: risks to watch (cognitive offloading, voice homogenization) and practices that help (editor-not-rewriter mode, self-check question), with references to leading guides. <strong>Worth reading carefully</strong> before using AI tools on coursework (see <strong>Policies</strong> → AI Use Policy)."
  - text: "<strong>Lecture materials</strong> are being uploaded as the course progresses; check the <strong>Materials</strong> tab regularly for the latest slides, handouts, and written notes."
og_image: https://j1yoo.github.io/assets/courses/eci/eci_logo.png
syllabus: /assets/courses/eci/ECI_Syllabus.pdf
logo: /assets/courses/eci/eci_logo.png

features:
  - title: "RCT"
    icon: "fas fa-vial"
    description: "Design and analysis of randomized field experiments."
  - title: "Difference-in-Differences"
    icon: "fas fa-chart-line"
    description: "Causal inference with longitudinal data and staggered adoption."
  - title: "Matching Methods"
    icon: "fas fa-users"
    description: "Propensity Score (PSM) and Coarsened Exact Matching (CEM)."
  - title: "RDD"
    icon: "fas fa-cut"
    description: "Sharp and Fuzzy regression discontinuity designs."
  - title: "Causal ML"
    icon: "fas fa-robot"
    description: "Double-debiased ML (DML) and Heterogeneous Treatment Effects (HTE) with Meta-learners."
  - title: "DAGs & Mechanisms"
    icon: "fas fa-project-diagram"
    description: "Graphical models for identification and exploring causal mechanisms."

videos:
  - title: "Lecture 7: Noncompliance and Instrumental Variables"
    id: "8S06mqd6pTM"

materials:
  - title: "Lecture 1: Intro and Potential Outcomes"
    url: "/assets/courses/eci/ECI_01_Intro_and_Potential_Outcomes.pdf"
    handout_url: "/assets/courses/eci/ECI_01_Handout.pdf"
  - title: "Lecture 2: Randomization Inference"
    url: "/assets/courses/eci/ECI_02_Randomization_Inference.pdf"
    handout_url: "/assets/courses/eci/ECI_02_Handout.pdf"
  - title: "Lecture 3: Inference for ATE"
    url: "/assets/courses/eci/ECI_03_Inference_for_ATE.pdf"
    handout_url: "/assets/courses/eci/ECI_03_Handout.pdf"
  - title: "Lecture 4: Regression and Randomized Experiments"
    url: "/assets/courses/eci/ECI_04_Regression.pdf"
    handout_url: "/assets/courses/eci/ECI_04_Handout.pdf"
  - title: "Lecture 4(b): Stratified Randomized Experiments"
    url: "/assets/courses/eci/ECI_04b_Handout.pdf"
    handout_url: "/assets/courses/eci/ECI_04b_Handout.pdf"
  - title: "Lecture 5: Observational Studies"
    url: "/assets/courses/eci/ECI_05_Observational_Studies.pdf"
    handout_url: "/assets/courses/eci/ECI_05_Handout.pdf"
  - title: "Lecture 5(b): Partial Identification"
    url: "/assets/courses/eci/ECI_05b_Partial_Identification.pdf"
    handout_url: "/assets/courses/eci/ECI_05b_Handout.pdf"
  - title: "Lecture 6: DAGs"
    url: "/assets/courses/eci/ECI_06_DAGs.pdf"
    handout_url: "/assets/courses/eci/ECI_06_Handout.pdf"
  - title: "Lecture 6(b): Beyond Identifying τ"
    url: "/assets/courses/eci/ECI_06b_Handout.pdf"
    handout_url: "/assets/courses/eci/ECI_06b_Handout.pdf"
  - title: "Lecture 7: Noncompliance and IV"
    url: "/assets/courses/eci/ECI_07_Noncompliance_and_IV.pdf"
    handout_url: "/assets/courses/eci/ECI_07_Handout.pdf"
  - title: "Lecture 9: TSLS and Modern IV"
    url: "/assets/courses/eci/ECI_09_TSLS.pdf"
    handout_url: "/assets/courses/eci/ECI_09_Handout.pdf"
  - title: "Lecture 10: Panel Data and DID"
    url: "/assets/courses/eci/ECI_10_Panel_Data_and_DID.pdf"
    handout_url: "/assets/courses/eci/ECI_10_Handout.pdf"
  - title: "Lecture 10(b): Synthetic Control and Synthetic DiD"
    url: "/assets/courses/eci/ECI_10b_Handout.pdf"
    handout_url: "/assets/courses/eci/ECI_10b_Handout.pdf"
  - title: "Lecture 10(c): Strict Exogeneity in Panel Data"
    url: "/assets/courses/eci/ECI_10c_Handout.pdf"
    handout_url: "/assets/courses/eci/ECI_10c_Handout.pdf"
  - title: "Lecture 11: Matching Methods"
    url: "/assets/courses/eci/ECI_11_Matching_Methods.pdf"
    handout_url: "/assets/courses/eci/ECI_11_Handout.pdf"
  - title: "Lecture 11(b): Weighting Estimators"
    url: "/assets/courses/eci/ECI_11b_Weighting_Estimators.pdf"
    handout_url: "/assets/courses/eci/ECI_11b_Weighting_Estimators.pdf"
  - title: "Lecture 12 & 13: Sharp and Fuzzy RD"
    url: "/assets/courses/eci/ECI_12_Regression_Discontinuity_Designs.pdf"
    handout_url: "/assets/courses/eci/ECI_12_Handout.pdf"
  - title: "Lecture 14: Causal Mechanisms"
    url: "/assets/courses/eci/ECI_14_Causal_Mechanisms.pdf"
    handout_url: "/assets/courses/eci/ECI_14_Handout.pdf"

written_notes:
  - title: "Week 5: Observational Studies"
    url: "/assets/courses/eci/ECI_05_Notes.pdf"
  - title: "Week 7: Noncompliance and Instrumental Variables"
    url: "/assets/courses/eci/ECI_07_Notes.pdf"

schedule_content: |
  ## Weekly Schedule

  *Please refer to the [Syllabus PDF](/assets/courses/eci/ECI_Syllabus.pdf) for the most up-to-date schedule and full reading lists. Click the purple <span class="badge-slides" style="font-size:0.75rem; cursor:default;">Slides</span> badges to view lecture slides. <span class="badge-read" style="font-size:0.75rem; cursor:default;"><i class="fas fa-book-open"></i>Readings</span> should be completed **before** class. Items marked <span class="badge-due" style="font-size:0.75rem; cursor:default;">Due</span> must be submitted via Canvas **before** that week's class begins (Thu 14:20).*

  ### Part I: Foundations of Causal Inference

  **Week 1 (Feb 26): Introduction and Potential Outcomes**
  <a class="badge-slides" href="/assets/courses/eci/ECI_01_Intro_and_Potential_Outcomes.pdf">Slides</a>
  - Neyman-Rubin causal model
  - Fundamental problem of causal inference (FPOCI)
  - Causal estimands; Post-treatment bias under truncation by death
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 1; Angrist & Pischke Ch. 1; [Holland (1986)](https://www.jstor.org/stable/2289064)
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Group forming & ice breaking activities</em>
  </div>

  **Week 2 (Mar 5): Randomization Inference**
  <a class="badge-slides" href="/assets/courses/eci/ECI_02_Randomization_Inference.pdf">Slides</a>
  - Randomized experiments
  - Fisher's approach to inference, permutation tests
  - Sharp null, randomization distribution
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 5 (skim Ch. 4); Rosenbaum (2002) Ch. 2
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Find a collaborator for the group project</em><br>
  <span class="badge-due">Due:</span> <em>The Effect</em> CH 2: Research Questions
  </div>

  **Week 3 (Mar 12): Inference for the Average Treatment Effect**
  <a class="badge-slides" href="/assets/courses/eci/ECI_03_Inference_for_ATE.pdf">Slides</a>
  - Neyman's approach to inference for the ATE
  - Finite-sample vs superpopulation inference
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 6, 9, 10; Angrist & Pischke Ch. 2
  <div class="schedule-deliverables">
  <span class="badge-due">Due:</span> Problem Set 1 (Potential Outcomes)<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> CH 3: Describing Variables
  </div>

  **Week 4 (Mar 19): Linear Regression and Randomized Experiments**
  <a class="badge-slides" href="/assets/courses/eci/ECI_04_Regression.pdf">Slides</a>
  - Simple linear regression in experiments
  - Covariate adjustment in experiments with regression
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 7, 9, 10; [Lin (2013)](https://doi.org/10.1214/12-AOAS583); [Freedman (2008)](https://doi.org/10.1016/j.aam.2006.12.003)
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 1.1 and 1.2<br>
  <span class="badge-due">Due:</span> Problem Set 2 (Randomization Inference)<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> CH 4: Describing Relationships
  </div>

  ### Part II: Observational Studies

  **Week 5 (Mar 26): Individual/Group Project Meetings**
  - Schedule a meeting during office hours to discuss and materialize your project ideas.
  <div class="schedule-deliverables">
  <span class="badge-due">Due:</span> Problem Set 3 (Inference for the ATE)<br>
  <span class="badge-due">Due:</span> <strong>Project Proposal</strong> (half-page description)<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> CH 13: Regression
  </div>

  **Week 6 (Apr 2): School Holiday** *(no class)*
  <div class="schedule-deliverables">
  </div>

  **Week 7 (Apr 9): Observational Studies I**
  <a class="badge-slides" href="/assets/courses/eci/ECI_05_Observational_Studies.pdf">Slides</a>
  - Selection on observables
  - Regression for observational data
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Angrist & Pischke Ch. 3
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 1.3 and 1.4
  </div>

  **Week 8 (Apr 16): DAGs and Covariate Selection**
  <a class="badge-slides" href="/assets/courses/eci/ECI_06_DAGs.pdf">Slides</a>
  - DAGs and the back-door criterion
  - Partial identification
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 21–22; Morgan & Winship Ch. 4 *(handout provided)*
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 2.3 and 2.4<br>
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Construct a DAG for your own research project</em>
  </div>

  ### Part III: Quasi-Experimental Methods

  **Week 9 (Apr 23): Instrumental Variables I (Noncompliance and IV)**
  <a class="badge-slides" href="/assets/courses/eci/ECI_07_Noncompliance_and_IV.pdf">Slides</a>
  - Noncompliance and IV in observational studies
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 23–24; Angrist & Pischke Ch. 4
  <div class="schedule-deliverables">
  <span class="badge-due">Due:</span> <em>The Effect</em> CH 6 & 7 Exercises
  </div>

  **Week 10 (Apr 30): Instrumental Variables II (TSLS and Modern IV)**
  <a class="badge-slides" href="/assets/courses/eci/ECI_09_TSLS.pdf">Slides</a>
  - Two-stage least squares; weak-instrument inference (Stock-Yogo, Lee et al.\ 2022, Anderson-Rubin)
  - Modern IV via Machine Learning (PLIV, DRIV, DoubleML); Causal Forest IV demo on a digital advertising RCT
  - Review of IV applications
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentation: 2.5<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> CH 8: Causal Paths and Closing Back Doors
  </div>

  **Week 11 (May 7): Panel Data, Fixed Effects, and Difference-in-Differences**
  <a class="badge-slides" href="/assets/courses/eci/ECI_10_Panel_Data_and_DID.pdf">Slides</a>
  - Fixed effects and first differences
  - Difference-in-differences
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Angrist & Pischke Ch. 5; [Imai & Kim (2019)](https://doi.org/10.1111/ajps.12417)
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 3.1 and 3.2<br>
  <span class="badge-due">Due:</span> Problem Set 4 (Observational Studies)<br>
  <span class="badge-due">Due:</span> <strong>Progress Report</strong><br>
  <span class="badge-due">Due:</span> <em>The Effect</em> CH 19: Instrumental Variables
  </div>

  **Week 12 (May 14): Matching and Weighting Estimators**
  <a class="badge-slides" href="/assets/courses/eci/ECI_11_Matching_Methods.pdf">Slides</a> <a class="badge-slides" href="/assets/courses/eci/ECI_11b_Weighting_Estimators.pdf">Slides (b)</a>
  - Propensity scores, matching, and weighting
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 13, 15, 18; [Stuart (2010)](https://doi.org/10.1214/09-STS313)
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 4.1, 4.2, 4.3, and 4.4<br>
  <span class="badge-due">Due:</span> Problem Set 5 (Instrumental Variables)<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> CH 18: Difference-in-Differences
  </div>

  **Week 13 (May 21): Regression Discontinuity Designs**
  <a class="badge-slides" href="/assets/courses/eci/ECI_12_Regression_Discontinuity_Designs.pdf">Slides</a>
  - Sharp RD designs, identification
  - Estimation and bandwidth selection
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Angrist & Pischke Ch. 6; [Imbens & Lemieux (2008)](https://doi.org/10.1016/j.jeconom.2007.05.001)
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 5.1 and 5.2<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> CH 14: Matching
  </div>

  **Week 14 (May 28): Regression Discontinuity Designs Cont.**
  <a class="badge-slides" href="/assets/courses/eci/ECI_12_Regression_Discontinuity_Designs.pdf">Slides</a>
  - Fuzzy RD designs
  - Applications of RDDs
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> [Cattaneo, Idrobo & Titiunik (2020)](https://doi.org/10.1017/9781108684606)
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 5.3 and 5.4<br>
  <span class="badge-due">Due:</span> Problem Set 6 (Matching and Weighting Estimators)
  </div>

  ### Part IV: Advanced Topics & Research Workshop

  **Week 15 (Jun 4): Advanced Topics** <span style="font-size:0.78rem; color:#e67e22; font-weight:600;">TENTATIVE</span>
  - *One of the following topics will be covered (to be announced):*
  - **Option A (Causal Mechanisms):** Mediation analysis, controlled direct effects, natural direct and indirect effects <a class="badge-slides" href="/assets/courses/eci/ECI_14_Causal_Mechanisms.pdf">Slides</a>
      - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> [Imai, Keele & Yamamoto (2010)](https://doi.org/10.1214/10-STS321); [Imai et al. (2011)](https://doi.org/10.1017/S0003055411000414); [Acharya, Blackwell & Sen (2016)](https://doi.org/10.1017/S0003055416000216)
  - **Option B (Causal Machine Learning):** Heterogeneous treatment effects, CATE estimation, causal forests, double/debiased ML
  <div class="schedule-deliverables">
  <span class="badge-due">Due:</span> <em>The Effect</em> CH 20: Regression Discontinuity<br>
  <span class="badge-due">Due:</span> <strong>Final Report</strong>
  </div>

  **Week 16 (Jun 11): Final Group Project Presentations**
  - Each group presents their research project, followed by structured peer feedback and class discussion.

textbooks_content: |
  ## Textbooks

  **Required** (please have these ready before the semester begins):

  1. Angrist, J. D. & Pischke, J.-S. (2009). *Mostly Harmless Econometrics: An Empiricist's Companion*. Princeton University Press.
  2. Imbens, G. W. & Rubin, D. B. (2015). *Causal Inference for Statistics, Social, and Biomedical Sciences*. Cambridge University Press.
  3. Huntington-Klein, N. (2021). [*The Effect: An Introduction to Research Design and Causality*](https://theeffectbook.net/). CRC Press. (Open-source PDF version provided by the author.)

  **Optional** (useful for additional coverage):
  - Gerber, A. S., & Green, D. P. (2012). *Field Experiments: Design, Analysis, and Interpretation*. W. W. Norton & Company.
  - Morgan, S. L. & Winship, C. (2015). *Counterfactuals and Causal Inference*. 2nd ed. Cambridge University Press.
  - Angrist, J. D. & Pischke, J.-S. (2015). *Mastering 'Metrics*. Princeton University Press.
  - Cunningham, S. (2021). [*Causal Inference: The Mixtape*](https://mixtape.scunning.com/). Yale University Press.
  - Hernan, M. A. & Robins, J. M. (2020). [*Causal Inference: What If*](https://miguelhernan.org/whatifbook). CRC Press. (Open-source.)
  - Pearl, J. (2000). *Causality: Models, Reasoning, and Inference*. Cambridge University Press.
  - Blackwell, M. [*A User's Guide to Statistical Inference and Regression*](https://mattblackwell.github.io/gov2002-book/). (Open-source.)
  - Rosenbaum, P. R. (2002). *Observational Studies*. 2nd ed. Springer-Verlag.
  - Rosenbaum, P. R. (2009). *Design of Observational Studies*. Springer.
  - Wooldridge, J. M. (2010). *Econometric Analysis of Cross Section and Panel Data*. 2nd ed. MIT Press.
  - Rubin, D. (2006). *Matched Sampling for Causal Effects*. Cambridge University Press.
  - Manski, C. F. (1995). *Identification Problems in the Social Sciences*. Harvard University Press.
  - Chernozhukov, V. et al. (2025). [*Applied Causal Inference Powered by ML and AI*](https://causalml-book.org/). (Unpublished, open-source.)

  ## Software

  We use **R** (with RStudio) as the primary computing environment. Key packages include:

  `tidyverse`, `fixest`, `did`, `rdrobust`, `MatchIt`, `WeightIt`, `grf`, `dagitty`, `ggdag`, `modelsummary`

  Students comfortable with **Stata** or **Python** may use those for their research projects, but in-class demonstrations and code examples will be in R.

assignments_content: |
  ## Grading

  | Component | Weight | Description |
  |:----------|:------:|:------------|
  | **Research Project** | 50% | Original empirical research paper (max 20 pages). Includes proposal, progress report, presentation, and final paper. |
  | **Homework** | 30% | |
  | &nbsp;&nbsp;&nbsp;&nbsp;Problem Sets | 15% | Conceptual questions, analytic problems, simulations, and data analysis. |
  | &nbsp;&nbsp;&nbsp;&nbsp;*The Effect*<br>&nbsp;&nbsp;&nbsp;&nbsp;Assignments | 15% | Exercises from *The Effect* by Huntington-Klein. |
  | **Participation** (incl. presentations) | 10% | Active engagement in discussions + paper introduction presentations. |
  | **One-Page Summaries** | 5% | Weekly reading summaries, graded complete/incomplete. |
  | **Attendance** | 5% | Expected at every session; each absence costs ~1% of final grade. |

  ---

  ## Research Project

  In lieu of midterms and a final exam, students write a short paper applying or extending the causal inference methods learned in class. The paper should be no longer than 20 double-spaced pages and focus on research design, data, methodology, results, and analysis.

  ### Sample Evaluation

  To give you a clear sense of expectations and grading criteria, here is a sample final report with instructor evaluation from a previous offering:

  - [Sample Final Report (PDF)](/assets/courses/eci/ECI_Sample_Final_Report.pdf){:target="_blank"}: a student project using DiD, Callaway & Sant'Anna, and DML
  - [Sample Instructor Evaluation (PDF)](/assets/courses/eci/ECI_Sample_Evaluation.pdf){:target="_blank"}: detailed rubric scores, comments, and suggestions (89.5/100)

  ### Project Milestones

  | Milestone | Due | Deliverable |
  |:----------|:----|:------------|
  | Find a collaborator | Week 2 | Form a team or obtain permission for individual project |
  | Project proposal | Week 5 | Half-page description of proposed project & feasible research plan |
  | Progress report | Week 11 | 5-page memo with preliminary results, tables, figures, and analysis |
  | Final project report | Week 15 | Submit final version of the paper |
  | Final presentation | Week 16 | In-class group presentation |

  ### Replication Package

  Each final project must be accompanied by a **replication package**: a public GitHub repository containing the materials behind the paper (code, data, and outputs), so that the results can be reproduced. Beyond being standard practice in empirical research, it is a portfolio piece you can show prospective employers or graduate programs.

  **Repository.** Each group creates one public repository (e.g., `lastname-eci-final`), organized for clarity. For example:

  ```
  <lastname>-eci-final/
  ├── README.md            # how to reproduce, data availability
  ├── code/                # R scripts in run order (e.g., 01_clean.R → 02_analysis.R → 03_figures.R)
  ├── data/                # raw and/or cleaned data (see Data availability)
  ├── output/              # figures and tables
  ├── paper/               # final report (PDF)
  └── LICENSE
  ```

  **README.** The repository includes a short README documenting how to reproduce the analysis: a one-line project summary; which scripts to run, and in what order; the R version and key packages used (`sessionInfo()` is a convenient record); a Data Availability statement (below); and a brief note on AI use, per the course AI Use Policy.

  **Data availability.** Data should be included whenever possible so that results can be reproduced. When raw data cannot be shared (e.g., NDA, license, or privacy/personally identifiable information), it is omitted, and the README instead (1) documents what the data is, its source, and how it may be obtained, and (2) includes the non-sensitive derived or aggregated data behind the figures and tables, with a small sample where feasible, so that as much of the code as possible still runs. Personal or identifying data, non-redistributable licensed data, and credentials must never be committed.

  **Submission.** Submit the repository link via [MS Teams](https://teams.microsoft.com/l/team/19%3AJP2R-tTEDQeUB1xDpd33-nu4Qo21bv_c8NkSr5XxMaM1%40thread.tacv2/conversations?groupId=b48faca7-6855-4284-b7ef-b9ba){:target="_blank"} by the final report deadline. (Submissions are made through Teams while Canvas is unavailable.) A repository kept private for data sensitivity should give the instructor and TA access for grading (on GitHub, via *Settings → Collaborators*).

  ---

  ## Homework

  You will have two types of homework:

  1. **Problem sets**: a mix of conceptual questions, analytic problems, computer simulations, and data analysis that closely resemble what we discuss in lectures.
  2. ***The Effect* assignments**: exercises from our third textbook.

  You are encouraged to work in groups, but you must always write your own solutions including your own computer code. It is hugely beneficial to attempt the problems on your own before working in groups.

  **Late policy:** Late submissions are penalized 1 percentage point of the assignment's weight per day. For example, an assignment worth 7% of the course grade turned in 3 days late has a maximum attainable score of 4%.

  ---

  ## One-Page Summaries, Presentations & Reading Assignments

  - **One-Page Summaries:** Before each class, every student submits a 1-page summary of the assigned papers. Graded on a **complete/incomplete** basis: submission is what counts.
  - **Paper Introduction Presentations:** Students take turns presenting assigned papers throughout the semester. Each student presents **two papers**: one **live in class** and one as a **recorded video**. Presentations should cover the value of the topic and the motivational story, then connect to the methodology we cover in class: where the paper applies the methods, where it stops short or pushes further, and what was particularly interesting about the paper.
      - **Recording upload:** to MS Teams by **Monday** of the week the paper is scheduled.
      - **Pre-class viewing & evaluation:** all students watch the week's recording(s) and submit the **peer evaluation form** before Thursday class.
      - **In-class roundtable:** If time permits after the lecture, peers will discuss the recorded paper(s) in a roundtable format, with the presenter available to clarify points as needed.
      - **Grading:** both **presentation quality** (for presenters) and **evaluation quality** (for evaluators) contribute to the **Participation** grade.

  ### One-Page Summary Guideline

  Choose **5 papers** from the assigned reading list and write a one-page summary addressing the following:

  1. **Main Question**: What is the main question of the paper? Why do we care?
  2. **Parameters of Interest**: What model aspects or facts are being estimated? What parameter answers the main question?
  3. **Data**: What is the unit of observation? Where are the data from? How were they collected? Do the data appear reliable?
  4. **Answers**: What does the paper find? What are the main weaknesses? How could it be improved? If you were a practitioner, what implications would you draw?
  5. **Extensions**: After the current paper, what could be done next in this general area?

  You may also discuss: one-sentence conclusion, institutional background, conceptual framework, or relevant literature. Submit as PDF via Teams.

  ### Peer Evaluation Form

  For each paper presentation, you complete a structured feedback form covering four areas: **Research Question**, **Identification Strategy**, **Threats & Limitations**, and a **Constructive Suggestion**. Each area has space for written comments and a 1–5 rating.

  → [Open Printable Feedback Form](/assets/courses/eci/ECI_Peer_Feedback_Form.html){:target="_blank"}

  Completed forms are shared with the presenter. What counts toward your **Participation** grade is the **quality and thoughtfulness** of your evaluation, not the scores you give. Presenters are graded by the instructor, not by peers' ratings.

  ### Reading Assignments by Topic

  Students will present papers from the following five topic groups. Each group contains five readings: a textbook chapter plus published applications from top journals. Presentation assignments will be finalized before the first presentation week.

  > **Note:** If you have a top-journal paper that uses a method covered in one of these modules (e.g., a DiD paper for the DiD module) and you would prefer to present it instead, please contact the instructor before presentations begin to request a substitution.

  **1. Field Experiments** (Weeks 4–5)
  1. Angrist, J. D. & Pischke, J.-S. (2009). Ch. 2, "The Experimental Ideal." *Mostly Harmless Econometrics*. Princeton University Press.
  2. Montaguti, E., Neslin, S. A., & Valentini, S. (2016). "Can Marketing Campaigns Induce Multichannel Buying and More Profitable Customers? A Field Experiment." *Marketing Science*, 35(2), 201–217.
  3. Sahni, N. S., Zou, D., & Chintagunta, P. K. (2017). "Do Targeted Discount Offers Serve as Advertising? Evidence from 70 Field Experiments." *Management Science*, 63(8), 2688–2705.
  4. Bapna, R., Ramaprasad, J., Shmueli, G., & Umyarov, A. (2016). "One-Way Mirrors in Online Dating: A Randomized Field Experiment." *Management Science*, 62(11), 3100–3122.
  5. Cook, T. D., Campbell, D. T., & Shadish, W. R. (2002). Ch. 1, "Experiments and Generalized Causal Inference." *Experimental and Quasi-Experimental Designs for Generalized Causal Inference*. Houghton Mifflin.

  **2. Instrumental Variables** (Weeks 8–9)
  1. Angrist, J. D. & Pischke, J.-S. (2009). Ch. 4, "Instrumental Variables in Action." *Mostly Harmless Econometrics*. Princeton University Press.
  2. Angrist, J. D., Imbens, G. W., & Rubin, D. B. (1996). "Identification of Causal Effects Using Instrumental Variables." *Journal of the American Statistical Association*, 91(434), 444–455.
  3. Zettelmeyer, F., Scott Morton, F., & Silva-Risso, J. (2006). "How the Internet Lowers Prices: Evidence from Matched Survey and Automobile Transaction Data." *Journal of Marketing Research*, 43(2), 168–181.
  4. Dewan, S. & Ramaprasad, J. (2012). "Music Blogging, Online Sampling, and the Long Tail." *Information Systems Research*, 23(3), 1056–1067.
  5. Barron, K., Kung, E., & Proserpio, D. (2021). "The Effect of Home-Sharing on House Prices and Rents: Evidence from Airbnb." *Marketing Science*, 40(1), 23–47.

  **3. Difference-in-Differences** (Week 11)
  1. Angrist, J. D. & Pischke, J.-S. (2009). Ch. 5, "Parallel Worlds: Fixed Effects, Difference-in-Differences, and Panel Data." *Mostly Harmless Econometrics*. Princeton University Press.
  2. Bertrand, M., Duflo, E., & Mullainathan, S. (2004). "How Much Should We Trust Differences-in-Differences Estimates?" *Quarterly Journal of Economics*, 119(1), 249–275.
  3. Dranove, D., Kessler, D., McClellan, M., & Satterthwaite, M. (2003). "Is More Information Better? The Effects of 'Report Cards' on Health Care Providers." *Journal of Political Economy*, 111(3), 555–588.
  4. Goldfarb, A. & Tucker, C. E. (2014). "Conducting Research with Quasi-Experiments: A Guide for Marketers." *Rotman School of Management Working Paper* No. 2420920.
  5. Foerderer, J., Lueker, N., & Heinzl, A. (2021). "And the Winner Is…? The Desirable and Undesirable Effects of Platform Awards." *Information Systems Research*, 32(4), 1155–1172.

  **4. Matching Methods** (Week 12)
  1. Gordon, Brett R., et al. (2019). "A Comparison of Approaches to Advertising Measurement: Evidence from Big Field Experiments at Facebook." *Marketing Science*, 38(2), 193–225.
  2. Xu, K., Chan, J., Ghose, A., & Han, S. P. (2017). "Battle of the Channels: The Impact of Tablets on Digital Commerce." *Management Science*, 63(5), 1469–1492.
  3. Adamopoulos, P., Todri, V., & Ghose, A. (2020). "Demand Effects of the Internet-of-Things Sales Channel: Evidence from Automating the Purchase Process." *Information Systems Research*, 32(1), 238–267.
  4. Kim, Jun Hyung, et al. (2021). "Home-Tutoring Services Assisted with Technology: Investigating the Role of Artificial Intelligence Using a Randomized Field Experiment." *Journal of Marketing Research*.
  5. Son, Y., Oh, W., Han, S. P., & Park, S. (2020). "When Loyalty Goes Mobile: Effects of Mobile Loyalty Apps on Purchase, Redemption, and Competition." *Information Systems Research*, 31(3), 835–847.

  **5. Regression Discontinuity Design** (Weeks 13–14)
  1. Angrist, J. D. & Pischke, J.-S. (2009). Ch. 6, "Getting a Little Jumpy: Regression Discontinuity Designs." *Mostly Harmless Econometrics*. Princeton University Press.
  2. Flammer, C. (2015). "Does Corporate Social Responsibility Lead to Superior Financial Performance? A Regression Discontinuity Approach." *Management Science*, 61(11), 2549–2568.
  3. Hartmann, W., Nair, H. S., & Narayanan, S. (2011). "Identifying Causal Marketing Mix Effects Using a Regression Discontinuity Design." *Marketing Science*, 30(6), 1079–1097.
  4. Jo, Wooyong, et al. (2020). "Protecting Consumers from Themselves: Assessing Consequences of Usage Restriction Laws on Online Game Usage and Spending." *Marketing Science*, 39(1), 117–133.
  5. Flammer, C. & Bansal, P. (2017). "Does a Long-Term Orientation Create Value? Evidence from a Regression Discontinuity." *Strategic Management Journal*, 38(9), 1827–1847.

policies_content: |
  ## Course Policies

  **Attendance:** All students are expected to attend every class. Please bring your own hard copy of the course materials distributed before class. If you must miss a class, inform the instructor or TA in advance via email or phone. You are still responsible for the materials covered. Attendance counts toward your participation score (5%); each absence costs approximately 1% of the final grade.

  **Participation (10%):** This includes both active engagement in class discussions and the quality of your paper introduction presentations. Stay active and engaged. Effective discussions require that everyone comes prepared. Be ready to share your opinions and thoughts.

  **Late Policy:** Late submissions are penalized 1 percentage point of the assignment's weight per day. For example, an assignment worth 7% of the course grade turned in 3 days late has a maximum attainable score of 4%.

  **Academic Honesty:** All work submitted must be the student's own. Violations will result in a zero for the first offense; subsequent violations result in a failing grade for the course. Submissions will be checked via Turnitin.

  **AI Use Policy:** Students are permitted to use AI tools (e.g., ChatGPT, Claude) responsibly as **editorial assistants and sounding boards** to refine, stress-test, or get feedback on their own work, not to generate drafts in their place. The final submission must predominantly reflect the student's own understanding and reasoning.

  A few risks to avoid and practices to adopt when using AI for scholarly writing:
  - **Cognitive offloading** *(risk)*: it is tempting to let the LLM do your thinking for you, but the intellectual work behind your writing is what develops you as a scholar; outsourcing it weakens that development.
  - **Voice homogenization** *(risk)*: AI tends to produce a default, generic academic voice that gradually erodes your scholarly identity over time.
  - **Editor, not rewriter** *(practice)*: ask for inline comments and feedback rather than text replacement. This is the simplest way to preserve both your voice and ownership of the argument.
  - **Self-check** *(practice)*: before reaching for AI, ask yourself *"Can I discuss this idea coherently without it?"* If the answer is no, AI shouldn't be writing about it on your behalf either.

  If you use AI tools, you must:
  - Use AI as an **editor, not a rewriter** (ask for feedback or inline comments rather than text replacement).
  - Provide a detailed explanation of how the AI tool was used.
  - Submit the original AI-generated responses.
  - Critically evaluate and clearly indicate AI-generated portions.
  - Give proper attribution to AI-generated content.

  For deeper discussion of these trade-offs, see Paul Goldsmith-Pinkham's (Yale) [Writing and Thinking with AI Assistance](https://paulgp.substack.com/p/writing-and-thinking-with-ai-assistance). For practical writing principles and discipline-specific norms AI tools often miss (active voice, concrete examples, citation integrity, anti-AI-pattern hygiene), see this open-source [GitHub repository](https://github.com/hanlulong/econ-writing-skill) by Lu Han, which distills writing guidance from leading social scientists, including Nobel laureates Claudia Goldin and Michael Kremer alongside John Cochrane, Deirdre McCloskey, and Jesse Shapiro. The takeaway I find most compelling: academic writing is not an art but a learnable craft, a set of best practices that students can study and apply directly.

  **Accommodation:** Students with disabilities or special needs should contact the instructor during the first week of class to arrange appropriate accommodations.
---

## Course Overview

This course introduces experimental and quasi-experimental methods for causal inference that are widely used in a broad array of domains such as marketing and information systems. The focus is on delivering a breadth of substantive topics and methodological considerations that emerge in utilizing identification-oriented methods.

Throughout the course, we will discuss topics related to methods such as randomized controlled trials (RCT), difference-in-differences (DiD), matching methods such as propensity score matching (PSM) and coarsened exact matching (CEM), and more advanced topics such as regression discontinuity designs (RDD), double-debiased machine learning (DML), synthetic control methods (SCM), and synthetic difference-in-differences.

Students will review relevant research papers on each topic and actively engage in presentations and discussions about the nature of causation and alternative means of inferring causal relationships. Students will also carry out a collaborative group project where they design an experiment and associated plan of analysis to draw business insights.

## Learning Objectives

- Determine which methods and results best support specific empirical inference questions.
- Gain familiarity with causal inference methods widely used for business analytics.
- Understand the trade-offs in the design, analysis, and reporting of field, quasi, and natural experiment methods.

## Prerequisites

- **Math:** Undergraduate-level probability and statistics; some experience with regression analysis/econometrics is helpful. Basic linear algebra is helpful for following textbook derivations.
- **Programming:** Knowledge of statistical programming (e.g., R and Python)
- **Recommended prior coursework (ISS):**
  - ISS5066 Programming for Business Analytics (PBA) covers statistical inference, R programming, and an introduction to causal inference including potential outcomes and difference-in-differences. All of these are directly relevant to ECI. ECI goes considerably deeper, with more formal notation and careful assumption-based reasoning. Students entering with PBA will find the foundational concepts familiar, but should expect to engage more rigorously with the underlying theory. Qualified undergraduates and graduate students from other departments are welcome to join the class.
  - ISS5077 Computational Statistics for Data Science (CSDS) covers hypothesis testing, regression, and applied statistical modeling and will provide a strong background for the statistical foundations covered in this course.
  - ISS5090 Business Analytics with Machine Learning (BAML) covers supervised and unsupervised learning methods including trees, random forests, and neural networks and will provide helpful background for the causal ML topics covered in Weeks 14–15.

- **Related coursework in other departments:**
  - ECON3033 Econometrics I and ECON3034 Econometrics II: regression methodology and empirical research designs.
  - ECON5099 Causal Inference in Econometrics covers related topics.

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
      <li><i class="fas fa-calendar-check"></i> By appointment. <a href="https://calendar.app.google/AkutVLBQks1gnJ9a7" target="_blank" rel="noopener noreferrer">Book a slot via Google Calendar</a> and send a direct message on Teams.</li>
    </ul>
  </div>
</div>

### Teaching Assistants

<div class="ta-grid">
  <div class="ta-card">
    <span class="ta-photo">
      <img src="/assets/courses/eci/ta_justin_kao.jpg" alt="Kai-Chieh (Justin) Kao" class="photo-clickable" data-full="/assets/courses/eci/ta_justin_kao.jpg" style="object-position: center 15%; left: calc(50% + 5px);">
    </span>
    <div class="ta-info">
      <p class="ta-name">Kai-Chieh (Justin) Kao</p>
      <p class="ta-affiliation">Alumnus, ISS &middot; TSMC</p>
      <p class="ta-contact"><i class="fas fa-envelope"></i> justin.kao [at] iss.nthu.edu.tw</p>
    </div>
  </div>
  <div class="ta-card">
    <span class="ta-photo">
      <img src="/assets/courses/eci/ta_keri_liu.jpg" alt="Ting-Wen (Keri) Liu" class="photo-clickable" data-full="/assets/courses/eci/ta_keri_liu.jpg" style="top: -18px;">
    </span>
    <div class="ta-info">
      <p class="ta-name">Ting-Wen (Keri) Liu</p>
      <p class="ta-affiliation">M.S. Student, ISS, CADI Lab</p>
      <p class="ta-contact"><i class="fas fa-envelope"></i> keri.liu [at] iss.nthu.edu.tw</p>
    </div>
  </div>
</div>

## Course Platforms

This course uses three platforms: **this website**, **[MS Teams](https://teams.microsoft.com/l/team/19%3AJP2R-tTEDQeUB1xDpd33-nu4Qo21bv_c8NkSr5XxMaM1%40thread.tacv2/conversations?groupId=b48faca7-6855-4284-b7ef-b9ba){:target="_blank"}**, and **Canvas**:

| Purpose | Platform |
|:--------|:---------|
| Syllabus, schedule, readings, slides | **This website** |
| Announcements & Q&A | **Teams → General channel** |
| Shared papers & resources | **Teams → Files** |
| Office hours & consultations | **Teams → DM** + [Google Calendar](https://calendar.app.google/AkutVLBQks1gnJ9a7) |
| Homework submission | **Canvas** |
| Grades | **Canvas** |
