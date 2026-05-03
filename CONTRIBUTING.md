# Contributing to BaguetteFrench

First of all, thanks for taking the time to contribute!

All types of contributions are encouraged and valued. See the [Table of Contents](#table-of-contents) for different ways to help and details about how this project handles them. Please make sure to read the relevant section before making your contribution. It will make it a lot easier for maintainers and smooth out the experience for all involved. The community looks forward to your contributions. 🎉

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [I Have a Question](#i-have-a-question)
- [I Want To Contribute](#i-want-to-contribute)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)
- [Improving The Documentation](#improving-the-documentation)
- [Styleguides](#styleguides)
- [Commit Messages](#commit-messages)
- [Join The Project Team](#join-the-project-team)

## Code of Conduct

This project and everyone participating in it is governed by the
[Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code.

## I Have a Question

If you want to ask a question, we assume that you have read the documentation. _(That someone hopefully created by the time you're reading this)_

Before you ask a question, it is best to search for existing [Issues](https://github.com/oliver-lobig/baguettefrench/issues) that might help you. In case you have found a suitable issue and still need clarification, you can write your question in this issue. It is also advisable to search the internet for answers first.

If you then still feel the need to ask a question and need clarification, we recommend the following:

- Open an [Issue](https://github.com/oliver-lobig/baguettefrench/issues/new).
- Provide as much context as you can about what you're running into / what you want to know.
- If it is a bug, provide project and platform versions (Linux, Windows, Mac, etc...), depending on what seems relevant.

We will then take care of the issue as soon as possible.

## I Want To Contribute

> ### Legal Notice
>
> When contributing to this project, you must agree that you have authored 100% of the content, that you have the necessary rights to the content and that the content you contribute may be provided under the project license. **This also means, that you have not used Generative AI in making you contribution.**

### Reporting Bugs

#### Before Submitting a Bug Report

A good bug report shouldn't leave others needing to chase you up for more information. Therefore, we ask you to investigate carefully, collect information and describe the issue in detail in your report. Please complete the following steps in advance to help us fix any potential bug as fast as possible.

- Make sure that you are using the latest version.
- Determine if your bug is really a bug and not an error on your side e.g. using incompatible environment components/versions (If you are looking for support, you might want to check [this section](#i-have-a-question)).
- To see if other users have experienced (and potentially already solved) the same issue you are having, check if there is not already a bug report existing for your bug or error in the bug tracker.
- Also make sure to search the internet to see if users outside of the community have discussed the issue.
- Collect information about the bug:
    - Stack trace (Traceback)
    - OS, Platform and Version (Windows, Linux, macOS, x86, ARM)
    - Version of Godot.
    - Can you reliably reproduce the issue? And can you also reproduce it with older versions of the programm?

#### How Do I Submit a Good Bug Report?

> You must never report security related issues, vulnerabilities or bugs including sensitive information to the issue tracker, or elsewhere in public. Instead sensitive bugs must be sent by email to support@lobigart.de.

We use GitHub issues to track bugs and errors. If you run into an issue with the project:

- Open an [Issue](/issues/new). (Since we can't be sure at this point whether it is a bug or not, we ask you not to talk about a bug yet and not to label the issue.)
- Explain the behavior you would expect and the actual behavior.
- Please provide as much context as possible and describe the _reproduction steps_ that someone else can follow to recreate the issue on their own. This usually includes your code. For good bug reports you should isolate the problem and create a reduced test case.
- Provide the information you collected in the previous section.

Once it's filed:

- The project team will label the issue accordingly.
- A team member will try to reproduce the issue with your provided steps. If there are no reproduction steps or no obvious way to reproduce the issue, the team will ask you for those steps and mark the issue as `needs-repro`. Bugs with the `needs-repro` tag will not be addressed until they are reproduced.
- If the team is able to reproduce the issue, it will be marked `needs-fix`, as well as possibly other tags (such as `critical`), and the issue will be left to be [implemented by someone](#your-first-code-contribution).

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for BaguetteFrench, **including completely new features and minor improvements to existing functionality**. Following these guidelines will help maintainers and the community to understand your suggestion and find related suggestions.

#### Before Submitting an Enhancement

- Make sure that you are using the latest version.
- Find out if the functionality is already covered, maybe by an individual configuration.
- Perform a [search](https://github.com/oliver-lobig/baguettefrench/issues/new) to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.
- Find out whether your idea fits with the scope and aims of the project. It's up to you to make a strong case to convince the project's developers of the merits of this feature. Keep in mind that we want features that will be useful to the majority of our users and not just a small subset. If you're just targeting a minority of users, consider writing an add-on/plugin library. _(when or if that will ever be a feature)_

#### How Do I Submit a Good Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://github.com/oliver-lobig/baguettefrench/issues/new).

- Use a **clear and descriptive title** for the issue to identify the suggestion.
- Provide a **step-by-step description of the suggested enhancement** in as many details as possible.
- **Describe the current behavior** and **explain which behavior you expected to see instead** and why. At this point you can also tell which alternatives do not work for you.
- You may want to **include screenshots and animated GIFs** which help you demonstrate the steps or point out the part which the suggestion is related to.
- **Explain why this enhancement would be useful** to most BaguetteFrench users. You may also want to point out the other projects that solved it better and which could serve as inspiration.

### Improving The Documentation

There should be a documentation some day. If there isn't one allready, talk to support@lobigart.de about creating one.

## Styleguides

The codebase may not fully follow this styleguide yet. If you see a violation, feel free to fix it.

### Commit Messages

Your commit messages say precisely what you did in that commit. Also, we mark usable _(stable)_ commits with `*usable*` and work-in-progress commits with `*wip*`

### Code

#### Variables

Use _snake_case_ and always hint the type if possible.
Make sure anyone can understand, what this variable is used for from its name.

**Example:**

    var is_correct: bool = true

#### Constants

Use _SCREAMING_SNAKE_CASE_. Type-hinting is optional.
Make sure anyone can understand, what this constant is used for from its name.
Constants are generally only used for preloading resources in this codebase.

**Example:**

    const IS_CORRECT: bool = true

#### Functions

Use _snake_case_ and always hint the type if the function returns a value.
Make sure anyone can understand, what this function is used for from its name.

**Example:**

    func complete_paragraph(paragraph_id: String = "example") -> bool:
    return is_complete(paragraph_id)

#### Other casing

| Type       | Casing                 | Example                                         |
| ---------- | ---------------------- | ----------------------------------------------- |
| Nodes      | _PascalCase_           | `SomeNode`                                      |
| Signals    | _snake_case_           | `signal something(id: int)`                     |
| Classes    | _PascalCase_           | `class_name SomeClass`                          |
| Enums      | _SCREAMING_SNAKE_CASE_ | `@export_enum("ONE","TWO) var version: int = 0` |
| Properties | _snake_case_           | `{"lines":4}`                                   |

#### Code structure - Do's & Dont's

**Do:**

        func create_word(translation: String = "") -> bool:
        var word: Word = Word.new()
        word.translation = translation

    	if Vars.words.contains(word):
    		return false

    	if !word.is_valid():
    		return false

    	Vars.words.append(word)

    	return true

**Don't:**
    
    func DoSomething(argument1):
        var var1 = Word.new()
        var1.translation = argument1
        if !Vars.words.contains(word):
            if word.is_valid() == true: # Not using truthy/falsy behavior is fine, if other behavior is NEEDED
                Vars.words.append(var1)
                return true
            else:
                return false
        else:
            return false

## Join The Project Team

The project is currently maintained by one person, which is doing this as a hobby project. As the project grows larger, there should be multiple people in the team. If you consider the project large enough and want to apply, write an e-mail to support@lobigart.de.
In your application, write how you want to help and which role/rights that would require. If you are in the project team, you are expected to follow the rules in this document. Should you fail to do that, there will be consequnces as per [Code of Conduct](CODE_OF_CONDUCT.md)

## Software used in development

The following software is used in development.
You do not _have_ to use it, but using this software
will help you to better integrate you changes and
results in a more coherent code/assetbase. This project
relys on FOSS software.

Godot Engine _(Not optional; Needed for running/building/developing the project)_
Krita _(Needed for opening the original .kra files of assets)_
Inkscape _(Offers more features for the .svg files in this project, since they were also created with it)_

## Goals/Milestones for BaguetteFrench

### Shortterm Goals

> This section is going to switch to [GitHub issues](https://github.com/oliver-lobig/baguettefrench/issues) some day.

- Add Sounds
    - Helpful and fun. Not anoying.
- Animated Graphics
    - Most of the UI is only a bit over the level of _functional_.
      The App should be _fun_ to use. Therefore the UI should be very
      reactive.
- Better word-reccomendation

### Longterm Vision/Milestones

- Expansion to more languages
    - May involve:
        - renaming to "BaguetteLearn" _(or similar)_
        - Changing most of the codebase
- Option to easily share word decks; account management; etc. _(IMPORTANT: Everything must be secure and trustworthy; No unnessicary data should be stored)_
