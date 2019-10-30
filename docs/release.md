# Release process

The release process is made of several steps, each delivering the software to a different, usually 
broader, group of people. One can stop at, and potentially resume from, any step. 

Steps 1-4 concern a specific package. Step 5 is needed to release the FLP Suite.

## Step 1 - GitHub
Target : Mostly yourself.

1. Go to your project
2. Click "Releases"
2. Optional : Build the release notes
   1. Click on the number of commits of the last version
   1. Go through the changes and select / summarize the ones important for the users
3. Click "Draft a new release"
4. On the Releases page, click "Draft a new release"
5. Give it a semantic version number
6. Write the release notes here (or copy the ones you prepared earlier)
7. Publish the release

## Step 2 - alidist recipe
Target : Mostly developers

1. Modify the corresponding recipe in the alidist repo (https://github.com/alisw/alidist)
2. Make a PR 
3. Wait for tests passing
4. Wait for approval (it should come from FLP people) and merging

## Step 3 - RPMs
Target : End users

Trigger a new build in alijenkins :

1. Go to [https://alijenkins.cern.ch/job/build-any-ib/]. People in egroup alice-o2-flp-prototype should have access to it.
1. Click on "Build with Parameters" on the left menu.
1. Fill in the form:
   1. Architecture : slc7
   1. package_name : O2Suite
   1. override_tags : leave it blank (or use the tag if the alidist recipe is not yet approved)
   1. defaults : o2-dataflow
1. Click "Build". It can take quite some time if dependencies have changed.
1. When the build is successful RPMs will be built shortly after (within minutes).

## Step 4 - Ansible
Target : Detectors with an FLP setup

1. Update the version number in basevars/vars/main.yml in the [repo](https://gitlab.cern.ch/AliceO2Group/system-configuration/tree/master/ansible)
2. Make a PR
3. Wait for approval and merging

## Step 5 - GitLab - FLP Suite version
Target : Detectors with an FLP setup (FLP Suite version) 

1. Write Release Notes and add it to ReleaseNotes.md
1. Tag the GitLab [repo](https://gitlab.cern.ch/AliceO2Group/system-configuration)
2. Advertise it on the mailing list alice-o2-flp-info