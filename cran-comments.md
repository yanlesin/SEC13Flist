## Resubmission
This is a resubmission number 2 following manual review feedback. In this version I have: 

* Fixed capitalization issue in the middle of sentence in the description text. Remaining capitalization (Committee on Uniform Securities Identification Procedures) is a name of the committee.

* 

* Added \\value to .Rd files with description of the returned values for functions and explanations of function results

* Replaced \\dontrun with \\donttest
```
From: Martina Schmirl <martina.schmirl@jku.at>
Date: January 31, 2020 at 7:38:06 AM PST
To: Yan Lyesin <yan.lyesin@gmail.com>, CRAN <cran-submissions@r-project.org>
Subject: Re:  CRAN submission SEC13Flist 0.2.5
Thanks,

Please only capitalize sentence beginnings and names in the description text. e.g. -> Extract official list ...

Please provide a link to the used webservices to the description field of your DESCRIPTION file in the form
<http:...> or <https:...>
with angle brackets for auto-linking and no space after 'http:' and
'https:'.

Please add \value to .Rd files regarding exported methods and explain the functions results in the documentation.
(See: Writing R Extensions <https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Documenting-functions> )
If a function does not return a value, please document that too, e.g. \value{None}.

\dontrun{} should only be used if the example really cannot be executed (e.g. because of missing additional software, missing API keys, ...) by the user. That's why wrapping examples in \dontrun{} adds the comment ("# Not run:") as a warning for the user.
Does not seem necessary.
Please replace \dontrun with \donttest.

Please fix and resubmit.

Best,
Martina Schmirl
```

## Resubmission
This is a resubmission. In this version I have:

* Removed possible syntax error in description

* Addressed examples running longer than 10 seconds

## Test environments
* local OS X install, R 3.6.2
* ubuntu 16.04 (on travis-ci), R 3.6.2
* local Windows 10 install, R 3.6.2
* Debian GNU/Linux 9 (stretch) docker container with R 3.6.1
* R-Hub "check_for_cran()" on 4 platforms devel and release

── R CMD check results ─────────────────────────────────── SEC13Flist 0.2.5 ────
Duration: 48.8s

0 errors ✓ | 0 warnings ✓ | 0 notes ✓

* This is a new release.
