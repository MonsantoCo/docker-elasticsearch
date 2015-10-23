# Contribution Guidelines

## Pull requests are always welcome
We're trying very hard to keep our systems simple, lean and focused. We don't want them to be everything for everybody. This means that we might decide against incorporating a new request.

## Create issues...
Any significant change should be documented as a GitHub issue before anybody starts working on it.

### ...but check for existing issues first!
Please take a moment to check that an issue doesn't already exist before documenting your request. If it does, it never hurts to add a quick "+1" or "I need this too". This will help prioritize the most common requests.


## Conventions
Fork the repository and make changes on your fork on a branch:

1. Create a topic branch from where you want to base your work. This is usually master.
2. Make commits of logical units.
3. Make sure your commit messages are in the proper format, see below
4. Push your changes to a topic branch in your fork of the repository.
5. Submit a pull request

Note that the maintainers work on branches in this repository.

Work hard to ensure your pull request is valid.

Pull request descriptions should be as clear as possible and include a reference to all the issues that they address. In GitHub, you can reference an issue by adding a line to your commit description that follows the format `Fixes #N` where N is the issue number.

### Commit Style Guideline

We follow a rough convention for commit messages. An example of a commit:
```
feat(scripts/test-cluster): add a cluster test command
This uses Docker to setup a test cluster that you can easily kill and start for debugging.
```
Formally, it looks something like this:
```
{type}({scope}): {subject}
{body}
<BLANK LINE>
{footer}
```
  - {scope} can be anything specifying the place of the commit change.
  - {subject} needs to use imperative, present tense such as “change”, not “changed” nor “changes”. The first letter should not be capitalized, and there is no dot (.) at the end.
  - {body} also needs to be in the present tense, and includes the motivation for the change. The first letter in a paragraph must be capitalized.
  - {footer} should mention all breaking changes with the description of the change, the justification behind the change and any migration notes required.

Any line of the commit message cannot be longer than 72 characters, with the subject line limited to 50 characters. This allows the message to be easier to read on GitHub as well as in various git tools.

The allowed {types} are:

  - feat -> feature
  - fix -> bug fix
  - docs -> documentation
  - style -> formatting
  - ref -> refactoring code
  - test -> adding missing tests
  - chore -> maintenance

## Merge approval
Repository maintainers use **LGTM (Looks Good To Me)** in comments on the code review to indicate acceptance.

A change requires LGTMs from an absolute majority of the **MAINTAINERS**. The **Benevolent Dictator For Life (BDFL)** reserves sole veto power. We recommend also getting an LGTM from the BDFL in advance of merging to avoid the possibility of a revert.

#### Small patch exception
There are exceptions to the merge approval process. Currently these are:

  * Your patch fixes spelling or grammar errors.
  * Your patch fixes Markdown formatting or syntax errors in any .md files in this repository

## How can I become a maintainer?
Make important contributions. Don't forget, being a maintainer is a time investment. Make sure you will have time to make yourself available. You don't have to be a maintainer to make a difference on the project!

## What is a maintainer's responsibility?
It is every maintainer's responsibility to:

  1. Deliver prompt feedback and decisions on pull requests.
  2. Be available to anyone with questions, bug reports, criticism, etc. on their component. This includes Slack and GitHub requests
  3. Make sure their component respects the philosophy, design and road map of the project.

## How are decisions made?
Short answer: with pull requests to this repository.

All decisions, big and small, follow the same 3 steps:

  1. Open a pull request. Anyone can do this.

  2. Discuss the pull request. Anyone can do this.

  3. Accept (`LGTM`) or refuse a pull request. The relevant maintainers
     do this (see below "Who decides what?")

     1. Accepting pull requests

        1. If the pull request appears to be ready to merge, give it a `LGTM`, which stands for "Looks Good To Me".

        2. If the pull request has some small problems that need to be changed, make a comment addressing the issues.

        3. If the changes needed to a PR are small, you can add a "LGTM once the following comments are addressed..." this will reduce needless back and forth.

        4. If the PR only needs a few changes before being merged, any MAINTAINER can make a replacement PR that incorporates the existing commits and fixes the problems before a fast track merge.

     2. Closing pull requests

        1. If a PR appears to be abandoned, after having attempted to contact the original contributor, then a replacement PR may be made. Once the replacement PR is made, any contributor may close the original one.

        2. If you are not sure if the pull request implements a good feature or you do not understand the purpose of the PR, ask the contributor to provide more documentation. If the contributor is not able to adequately explain the purpose of the PR, the PR may be closed by any MAINTAINER.

        3. If a MAINTAINER feels that the pull request is sufficiently architecturally flawed, or if the pull request needs significantly more design discussion before being considered, the MAINTAINER should close the pull request with a short explanation of what discussion still needs to be had. It is important not to leave such pull requests open, as this will waste both the MAINTAINER's time and the contributor's time. It is not good to string a contributor on for weeks or months, having them make many changes to a PR that will eventually be rejected.

## Who decides what?
All decisions are pull requests, and the relevant maintainers make decisions by accepting or refusing pull requests. Review and acceptance by anyone is
denoted by adding a comment in the pull request: `LGTM`. However, only currently listed `MAINTAINERS` are counted towards the required majority.

Event repositories follow the timeless, highly efficient and totally unfair system known as [Benevolent dictator for life](http://en.wikipedia.org/wiki/Benevolent_Dictator_for_Life). This means that all decisions are made in the end, by default, by **BDFL**. In
practice decisions are spread across the maintainers with the goal of consensus prior to all merges.

The current BDFL is listed by convention in the first line of the MAINTAINERS file with a suffix of "BDFL".

## I'm a maintainer, should I make pull requests too?

Yes. Nobody should ever push to master directly. All changes should be made through a pull request.

## Who assigns maintainers?
MAINTAINERS are changed via pull requests and the standard approval process - i.e. create an issue and make a pull request with the
changes to the MAINTAINERS file.

## How is this process changed?
Just like everything else: by making a pull request :)
