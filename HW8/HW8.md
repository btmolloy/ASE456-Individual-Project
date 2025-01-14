% ASE 456 Homework 8 (Individual Project Submission)

---
header-includes:
  - \usepackage{hyperref}  
  - \hypersetup{colorlinks=true,
            allbordercolors={0 0 0},
            pdfborderstyle={/S/U/W 2}}
  - \DeclareUnicodeCharacter{25CF}{$\bullet$}
  - \DeclareUnicodeCharacter{251C}{\mbox{\kern.23em
      \vrule height2.2exdepth1exwidth.4pt\vrule height2.2ptdepth-1.8ptwidth.23em}}
  - \DeclareUnicodeCharacter{2500}{\mbox{\vrule height2.2ptdepth-1.8ptwidth.5em}}
  - \DeclareUnicodeCharacter{2502}{\mbox{\kern.23em\vrule height2.2exdepth1exwidth.4pt}}
  - \DeclareUnicodeCharacter{2514}{\mbox{\kern.23em
      \vrule height2.2exdepth-1.8ptwidth.4pt\vrule height2.2ptdepth-1.8ptwidth.23em}}        
---

* 100 points in total
* Use the `Last-First-HW#' directory as a template directory. Copy all your results in the results directory (create sub-directories if necessary) and complete (mark and grade) the grading.docx in the directory. 
* Change the directory name; for example, `Cho-Samuel-HW#` is the directory name if I submit the homework (# should be replaced with the HW number). Notice that last name comes first. 
* Zip the directory to make a zip file, for example, `Cho-Samuel-HW#.zip` (# should be replaced with the HW number), to submit them on Canvas. 

# Tools

* Use GitHub for uploading and sharing your work.
  * Make a progress directory to store your programming progress. 
  * **Never include .git directory.**
* Use your Canvas individual project page to share (1) your project information and (2) progress.  
  * Students must update the progress everyweek. 
* Use PyCharm for making Python code.
  * Be sure to exclude project (.idea or any project files), cache directories (__pycache__ or any files), and temp files.
* Use cloc (https://cloc.sourceforge.net) for LoC computation. 
  * For example, use `cloc --json --exclude-dir=progress . > progress/2023_10_08.json` to store your current progress in the progress directory. 

# GitHub Project Structure

This is a possible example of the project structure. Students can change the name of the files, but the directory structure should be the same (or very similar) for evaluation. Students can use any file format for documentation. 

* Students use the project that is generated from Flutter.
  * `lib` and `test` contain the program files and test files. 
* `progress` directory contains the weekly progress in the JSON file format.
  * Use cloc to generate the report. 
* `documents` is the main documents directory.
  * `requirements`,`design`, and `manual` contains files for each activity.
  * `presentation` file has PPT or PDF presentation slides to show the features of your application to users.
    * manual shows the how to use the features, and presentation is for selling your product. 
  * Students can use any format, but they should be readable wihout any tools. 
  * When they use md, they should translate it with pdf so that stakeholders can read. 
  * For the UML diagram, transform the diagrams that can be read, such as JPG, PNG, or PDF. 
* `readme.txt` is the file that has the information of this project. 

```
.
├── documents
│   ├── codesmell_refactoring.txt
│   ├── design_patterns.txt
│   ├── design
│   │   ├── ver1
│   │   │   ├── design_document.md
│   │   │   └── uml1.jpg
│   │   └── ver2
│   ├── manual
│   │   └── user_manual_ver1.md
│   ├── presentation
│   │   └── feature.ppt
│   └── requirements
│       └── user_stories_ver1.md
├── progress
│   └── 2023_10_08.json
├── readme.txt
├── pubspec.yaml
├── lib
│   ├── program.dart
│   └── program2.dart
└── test
    └── program_test.dart
```
# Deliverables 

* Students download GitHub repository using the Zip format and copy it in the results directory.
  * Use "<> Code" -> "Download Zip" option in the main page. 
  * Store the zip in the "results/github" directory.
  * The GitHub directory must contain all the documents (design/manual/requirements, code smell and design patterns), code, tests, and progress. 
* Students generate Canvas Individual Project page in the PDF file format. 
  * Store the pdf in the "results/canvas" directory. 
* Students grade their results. 

# Discussion

## Requirements 

* Read HW4.pdf to understand (1) the problem domain and (2) translate the domain into requirements. 
* Students use user stories to make requirements.
* There are two requirements (ver1 and ver2) from Jack's 1st and 2nd emails. 
  * Make epic requirements if you need them. 

## Prototype

* Make a prototype to understand the problem domain.
* Just focus on making the simplest working version of your program. 

## Design

* Design files include UML diagrams, format files, or anything students make before implementing the features. 
* There are two designs (ver1 and ver2) from Jack's 1st and 2nd emails. 

## Code

* Even though students have a GitHub repository, they also should copy the project (code and test) files.
* There are three implementations (prototype, ver1, and ver2) from Jack's 1st and 2nd emails. 
  * Students make zip files from their GitHub repository when they finish each implementation. 

## Tests

* Students should make unit tests (a) to make sure each feature is working fine and (b) to be ready for the next changes. 
* Students should make at least one integration tests.
* Students should make regression and acceptance tests. 

## Documents

* Students should use GitHub for project artifacts. 
  * Students keep updating GitHub when they make code, tests, documents, and progress files. 
*  Students should use Canvas Page for project progress. 
  * Students already made an original plan and uploaded it on Canvas individual page, they should keep track of their progress.
