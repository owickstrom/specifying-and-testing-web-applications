---
title: Quickstrom
subtitle: Specifying and Testing Web Applications
author: Oskar Wickström
date: September 2020
theme: Boadilla
classoption: dvipsnames
---

## Quickstrom

- Autonomous browser testing
- You write specifications
- Test anything that renders to the DOM
- Quickstrom explores your application and finds invalid behaviors

## Today's Agenda

- Background
- The TodoMVC Showdown
- Specification Language
- Checking Webapps
- Future Work
- Q&A

# Background

## Web development

- Always an interest of mine
- Huge area and market
- Browser testing is mainly example/scenario based

## Property-Based Testing

- Last few years
    - Blog posts
    - Book: "Property-Based Testing in a Screencast Editor"
- State machine testing for UIs
    - Lots of work
    - Boilerplate
    - Requires a full model

## Formal Methods

- I've been exploring:
    - F*
    - TLA+
    - Temporal logics

## Idea: A Beautiful Mix

- Use linear temporal logic (LTL) and learnings from formal methods
- Use it for browser testing
- Leverage the DOM and introspective capabilities
- Run as property-based tests

## Benefits of Quickstrom

- Many strenghts of property-based testing
- But also:
    - Focus on specifying and understanding
    - No more `sleep` or `wait`
    - Safety properties can be "weak"

## How It Works

1. Navigate to *origin page*
2. Record a trace (sequence of states and actions):
    1. Generate random actions
    2. Pick one *possible* action and perform it
    3. Record state
    4. Go to 2.1 if not done
3. Check that the behavior (only the states) satisfies the
   specification
4. If rejected, shrink sequence of actions and rerun

# The TodoMVC Showdown

## Early benchmark: TodoMVC

- Use TodoMVC as a test for Quickstrom
- Wrote a single spec (for new and legacy formats)
- Checked mainstream implementations
- Found issues in Angular and Mithril implementations
- Submitted a [GitHub
  issue](https://github.com/tastejs/todomvc/issues/2116) with findings

## The TodoMVC Showdown

- Improved the specification
- Checked all implementations
- Results:
  - 37 passed
  - 12 failed
  - 4 not testable
- Wrote a [blog
  post](https://wickstrom.tech/programming/2020/07/02/the-todomvc-showdown-testing-with-webcheck.html)
  detailing the results

# Specification Language

## Specification Language

- Based on PureScript
- Extended with:
    - Linear temporal logic operators
      - [De Giacomo, G., and Vardi, M. 2013](https://www.researchgate.net/publication/285919325_Linear_temporal_logic_and_Linear_Dynamic_Logic_on_finite_traces)
    - DOM queries
- Use regular PureScript packages
- Interpreter built in Haskell

## Temporal Operators

- Change the modality of the sub-expression
- Available operators from LTL:

    ```haskell
    next :: forall a. a -> a
    always :: Boolean -> Boolean
    until :: Boolean -> Boolean -> Boolean
    ```

## DOM Queries

- Two operators:
  - `queryOne`
  - `queryAll`
- Take as arguments:
  1. CSS selector
  2. Record of _element state specifiers_

## Example: DOM Queries
    
```haskell
queryAll "button" { textContent, disabled }
    :: Array { textContent :: String
             , disabled :: Bool 
             }

queryOne "input" { value }
    :: Maybe { value :: String }
```

## Actions

- We must instruct Quickstrom which actions to try
- List of weighted probabilities and action specifiers

    ```
    Array (Tuple Int Action)
    ```

- Comes with predefined actions, e.g. `foci`, `clicks`
- Often need to carefully pick selectors, actions, and weights

## Haskell Interpreter

- Some supported PureScript packages:
  - `numbers`
  - `strings`
  - `arrays`
  - `transformers`
  - `generics-rep`
- FFI is implemented in Haskell
    - Packages' foreign functions are built into Quickstrom

# Checking Webapps

## Running Tests

Use the `check` command:

```sh
quickstrom check Example.spec.purs http://example.com
```

Origin can be a file:

```sh
quickstrom check Example.spec.purs example.html
```

## Cross-Browser Testing

- Currently supports two browsers:
    - Firefox
    - Chrome/Chromium
- Theoretically all WebDriver-enabled browsers

## Trailing State Changes

- **Default:** record a single state change after each action
- **Override:** also record *trailing* state changes
- Often caused by asynchronous operations
- Two command-line options:
    - `--max-trailing-state-changes`
    - `--trailing-state-change-timeout`

# What's Next?

## Possible Features

- Better error reporting
- Coverage (for specifications)
- Targeted search
- Screenshotting unique states

## Commercial Product

- Keep Quickstrom and the CLI open source
- Build a SaaS on top
    - Browser-based IDE for specs and runner
    - Scheduled checks and reports
    - Integrations (CI, WebDriver services)
    - Alternative specification language (e.g. subset of JavaScript)
    
## Resources

- [quickstrom.io](https://quickstrom.io/) (main website)
- [buttondown.email/quickstrom](https://buttondown.email/quickstrom) (newsletter)

# Q&A
