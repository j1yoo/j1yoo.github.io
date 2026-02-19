---
layout: course-eci
title: Experiments and Causal Inference
description: A graduate seminar on experimental and quasi-experimental designs for causal inference.
semester: "Spring 2026"
semester_dates: "Feb 23 – Jun 15, 2026"
course_number: "ISS5096"
series: "Methods"
day: "Thursday"
time: "14:20–17:20"
location: "TSMC Bldg. R406"
instructor_office: "TSMC Bldg. R828B"
instructor_email: "jaewon.yoo [at] iss.nthu.edu.tw"
communication: "All course communication goes through <strong>MS Teams</strong>. Check the Teams channel regularly for announcements, discussion threads, and updates. For private matters, email the instructor."
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
  - title: "Lecture 7 - Noncompliance and Instrumental Variables"
    id: "8S06mqd6pTM"

materials:
  - title: "Lecture 1: Intro and Potential Outcomes"
    url: "/assets/courses/eci/ECI_01_Intro_and_Potential_Outcomes.pdf"
  - title: "Lecture 2: Randomization Inference"
    url: "/assets/courses/eci/ECI_02_Randomization_Inference.pdf"
  - title: "Lecture 3: Inference for ATE"
    url: "/assets/courses/eci/ECI_03_Inference_for_ATE.pdf"
  - title: "Lecture 4: Regression"
    url: "/assets/courses/eci/ECI_04_Regression.pdf"
  - title: "Lecture 4(b): Extensions of Completely Randomized Experiments"
    url: "/assets/courses/eci/ECI_04(b)_Extensions_of_Completely_Randomized_Experiments.pdf"
  - title: "Lecture 5: Observational Studies"
    url: "/assets/courses/eci/ECI_05_Observational_Studies.pdf"
  - title: "Lecture 6: DAGs"
    url: "/assets/courses/eci/ECI_06_DAGs.pdf"
  - title: "Lecture 6(b): Sensitivity Analysis"
    url: "/assets/courses/eci/ECI_06(b)_Sensitivity_Analysis.pdf"
  - title: "Lecture 7: Noncompliance and IV"
    url: "/assets/courses/eci/ECI_07_Noncompliance_and_IV.pdf"
  - title: "Lecture 9: TSLS"
    url: "/assets/courses/eci/ECI_09_TSLS.pdf"
  - title: "Lecture 10: Panel Data and DID"
    url: "/assets/courses/eci/ECI_10_Panel_Data_and_DID.pdf"
  - title: "Lecture 11: Matching Methods"
    url: "/assets/courses/eci/ECI_11_Matching_Methods.pdf"
  - title: "Lecture 12: Sharp RD"
    url: "/assets/courses/eci/ECI_12_Sharp_RD.pdf"
  - title: "Lecture 13: Fuzzy RD"
    url: "/assets/courses/eci/ECI_13_Fuzzy_RD.pdf"
  - title: "Lecture 14: Causal Mechanisms"
    url: "/assets/courses/eci/ECI_14_Causal_Mechanisms.pdf"

