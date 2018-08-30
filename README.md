<a name="top"> </a>

[This document is formatted with GitHub-Flavored Markdown.                ]:#
[For better viewing, including hyperlinks, read it online at              ]:#
[https://github.com/sourceryinstitute/rose-installer/blob/master/README.md]:#

<div align="center">

[![Sourcery Institute][sourcery institute logo]](https://www.sourceryinstitute.org)

ROSE Installer
==============

[Motivation](#motivation) | [Usage](#downloads) | [Contributing](#contributing) | [Acknowledgements](#status)  

</div>

Motivation
----------

The primary motivation for this repository is to capture a specific
workflow that successfully installed the [ROSE] compiler infrastructure 
on one platform for one combination of installation options on one particular
day in the lunar cycle.  The platform was an [Ubuntu Desktop] 18.04.1 virtual 
machine running inside the [VirtualBox] virtualization software.  The authors
make no claims of portability, generality, or even reproducibility.   In fact,
the first commit in this repository contained nothing more than this README.md
file and a verbatim transcript of the steps employed. Usage on other platforms
with other installation flags or prerequisite software versions on other days in 
the lunar cycle will surely require a multitude of changes to the scripts.

The publication of this repository is not intended to indicate an intention on 
the part of the original authors to support or maintain the scripts contained 
herein.  Pull requests are more likely to get responses than submitted issues.


Usage
-----
To display the allowable arguments, execute `./install-rose.sh --help`.  To
install [ROSE], try the following:
```bash
git clone https://github.com/sourceryinstitute/rose-installer
cd rose-installer
./install-rose.sh 
```

Contributing
------------
To help make this script more general, flexible, portable or even just 
prettier and more presentable, feel free to fork this repository and submit
pull requests to update the code.


Acknowledgements
----------------
The original committer gratefully acknowledges the guidance of Craig Rasmussen of
Lawrence Livermore National Laboratory for patiently providing the steps captured 
in this repository. 

[Internal Links]:#

[Motivation]: #motivation
[Usage]: #usage
[Acknowledgements]: #acknowledgements

[External Links]:#
[Ubuntu Desktop]: https://www.ubuntu.com/download/desktop
[ROSE]: https://www.rosecompiler.org
[VirtualBox]: https://www.virtualbox.org
[sourcery institute logo]: http://www.sourceryinstitute.org/uploads/4/9/9/6/49967347/sourcery-logo-rgb-hi-rez-1.png
