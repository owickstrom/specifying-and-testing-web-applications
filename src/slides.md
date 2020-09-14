---
title: Quickstrom
subtitle: Specifying and Testing Web Applications
author: Oskar Wickström
date: September 2020
theme: Boadilla
classoption: dvipsnames
---

- Introduction
    - Quickstrom
        - Autonomous browser testing
        - Test anything that renders to the DOM
        - You write specifications
        - Quickstrom explores your application and finds invalid behaviors
    - Today's agenda
        - Background
        - TodoMVC Showdown
        - Specification language
        - Checking webapps
        - Future work
        - Q&A
- Background
    - Web development
        - Always an interest of mine
        - Huge area and market
        - Browser testing is mainly example/scenario based
    - Property-based testing
        - Last few years
                - Blog posts
                - Book: "Property-Based Testing in a Screencast Editor"
        - State machine testing for UIs
                - Lots of work
                - Boilerplate
                - Requires a full model
    - Formal methods
        - F*
        - TLA+
        - Temporal logics
    - Quickstrom
        - Idea: mix these together
                - Use linear temporal logic (LTL) and learnings from formal methods
                - Use it for browser testing
                - Leverage the DOM and introspective capabilities
                - Run as property-based tests
        - Started in April 2020
    - How it works
        1. Navigate to *origin page*
        2. Record behavior (sequence of states)
            1. Generate random actions
            2. Pick one *possible* action and perform it
            3. Record state
            4. Go to 1
        3. Check that the behavior satisfies the specification
        4. If rejected, shrink sequence of actions

- The TodoMVC Showdown
    - Early benchmark: TodoMVC
        - Use TodoMVC as a test for Quickstrom
        - Wrote a spec (for new and legacy formats)
        - Checked mainstream implementations
        - Found issues in Angular and Mithril implementations
        - Submitted a [GitHub issue](https://github.com/tastejs/todomvc/issues/2116) with findings
    - The TodoMVC Showdown:
        - Improved the specification
        - Ran on all implementations
        - Results:
          - 37 passed
          - 12 failed
          - 4 not testable
        - Wrote a [blog post](https://wickstrom.tech/programming/2020/07/02/the-todomvc-showdown-testing-with-webcheck.html) with findings

- Specification language
    - Specification language
        - Based on PureScript
        - Extended with:
            - Linear temporal logic operators 
              - [De Giacomo, Giuseppe & Vardi, Moshe. (2013). Linear temporal logic and Linear Dynamic Logic on finite traces. IJCAI International Joint Conference on Artificial Intelligence. 854-860.](https://www.researchgate.net/publication/285919325_Linear_temporal_logic_and_Linear_Dynamic_Logic_on_finite_traces)
            - DOM queries
        - Use regular PureScript packages
        - Interpreter built in Haskell
    - DOM Queries
        - Two operators:
          - `queryOne`
          - `queryAll`
        - Take as arguments:
          1. CSS selector
          2. Record of _element state specifiers_
    - Temporal Operators:
        - Change the modality of the sub-expression
        - Available operators from LTL:
            - `next :: forall a. a -> a`
            - `always :: Boolean -> Boolean`
            - `until :: Boolean -> Boolean -> Boolean`

    - Actions
        - We must instruct Quickstrom which actions to try
        - List of weighted probabilities and action specifiers
            ```
            Array (Tuple Int Action)
            ```
        - Comes with predefined actions, e.g.:
            ```
            -- | Generate focus actions on common focusable elements.
            foci :: Actions
            foci = [ Tuple 1 (Focus "input"), Tuple 1 (Focus "textarea") ]
            ```
        - Might need to carefully pick selectors, actions, and weights

    
    - Haskell interpreter
        - Some supported PureScript packages:
          - `numbers`
          - `strings`
          - `arrays`
          - `transformers`
          - `generics-rep`
          - ...
        - FFI is implemented in Haskell
            - Packages' foreign functions are built into Quickstrom

- Checking webapps
    - Running tests
    - Cross-browser testing
    - Trailing state changes

- Future work

    - Possible features
        - Better error reporting
        - Coverage (for specifications)
        - Screenshotting unique states
        - Targeted search
    - Commercial product
        - Keep Quickstrom and the CLI open source
        - Build a SaaS on top
            - Browser-based IDE for specs and runner
            - Scheduled checks and reports
            - Integrations (CI, WebDriver services)
            - Alternative specification language (e.g. subset of JavaScript)

- Q&A
