---
layout: course-guide
permalink: /teaching/pba-milestones/
title: "Project Milestones and the Final Report"
description: "For the PBA team project: what each milestone asks for, how Milestone 4 (first analysis, due Sun Dec 6) leads to the final report, and what the final report contains."
course_label: "PBA"
semester: "Fall 2026"
accent: "#2698ba"
favicon_base: /assets/courses/pba/pba_favicon
course_links:
  - text: "Undergraduate course page"
    url: "/teaching/pba/"
  - text: "Graduate course page"
    url: "/teaching/pba-grad/"
posted: 2026-11-27
nav: false
---

The team project is built in steps, and each milestone asks for one piece of the final report: a repository, a question with data, a first figure, a first table. I read every milestone to see how your project is developing. Treat each milestone as a checkpoint: submit it on time, and do not worry if a later step makes you change an earlier one. **Milestone 4 (first analysis) is due Sunday, December 6.**

### 1. The milestones at a glance

| Milestone | What you submit |
|:---|:---|
| 1. GitHub repository | The URL of your team's public repository, with at least one commit from every member. See the [setup guide](/teaching/pba-github/). |
| 2. Data and proposal | One to two pages: your research question, your hypothesis, a description of your data, your key variables, and what would count as evidence. See section 6 of the [guide to finding data](/teaching/pba-data/). |
| 3. First visualization | One figure made from your data that shows the pattern behind your question, with a short paragraph that reads the figure. |
| 4. First analysis | One table of estimates that you would present as your headline result, with a short paragraph that interprets it. |
| Final report | A short research paper with all your figures, tables, and follow-up analyses, and a repository that holds all the code. |

Due dates are in the milestone table on the course page, under **Evaluation**. You are not locked in at any step. You can change the question, the data, or the headline result later if you find a better angle.

### 2. Milestone 1: GitHub repository

- **What it is.** One public repository for the team. By this milestone, every member has Git and RStudio connected to GitHub and has pushed at least one commit. The [setup guide](/teaching/pba-github/) covers each step.
- **What it is for.** The project lives in this repository. Your final report links to it, and it holds all the code that produces your figures and tables.
- **Data files.** Keep large raw data files out of the repository, and write in the README where the data can be downloaded. Section 10 of the setup guide shows how.

### 3. Milestone 2: data and proposal

- **What it is.** One to two pages on your question and on the data you plan to answer it with. Section 6 of the [guide to finding data](/teaching/pba-data/) lists the five points to cover.
- **Real data.** Use real data that you locate and prepare yourselves. A dataset that comes already cleaned in an R package is not enough.
- **Where it goes.** The proposal is an early draft of the first sections of your final report: the introduction, what earlier studies found, and the data.

### 4. Milestone 3: first visualization

- **What it is.** A figure made from your own data that shows the pattern your question is about, before you fit any model. In class, I call this model-free evidence.
- **What to write with it.** A short paragraph that reads the figure, as we do in class: what it shows, and whether that is what you expected.
- **If you compare groups over time.** For a difference-in-differences design, plot the outcome over time for the treated group and for the comparison group. For this, you need your data as a panel: one row for each unit in each period.
- **An unexpected pattern is fine.** If the figure does not show what you expected, say so and discuss why.
- **It is a first look.** The first visualization does not have to appear in the final report.

### 5. Milestone 4: first analysis

- **What it is.** One table of estimates that you would present as the **headline result** of your project. The first visualization showed the pattern in a picture. The first analysis puts numbers on it, usually with a regression.
- **What to write with it.** A short text that says what the table shows and why you find it interesting. Interpret the estimates in plain words: which variable, in which direction, how large, and in which units. End with what you plan to look at next.
- **One outcome first.** If your project has several outcomes, choose the one you focus on and present it here. If your point is a pattern across a few measures, as in many descriptive projects, put them in the same table. The other outcomes belong in the final report.
- **Under the table.** Say what one row of your data is and how many observations the table uses.
- **Uncertainty.** If you can, add a 95% confidence interval for your main estimate, with the bootstrap from Week 13. Hypothesis tests come in Week 14. Both belong in the final report.
- **If your question is causal.** The table should show the estimate from your main comparison, for example, your difference-in-differences estimate. State in words the assumption that makes this comparison fair.
- **If your question is predictive.** The table should compare the prediction error of your models on test data, that is, data that was not used to fit them.
- **You can change the headline later.** If you find a more interesting result after you submit, present that one in the final report.
- **Use the consultations.** You are welcome to book a consultation or to come to office hours with a draft of your table.

### 6. From the first analysis to the final report

The first analysis is one table. The final report is the whole paper. Between the two, you build around the headline result:

- **Other outcomes and robustness checks.** Show whether the result holds for the other outcomes you study, and whether it holds when you change the sample or the model.
- **Subgroups, with a reason.** You can estimate the result separately for groups, such as age groups. First, say why you expect the groups to differ. Then, report whether the estimates differ.
- **More figures.** For example, the trend of each outcome over time.
- **An explanation.** Go back to theory, to earlier studies, or to what you know about the setting, and explain what you predicted and what you found.

### 7. The final report

Write the final report as a short research paper.

- **Introduction.** Your question, and why it is interesting and important.
- **What earlier studies found,** and what your project adds. Do not only repeat an existing study. A small new angle is enough.
- **Data.** The source, what one row is, the period, the number of observations, and the variables you use.
- **Method.** What you compare with what, and why that comparison answers your question. If your question is causal, state in words the assumption that makes the comparison fair.
- **Results.** Your headline result first, then the follow-up analyses of section 6. Explain every figure and table in plain language.
- **Discussion.** The limitations of your study, the threats to your conclusion, and how the analysis could be improved.
- **Code.** Your GitHub repository holds all the code that produces the figures and tables in the report.

A result that is not statistically significant is fine. Report it, and discuss why the effect may not show up. You also do not need to cover every method from the course. Focusing on one kind of question, such as a causal question, is completely fine.

The course page links a sample final report from last year with my evaluation, under **Evaluation**. The rubric is on eeclass.

### 8. Showcase and presentation

- **Undergraduate section: showcase.** Teams present at stations, and the instructor and the TAs go around for questions. Present why your question is interesting and important, and what you found, with your main figure and your headline table.
- **Graduate section: presentation.** Each team presents for 15 minutes, followed by questions.
- **For both.** Prepare to answer questions about your data, your method, and your results. A question can go to any member of the team.

If you are not sure whether your figure or your table does the job, bring it to a consultation or to office hours.
