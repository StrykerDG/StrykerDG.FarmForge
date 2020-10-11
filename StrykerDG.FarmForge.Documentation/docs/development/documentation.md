---
id: 'documentation'
title: 'Documentation'
sidebar_label: 'Documentation'
---

## Introduction

The documentation for FarmForge is located in the StrykerDG.FarmForge.Documentation directory, and built using Docusaurus.

## Setup

The settings are already present in the documentation project to publish to the GitHub pages, but there are a few user environment variables that need to be setup first.

- DEPLOYMENT_BRANCH: gh-pages
- GIT_USER: USER_WITH_PERIMISSIONS_TO_PUBLISH

## Build and deploy

To deploy updated documentation, complete the following steps

1. Build the project to test that everything works correctly
```
cd <FarmForgeDirectory>/StrykerDG.FarmForge.Documentation
npm run build
npm run serve
```
2. If everything looks good, deploy by running the following command
```
yarn deploy
```

**NOTE** If you receive a message that yarn is not digitally signed, run the 
following command in powershell and try again
```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
