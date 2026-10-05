---
layout: course-guide
permalink: /teaching/pba-github/
title: "Setting Up Git and GitHub"
description: "For the PBA team project: from a new GitHub account to your first push from RStudio, before Milestone 1 (due Sun Oct 11)."
course_label: "PBA"
semester: "Fall 2026"
accent: "#2698ba"
favicon_base: /assets/courses/pba/pba_favicon
course_links:
  - text: "Undergraduate course page"
    url: "/teaching/pba/"
  - text: "Graduate course page"
    url: "/teaching/pba-grad/"
pdf: /assets/courses/pba/PBA_GitHub_Setup.pdf
posted: 2026-10-01
nav: false
---

Your team project lives in a public GitHub repository. This guide takes you from nothing to your first push from RStudio. It takes about 30 minutes. Do it before **Milestone 1 (GitHub repository), due Sunday, October 11**. Each step links to the matching chapter of [Happy Git and GitHub for the useR](https://happygitwithr.com/) if you want more detail.

### 1. Create a GitHub account

Go to [github.com](https://github.com/) and sign up. Pick a username you would be happy to put on a CV, and verify your email address. ([More detail](https://happygitwithr.com/github-acct))

### 2. Install Git

- **Mac:** open Terminal and run `git --version`. If Git is not installed, macOS offers to install the Command Line Developer Tools. Accept.
- **Windows:** install [Git for Windows](https://git-scm.com/download/win) with the default options.

Restart RStudio afterwards. ([More detail](https://happygitwithr.com/install-git))

### 3. Tell Git who you are

Run this in the RStudio Console, with your name and the email of your GitHub account:

```r
install.packages("usethis")
usethis::use_git_config(user.name = "Your Name", user.email = "you@example.com")
```

([More detail](https://happygitwithr.com/hello-git))

### 4. Let RStudio talk to GitHub (personal access token)

GitHub does not accept your password from RStudio. It needs a token instead.

```r
usethis::create_github_token()
```

A GitHub page opens. Add a note such as "PBA laptop", keep the default scopes, set the expiration to a date after the end of the semester, click **Generate token**, and copy the token. Then run

```r
gitcreds::gitcreds_set()
```

and paste the token when asked. ([More detail](https://happygitwithr.com/https-pat))

### 5. Check that RStudio sees Git

In RStudio, go to **Tools > Global Options > Git/SVN**. The Git executable box should show a path. If it is empty, restart RStudio, or point it to the Git you installed in step 2. ([More detail](https://happygitwithr.com/rstudio-git-github))

### 6. Keep your project out of synced folders

Do not put the project inside Dropbox, iCloud Drive, OneDrive, or Google Drive. The sync tool and Git both try to manage the same files, and the repository can break.

- **Windows:** the Documents folder is often synced to OneDrive. Use a folder such as `C:\projects` instead.
- **Mac:** if your Desktop and Documents sync to iCloud, use a folder in your home directory, such as `/Users/yourname/projects`.

### 7. Create the team repository (one person per team)

1. On GitHub, click **New repository**. Name it `pba-project-` followed by your team name (lowercase, hyphens instead of spaces), choose **Public**, and check **Add a README file**.
2. Go to **Settings > Collaborators** and add your teammates. They accept the invitation that arrives by email.

### 8. Bring the repository into RStudio (every team member)

1. On the repository page, click the green **Code** button and copy the HTTPS address.
2. In RStudio, choose **File > New Project > Version Control > Git**, paste the address, choose your projects folder from step 6, and click **Create Project**.

A **Git** tab now appears in the upper-right pane. ([More detail](https://happygitwithr.com/new-github-first))

### 9. Make your first commit and push

1. Open `README.md` and add a line with your name. The first person can also add the team name and one or two sentences on topic ideas.
2. In the **Git** tab, check the box next to the file, click **Commit**, write a short message such as "Add my name to README", and click **Commit** again.
3. Click **Push** (the green up arrow). Refresh the repository page on GitHub to see your change.

Working with teammates: click **Pull** (the blue down arrow) before you start working, and push when you finish. This avoids most conflicts.

### 10. Keep large data files out of the repository

GitHub rejects files larger than 100 MB. Put raw data in a folder such as `data/raw/`, tell Git to ignore it, and write in the README where the data can be downloaded:

```r
usethis::use_git_ignore("data/raw/")
```

If you already committed a large file, run `git rm --cached path/to/the/file` in the RStudio **Terminal** tab, then commit and push again.

### Milestone 1

Submit your team repository's URL on eeclass by Sunday, October 11. Before you submit, check that every team member has pushed at least one commit.

### If something goes wrong

- **No Git tab:** go to **Tools > Project Options > Git/SVN** and set the version control system to Git, then restart RStudio. Running `usethis::use_git()` in the Console also works.
- **RStudio asks for a password when you push:** repeat step 4.
- **Push is rejected because the repository has changes you don't have:** click **Pull** first, then **Push**.
- **"File exceeds GitHub's file size limit of 100.00 MB":** see step 10.

More help: the [troubleshooting chapter](https://happygitwithr.com/troubleshooting) of Happy Git, the eeclass discussion board, or your TA.
