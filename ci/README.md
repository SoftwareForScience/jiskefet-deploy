# Continuous Integration (CI) with Jenkins
The current folder (`/ci`) contains a separate playbook for setting up a Jenkins CI server.

[To table of contents in README.md](../README.md#table-of-contents)


# Table of contents

1. [Deploy](#Deploy)
2. [Workflow](#Workflow)

## Deploy
The following section describes the steps required to deploy Jenkins on a remote server.

- Copy the `variables.yml.dist` as `variables.yml`. Change the variables to the appropriate values where needed. [More info on these variables](roles/geerlingguy.jenkins/README.md).
- Make sure you can [connect to the server via ssh](../docs/setting_up_ssh.md).
- Run playbook.
  ```
  $ ansible-playbook site.yml
  ```
- Open a browser and navigate to http://SERVER_ADDRESS to go to the Jenkins dashboard.

[Back to table of contents](#Table-of-contents)


## Workflow
The following section describes the workflow for creating new jobs and integrating them into this playbook repo.

The Jenkins GUI makes it easy to configure jobs. When jobs are configured the way you want, you will want to incorporate your changes into this repository. In order to do so, you only need to copy the contents of the `jobs` directory from the environment where you configured the jobs at, into the `ci/files/jobs` directory in this repository.

The general workflow for creating jobs:

1. Create/edit/delete jobs via the Jenkins GUI.
2. Copy the contents of `<your_jenkins_path>/jobs` into this repo's dir `ci/files/jobs`.
    
    **Example**  
    ```bash
    # When Jenkins runs remotely
    # scp -r <HOST_ALIAS>:<PATH_ON_HOST> <LOCAL_PATH_TO_COPY_TO>
    $ scp -r jiskefet-ci:/var/lib/jenkins/jobs ~/projects/jiskefet-deploy/ci/files/jobs

    # When Jenkins runs locally
    $ cp -r /Users/Bob/.jenkins/jobs ~/projects/jiskefet-deploy/ci/files/jobs
    ```

[Back to table of contents](#Table-of-contents)
