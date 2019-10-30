Testing deployed role
===

After deployment some checks can be made in order to verify that a role has been installed, configured and launched correctly, eg. check whether the application responds as expected on a request.

Preparation
---

1. Create a `test.yml` file in the `tasks` directory.
2. Add following entry as a last task of your role

```yaml
- name: Run tests
  include_tasks: test.yml
  when: test | default(false) | bool == true
  tags: test
```
3. Define checks in the `tasks/test.yml` file
4. Execute tests by running `ansible-playbook` with the `test` variable set to `true`:

```
ansible-playbook -e test=true ...
```

Defining tests
---
The `test.yml` file is ordinary Ansible task file.

As an example, the following code verifies that HTTP request sent to an application port returns code 200 and the returned body contains "ALICE O2" phrase:

```yaml
- name: Check whether server responds with 200
  uri:
    url: "http://{{ ansible_fqdn }}"
    method: GET
    status_code: 200
    return_content: yes
  register: result

- name: Check whether the response body contains "ALICE O2" phrase
  fail:
    msg: The response from HTTP server was incorrect
  when: "'ALICE O2' not in result.content"
```

Running tests in CI
---

Continuous integration always sets `test=true` therefore it always runs the tests.
