# Contributing Guidelines

Contributions to this project are welcome and very much appreciated. Thank you for your consideration!

Please see the list of current [issues][issues] for this project.

Please see the sections below for more information on contributions.

 - [Questions](#questions)
 - [Issues and Bugs](#issues)
 - [Feature Requests](#features)
 - [Documentation](#docs)
 - [Submission Guidelines](#submissions)
 - [Code Style Guidelines](#style)
 - [Commit Message Guidelines](#commits)

## <a name="questions"></a> Questions

If you have questions or issues when using this software, please feel free to open an [issue][new-issue] regarding the question. Questions will be addressed as soon as possible.

## <a name="issues"></a> Issues and Bugs

If you encounter any issues or bugs when using this software, please file an [issue][new-issue] for the project. Please ensure, before filing a new issue, that the specific issue or bug discovered has not already been added to the [issues][issues] by another user.

Pull requests to fix bugs are always welcome. If the fix involves a large change to the design of the project, please discuss the proposed change in the issue prior to submitting a pull request. This helps reduce the duplication of work.

## <a name="features"></a> Feature Requests

Feature requests can be submitted by filing an [issue][new-issue] for the project. Please ensure, before filing a new issue, that the specific issue or bug discovered has not already been added to the [issues][issues] by another user.

Pull requests to add new features are generally welcome. However, for new features, it is requested that the design, functionality and purpose of the new feature be described and dicussed on the feature request issue before a pull request for it is submitted. This helps reduce the duplication of work and it ensures that the new feature falls within the project's intended scope.

## <a name="docs"></a> Documentation

Good documentation is the cornerstone of any good open-source software project. Pull requests to improve documentation are always welcome, especially if an aspect of the project is poorly described or not described at all.

Documentation is constantly changing as a project progresses, therefore, it is requested that an [issue][new-issue] be filed before improving the documentation if the change is anticipated to be large in scope.

Smaller changes, such as those that correct grammer and spelling mistakes, can be implemented without the need for a seperate issue to be filed.

## <a name="submissions"></a> Submission Guidelines

### Submitting an Issue

Reporting issues is a critical component of collaborative software development. Before submitting an issue, please review the already reported [issues][issues] for a duplicate scenario. It is possible that other users have encountered the same issue and recieved a fix or workaround for it.

If the issue appears to be unique, please provide the following information in the issue comment:

* **Overview** - Summary of the issue that is occurring. If an error is being raised (typically in the brower's console), including a non-minified stack trace is appreciated.
* **Motivation or Use Case** - What is your use case? Does your use of this software conform with the current documentation? Are you attempting to operate outside of the documented functionality of the software? This may point to the need for a feature request rather than highlighting an issue with the project source code.
* **Browsers and/or Operating Systems** - When the issue occured, what browser or browers were being used? What is the version of the brower or browers? What is the operating system on which the browser is running? What version is the operating system?
* **Reproduce the Issue** - A reproduction of the issue is very helpful. It is requested that a live example is provided via [Runnable][runnable]. A list of steps to reproduce the issue is also helpful in lieu of a live example. If a list is provided, please be specific as possible so that other contributors can reproduce the issue on their machines.
* **Related Issues** - Has this issue been reported before? Perhaps the issue was reported earlier and was closed prematurely.
* **Suggestions** - If you cannot fix the issue yourself, it is helpful if you can provide any suggestions or implementation ideas so that another contributor can provide a fix more easily. Please be specific as possible.

### Installing the Project Git Pre-Commit Hook Script

A project-wide Git pre-commit hook script has been included in this project's source. Before committing any changes, please install the hook script by entering the following command in the root of the project repository:

     ln -s ../../scripts/git/validate-commit-msg.js .git/hooks/commit-msg

### Submitting a Pull Request

Before you submit your pull request, please consider the following guidelines:

* Search the current [pull requests][pull-requests] for an open or closed Pull Request that may be the same or similar to your proposed submission. This helps reduce the duplication of effort.
* Make all your changes in a new branch in your fork:

     ```shell
     git checkout -b my-change-branch master
     ```

* Make sure to include all appropriate test cases.
* Make sure to follow the [Code Style Guidelines](#style).
* Run the full test suite and ensure that all tests pass. All merges (pull requests) accepted into the 'master' branch are automatically tested with [drone.io][drone.io].
* Commit your changes using a descriptive commit message that follows the project [Commit Message Format](#commit-message-format) and passes the project Git pre-commit hook, `validate-commit-msg.js`. Adherence to the [Commit Message Format](#commit-message-format) is required because release notes are automatically generated from commit messages.

     ```shell
     git commit -a
     ```
  Please note that the optional commit `-a` command line option will automatically "add" and "rm" edited files.

* Push your branch to your fork:

    ```shell
    git push origin my-change-branch
    ```

* Send a pull request to `graph-paper:master`.
* If changes are needed or requested in response to the Pull Request, please perform the following: 
  * Make the required or requested changes to the branch in your fork.
  * Run the project test suite to ensure tests are still passing.
  * Rebase your branch and force push to your forked repository (this will update the Pull Request).

    ```shell
    git rebase master -i
    git push -f
    ```

  * Remove (squash) any intermediate commits so that the commit history is kept clean. See [this answer](http://stackoverflow.com/a/15055649) on Stack Overflow for information on how to do this.

#### Pull Request Post-Acceptance Tasks

After your Pull Request is merged, you can safely delete your branch and pull the changes from the upstream repository:

* Delete the remote branch on GitHub either through the GitHub website or your local terminal as follows:

    ```shell
    git push origin --delete my-change-branch
    ```

* Checkout the "master" branch:

    ```shell
    git checkout master -f
    ```

* Delete your local branch:

    ```shell
    git branch -D my-change-branch
    ```

* Update your local "master" branch with the latest upstream changes:

    ```shell
    git pull --ff upstream master
    ```

## <a name="style"></a> Code Style Guidelines

To ensure consistency throughout the project source code, it is requested that the following guidelines be considered when contributing to this project:

  * All new features or bug fixes **must be tested** by one or more [specs][unit-testing].
  * All public API methods **must be documented** with [doc comments][doc-comments].
  * Besides any of the specific exceptions noted below, this project attempts to conform with the style rules described in
  [Google's Dart Style Guide][dart-style-guide].

## <a name="commits"></a> Commit Message Guidelines

Please review the guidelines and rules described below when creating commit messages.

These guidelines help to keep the project commit history readable. In addition, the project release notes (changelogs) are automatically generated from the commit messages that have occurred between discrete tags, so consistently formatted messages help users decipher changes when updating their package versions.

### <a name="commit-message-format"></a> Commit Message Format

Each commit message consists of a **header**, a **body** and a **footer**.

The header has a special format that includes a **type**, a **scope** and a **subject**:

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

Any line of the commit message **cannot** be longer 100 characters. This allows the message to be easier to review through the GitHub interface, as well as, in Git command line tools.

### Type

The "type" field must be one of the following:

* **feat**: New features.
* **fix**: Bug fixes.
* **docs**: Documentation changes.
* **style**: Changes that do not affect the semantics of the code or the design intent (white space, formatting, missing semi-colons...etc.). Changes which are purely visual or aesthetic in nature to demos and examples are also included under this type.
* **refactor**: Changes that neither fix a bug or add a feature.
* **perf**: A code change that improves runtime performance.
* **test**: Adds missing tests.
* **chore**: Changes to the build process or to auxiliary tools and libraries. For example, changes to tools which handle automated documentation generation are covered under this commit type.

### Scope

The scope can be anything specifying the location of the change. Examples can include:

* Class names
* Library names
* File names (without the file extension)
* Major function names

The goal of the scope is to help other contributors quickly locate a commit message of interest that impacts a specific system or subsystem of the project.

### Subject

The subject contains a brief (but detailed) description of the change. Please consider the following when entering a subject:

* Use the imperative, present tense forms - "change" instead of "changed" or "changes".
* Do not capitalize the first letter.
* Do not include a period or dot (.) at the end.

###Body

As in the **subject** field, use the imperative, present tense forms - "change" instead of "changed" or "changes".
The body should include the motivation for the change and its contrast with previous behavior.

###Footer

The footer should contain information about any breaking changes. The footer should also reference any GitHub issues that this commit closes, if applicable. To associate a specific commit activity with the closing of a GitHub issue, please see [this](https://help.github.com/articles/closing-issues-via-commit-messages) page.

[dart-style-guide]: https://www.dartlang.org/articles/idiomatic-dart
[drone.io]: https://drone.io
[doc-comments]: https://www.dartlang.org/articles/doc-comment-guidelines
[issues]: https://github.com/adamjcook/graph-paper/issues
[new-issue]: https://github.com/adamjcook/graph-paper/issues/new
[pull-requests]: https://github.com/adamjcook/graph-paper/pulls
[runnable]: http://runnable.com
[unit-testing]: https://www.dartlang.org/articles/dart-unit-tests