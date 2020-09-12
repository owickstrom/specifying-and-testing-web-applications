---
title: Quickstrom
subtitle: Specifying and Testing Web Applications
author: Oskar Wickström
date: September 2020
theme: Boadilla
classoption: dvipsnames
---

- Background
    - Web development
        - Always an interest of mine
        - Huge area
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

- Specification language
    - Specification language
        - Based on PureScript
        - Extended with:
            - LTL operators
              - propositional
              - linear temporal logic
              - finite traces
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


- The TodoMVC Showdown