schedule_content: |
  ## Weekly Schedule

  *Please refer to the [Syllabus PDF](/assets/courses/eci/ECI_Syllabus.pdf) for the most up-to-date schedule and full reading lists. Click the purple <span class="badge-slides" style="font-size:0.75rem; cursor:default;">Slides</span> badges to view lecture slides. <span class="badge-read" style="font-size:0.75rem; cursor:default;"><i class="fas fa-book-open"></i>Readings</span> should be completed **before** class. Items marked <span class="badge-due" style="font-size:0.75rem; cursor:default;">Due</span> must be submitted via Teams **before** that week's class begins (Thu 14:20).*

  ### Part I: Foundations of Causal Inference

  **Week 1 — Introduction and Potential Outcomes**
  <a class="badge-slides" href="/assets/courses/eci/ECI_01_Intro_and_Potential_Outcomes.pdf">Slides</a>
  - Neyman-Rubin causal model
  - Fundamental problem of causal inference (FPOCI)
  - Causal estimands; Post-treatment bias under truncation by death
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 1; Angrist & Pischke Ch. 1; [Holland (1986)](https://www.jstor.org/stable/2289064)
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Group forming & ice breaking activities</em>
  </div>

  **Week 2 — Randomization Inference**
  <a class="badge-slides" href="/assets/courses/eci/ECI_02_Randomization_Inference.pdf">Slides</a>
  - Randomized experiments
  - Fisher's approach to inference, permutation tests
  - Sharp null, randomization distribution
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 5 (skim Ch. 4); Rosenbaum (2002) Ch. 2
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Find a collaborator for the group project</em>
  </div>

  **Week 3 — Inference for the Average Treatment Effect**
  <a class="badge-slides" href="/assets/courses/eci/ECI_03_Inference_for_ATE.pdf">Slides</a>
  - Neyman's approach to inference for the ATE
  - Finite-sample vs superpopulation inference
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 6, 9, 10; Angrist & Pischke Ch. 2
  <div class="schedule-deliverables">
  <span class="badge-due">Due:</span> Problem Set 1 (Potential Outcomes)
  </div>

  **Week 4 — Linear Regression and Randomized Experiments**
  <a class="badge-slides" href="/assets/courses/eci/ECI_04_Regression.pdf">Slides</a> <a class="badge-slides" href="/assets/courses/eci/ECI_04(b)_Extensions_of_Completely_Randomized_Experiments.pdf">Slides (b)</a>
  - Simple linear regression in experiments
  - Covariate adjustment in experiments with regression
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 7, 9, 10; [Lin (2013)](https://doi.org/10.1214/12-AOAS583); [Freedman (2008)](https://doi.org/10.1016/j.aam.2006.12.003)
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 1.1 and 1.2<br>
  <span class="badge-due">Due:</span> Problem Set 2 (Randomization Inference)<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> — CH 2: Research Questions<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> — CH 3: Describing Variables<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> — CH 4: Describing Relationships
  </div>

  ### Part II: Observational Studies

  **Week 5 — Observational Studies I**
  <a class="badge-slides" href="/assets/courses/eci/ECI_05_Observational_Studies.pdf">Slides</a>
  - Selection on observables
  - Regression for observational data
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Angrist & Pischke Ch. 3
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 1.3 and 1.4<br>
  <span class="badge-due">Due:</span> Problem Set 3 (Inference for the ATE)<br>
  <span class="badge-due">Due:</span> Project Proposal (half-page description)<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> — CH 13: Regression
  </div>

  **Week 6 — Observational Studies II**
  <a class="badge-slides" href="/assets/courses/eci/ECI_06_DAGs.pdf">Slides</a> <a class="badge-slides" href="/assets/courses/eci/ECI_06(b)_Sensitivity_Analysis.pdf">Slides (b)</a>
  - DAGs and the back-door criterion
  - Sensitivity analysis; Partial identification
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 21–22; Morgan & Winship Ch. 4 *(handout provided)*
  <div class="schedule-deliverables">
  <i class="fas fa-clipboard-list deliv-icon"></i> <em>Construct a DAG for your own research project</em><br>
  <span class="badge-due">Due:</span> <em>The Effect</em> — CH 6: Causal Diagrams
  </div>

  **Week 7 — In-Class Group Project Meetings**
  - 30 minutes per group to discuss and materialize project ideas/topics

  ### Part III: Quasi-Experimental Methods

  **Week 8 — Instrumental Variables I**
  <a class="badge-slides" href="/assets/courses/eci/ECI_07_Noncompliance_and_IV.pdf">Slides</a>
  - Noncompliance in randomized experiments
  - Instrumental variables in observational studies
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 23–24; Angrist & Pischke Ch. 4
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 2.1 and 2.2<br>
  <span class="badge-due">Due:</span> Problem Set 5 (Observational Studies)<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> — CH 7: Drawing Causal Diagrams
  </div>

  **Week 9 — Instrumental Variables II**
  <a class="badge-slides" href="/assets/courses/eci/ECI_09_TSLS.pdf">Slides</a>
  - Two-stage least squares
  - Review of IV applications
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 2.3 and 2.4<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> — CH 8: Causal Paths and Closing Backdoors
  </div>

  **Week 10 — Panel Data, Fixed Effects, and Difference-in-Differences**
  <a class="badge-slides" href="/assets/courses/eci/ECI_10_Panel_Data_and_DID.pdf">Slides</a>
  - Fixed effects and first differences
  - Difference-in-differences
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Angrist & Pischke Ch. 5; [Imai & Kim (2019)](https://doi.org/10.1111/ajps.12417)
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 3.1 and 3.2<br>
  <span class="badge-due">Due:</span> Problem Set 4 (Instrumental Variables)<br>
  <span class="badge-due">Due:</span> Progress Report<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> — CH 19: Instrumental Variables
  </div>

  **Week 11 — Difference-in-Differences Cont.**
  - Applications of difference-in-differences
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 3.3 and 3.4<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> — CH 18: Difference-in-Differences
  </div>

  **Week 12 — Matching and Weighting Estimators**
  <a class="badge-slides" href="/assets/courses/eci/ECI_11_Matching_Methods.pdf">Slides</a>
  - Propensity scores, matching, and weighting
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Imbens & Rubin Ch. 13, 15, 18; [Stuart (2010)](https://doi.org/10.1214/09-STS313)
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 4.1, 4.2, 4.3, and 4.4<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> — CH 14: Matching
  </div>

  **Week 13 — Regression Discontinuity Designs**
  <a class="badge-slides" href="/assets/courses/eci/ECI_12_Sharp_RD.pdf">Slides</a>
  - Sharp RD designs, identification
  - Estimation and bandwidth selection
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> Angrist & Pischke Ch. 6; [Imbens & Lemieux (2008)](https://doi.org/10.1016/j.jeconom.2007.05.001)
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 5.1 and 5.2<br>
  <span class="badge-due">Due:</span> <em>The Effect</em> — CH 20: Regression Discontinuity
  </div>

  **Week 14 — Regression Discontinuity Designs Cont.**
  <a class="badge-slides" href="/assets/courses/eci/ECI_13_Fuzzy_RD.pdf">Slides</a>
  - Fuzzy RD designs
  - Applications of RDDs
  - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> [Cattaneo, Idrobo & Titiunik (2020)](https://doi.org/10.1017/9781108684606)
  <div class="schedule-deliverables">
  <i class="fas fa-users deliv-icon"></i> Paper Presentations: 5.3 and 5.4<br>
  <span class="badge-due">Due:</span> Problem Set 6 (Matching and Weighting Estimators)
  </div>

  ### Part IV: Advanced Topics & Research Workshop

  **Week 15 — Advanced Topics** <span style="font-size:0.78rem; color:#e67e22; font-weight:600;">TENTATIVE</span>
  - *One of the following topics will be covered (to be announced):*
  - **Option A — Causal Mechanisms:** Mediation analysis, controlled direct effects, natural direct and indirect effects <a class="badge-slides" href="/assets/courses/eci/ECI_14_Causal_Mechanisms.pdf">Slides</a>
      - <span class="badge-read"><i class="fas fa-book-open"></i>Readings:</span> [Imai, Keele & Yamamoto (2010)](https://doi.org/10.1214/10-STS321); [Imai et al. (2011)](https://doi.org/10.1017/S0003055411000414); [Acharya, Blackwell & Sen (2016)](https://doi.org/10.1017/S0003055416000216)
  - **Option B — Causal Machine Learning:** Heterogeneous treatment effects, CATE estimation, causal forests, double/debiased ML
  <div class="schedule-deliverables">
  <span class="badge-due">Due:</span> Final Report
  </div>

  **Week 16 — Final Group Project Presentations**
  - Each group presents their research project, followed by structured peer feedback and class discussion.

textbooks_content: |
  ## Textbooks

  **Required** (please have these ready before the semester begins):

  1. Angrist, J. D. & Pischke, J.-S. (2009). *Mostly Harmless Econometrics: An Empiricist's Companion*. Princeton University Press.
  2. Imbens, G. W. & Rubin, D. B. (2015). *Causal Inference for Statistics, Social, and Biomedical Sciences*. Cambridge University Press.
  3. Huntington-Klein, N. (2021). [*The Effect: An Introduction to Research Design and Causality*](https://theeffectbook.net/). CRC Press. (Open-source PDF version provided by the author.)

  **Optional** (useful for additional coverage):
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

  - [Sample Final Report (PDF)](/assets/courses/eci/ECI_Sample_Final_Report.pdf){:target="_blank"} — a student project using DiD, Callaway & Sant'Anna, and DML
  - [Sample Instructor Evaluation (PDF)](/assets/courses/eci/ECI_Sample_Evaluation.pdf){:target="_blank"} — detailed rubric scores, comments, and suggestions (89.5/100)

  ### Project Milestones

  | Milestone | Due | Deliverable |
  |:----------|:----|:------------|
  | Find a collaborator | Week 2 | Form a team or obtain permission for individual project |
  | Project proposal | Week 5 | Half-page description of proposed project & feasible research plan |
  | Progress report | Week 10 | 5-page memo with preliminary results, tables, figures, and analysis |
  | Final project report | Week 15 | Submit final version of the paper |
  | Final presentation | Week 16 | In-class group presentation |

  ### Structured Peer Feedback

  Final presentations are accompanied by structured peer feedback. After each presentation, every student completes a feedback form covering four areas: **Research Question**, **Identification Strategy**, **Threats & Limitations**, and a **Constructive Suggestion**. Each area includes space for written comments and a 1–5 rating.

  → [Open Printable Feedback Form](/assets/courses/eci/ECI_Peer_Feedback_Form.html){:target="_blank"}

  Feedback forms are shared with presenters to support their final revisions. The **quality and thoughtfulness** of your feedback — not the scores you give — contributes to your **Participation** grade. Presenter grades are determined by the instructor independently.

  ---

  ## Homework

  You will have two types of homework:

  1. **Problem sets** — a mix of conceptual questions, analytic problems, computer simulations, and data analysis that closely resemble what we discuss in lectures.
  2. ***The Effect* assignments** — exercises from our third textbook.

  You are encouraged to work in groups, but you must always write your own solutions including your own computer code. It is hugely beneficial to attempt the problems on your own before working in groups.

  **Late policy:** Late submissions are penalized 1 percentage point of the assignment's weight per day. For example, an assignment worth 7% of the course grade turned in 3 days late has a maximum attainable score of 4%.

  ---

  ## One-Page Summaries, Presentations & Reading Assignments

  - **One-Page Summaries:** Before each class, every student submits a 1-page summary of the assigned papers. Graded on a **complete/incomplete** basis — submission is what counts.
  - **Paper Introduction Presentations:** Students take turns presenting assigned papers each week. Presentations should cover the value of the topic and the motivational story. All students should read the paper before class. Quality of presentations is reflected in the **Participation** grade.

  ### One-Page Summary Guideline

  Choose **5 papers** from the assigned reading list and write a one-page summary addressing the following:

  1. **Main Question** — What is the main question of the paper? Why do we care?
  2. **Parameters of Interest** — What model aspects or facts are being estimated? What parameter answers the main question?
  3. **Data** — What is the unit of observation? Where are the data from? How were they collected? Do the data appear reliable?
  4. **Answers** — What does the paper find? What are the main weaknesses? How could it be improved? If you were a practitioner, what implications would you draw?
  5. **Extensions** — After the current paper, what could be done next in this general area?

  You may also discuss: one-sentence conclusion, institutional background, conceptual framework, or relevant literature. Submit as PDF via Teams.

  ### Reading Assignments by Topic

  Students will present papers from the following five topic groups. Each group contains five readings — a textbook chapter plus published applications from top journals. Presentation assignments will be finalized before the first presentation week.

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

  **3. Difference-in-Differences** (Weeks 10–11)
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

  **AI Use Policy:** Students are permitted to use AI tools (e.g., ChatGPT, Claude) responsibly as aids for brainstorming and generating initial drafts. However, the final submission must predominantly reflect the student's understanding and personal input. If you use AI tools, you must:
  - Provide a detailed explanation of how the AI tool was used
  - Submit the original AI-generated responses
  - Critically evaluate and clearly indicate AI-generated portions
  - Give proper attribution to AI-generated content

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

- **Probability & Statistics:** Undergraduate-level probability and statistics
  (random variables, distributions, hypothesis testing, confidence intervals)
- **Regression:** Prior coursework or working knowledge of linear regression
  (OLS, interpretation of coefficients, standard errors) is strongly recommended.
  Regression is used extensively from Week 4 onward.
- **Math:** Comfort with mathematical notation; basic linear algebra
  (matrix operations) is helpful for following textbook derivations
- **Programming:** Working knowledge of **R** is expected (our primary
  language for in-class demos and assignments). Familiarity with `tidyverse`
  for data wrangling is a plus. Students with only Python or Stata experience
  should self-study R basics before the semester begins.
- **Recommended prior coursework:** ISS5077 Business Analytics using
  Computational Statistics (BACS) provides ideal preparation, covering
  hypothesis testing, regression, and applied modeling. ISS5066
  Programming for Business Analytics (PBA) also covers regression,
  statistical inference, and R programming. For students seeking
  deeper methodological preparation, ECON3033 Econometrics I and
  ECON3034 Econometrics II from the Economics Department are
  recommended.

## Teaching Team

### Instructor

<div class="instructor-card">
  <img src="/assets/img/prof_jaewon_yoo.jpg" alt="Jaewon Yoo">
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

### Teaching Fellows

<p style="color: #888; font-style: italic;">TBA</p>

## MS Teams Integration

This course uses **MS Teams** alongside this website:

| Purpose | Platform |
|:--------|:---------|
| Syllabus, schedule, readings, slides | **This website** |
| Announcements & Q&A | **Teams → General channel** |
| Paper submissions | **Teams → Assignments** |
| Shared papers & resources | **Teams → Files** |
| Office hours & consultations | **Teams → DM** + [Google Calendar](https://calendar.app.google/AkutVLBQks1gnJ9a7) |
