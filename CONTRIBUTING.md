# Contributing to Backyard Monsters Refitted

Welcome to the Backyard Monsters Refitted development team! This document covers what we expect from contributions and how to get a pull request merged.

---

## 🤖 On AI-Assisted Contributions

We're not banning AI tools, but we are strict about where they belong.

**Reasonable use** is the mechanical stuff: boilerplate, repetitive edits across many files, type definitions, test scaffolding, formatting, renames, and other deterministic work where you already know exactly what the correct output looks like and you're just saving yourself the keystrokes.

**Not acceptable** is handing over the thinking. Entire files, whole features, and architectural decisions must come from a person who understands this codebase. If the structure of your change - how it's split up, where it lives, how it talks to the rest of the system - was decided by a model rather than by you, the pull request will be closed.

The reason is that nothing here exists in isolation. New code lands in a system with established conventions, and a model has none of that context. What it produces looks plausible and quietly ignores how the project actually works. Reviewers are then left reverse-engineering intent that was never there, which costs us far more time than the change saved you.

The standard: **you must be able to explain every line you submit and why it's there.** If a reviewer asks why something is structured the way it is and the honest answer is "that's what the model gave me", it isn't ready. Read it, understand it, test it, own it.

This is ultimately at the maintainers' discretion. If a reviewer judges a pull request to be sub-par and substantially AI-generated, it will be closed without a second look. We're not going to litigate it line by line - the burden is on you to submit work you can stand behind.

If you're unsure about part of your own change, say so in the description or ask in Discord. Nobody minds a question. We do mind a wall of confident, untested code.

---

## 📝 Development Guidelines

We recommend compiling the client application using VSCode, as outlined in our [Wiki](https://github.com/bym-refitted/backyard-monsters-refitted/wiki). This keeps development consistent and makes your changes easy for us to track.

### Code Standards

Follow the style and conventions already established in the codebase:

- Use the ORM provided for all database queries and operations
- Make proper use of TypeScript features (interfaces, type definitions)
- Prefer JSDoc comments over single-line comments
- Keep logic modular and concise
- Understand what you're writing and the problem it solves

Other developers will need to work with your code, so make it readable and maintainable. **We will not accept subpar pull requests.**

### Communication

Communication is key. We have a Discord channel where developers can ask questions and work through issues together. Check the Wiki first, then ask if anything is still unclear.

---

## 🔀 Pull Requests

### Branch Setup

- Check out directly from the branch you intend to make changes to
- Use proper branch naming: `feature/your-change`, `bugfix/issue-description`, `hotfix/urgent-fix`

### Requirements

Every pull request must include a description covering:

- **What** changes you made
- **Why** the changes were necessary
- **How** you tested them

Also:

- Write meaningful commit messages
- **Do not** include any `.swf` files or game binaries — changes should only be in `src`

### Feature Tags

Tag your changes appropriately:

| Tag | Use for |
| --- | --- |
| `experimental` | New features in testing |
| `bugfix` | Bug fixes |
| `performance` | Performance improvements |
| `security` | Security-related changes |

---

*We maintain high standards to ensure quality contributions. Thank you for helping make Backyard Monsters Refitted better!*
