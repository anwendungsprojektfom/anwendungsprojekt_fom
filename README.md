# anwendungsprojekt_fom

## Setup LATEX for documentation part
1) Install VS Code
2) Install basic-miktex-24.1-x64
3) Install strawberry-perl-5.38.2.2-64bit
4) Install Docker as addon in VS Code
5) Install Latex as addon in VS Code


## How to create a branch with branch convention
1) ´git checkout master´ and ´git pull´ for getting the current master branch
2) ´git checkout -b your-new-branch' to create the new branch with following branch naming conventions
   a) New feature: ´feature-create-function-for-test´
   b) New bugfix: ´bugfix-fix-issue-for-bug´
   c) Documentation: ´documentation-create-documentation-for-feature´
3) ´git push --set-upstream origin your-branch-name´


## How to update branch with current master if branch has conflicts in PR
1) ´git checkout master´ and ´git pull´ for getting latest changes from master
2) ´git checkout your-branch-with-conflicts´ 
3) ´git fetch origin master´ and ´git merge origin/master´ and input ´:qa´ and tap Enter
4) ´git push´


## Before merging or pushing changes, please run formatter and analyzer
1) Formatter command: ´dart format -l 120 .´
2) Analyzer command to see analyzer issues: ´dart analyze´
3) Fix analyzer issues: ´dart fix --apply´


## Building iOS
1) Run ´flutter pub get´ in your terminal on root 
2) Run ´pod install --repo-update´ in your terminal on ios folder
3) Build iOS or Run Debugging



