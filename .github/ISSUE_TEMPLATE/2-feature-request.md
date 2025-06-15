---
name: Feature Request
about: Use this template requesting new functionality. Please keep it reasonable :)
labels: feature, needs triage
---

body:
- type: markdown
    attributes:
        value: "# Feature Request"

- type: markdown
    attributes:
        value: Thank you for opening a feature Request! Please take the time to properly and thoughtfully fill |
        out this form to make it easier for us ^^ thanks :)

- type: markdown
    attributes:
        value: Final Info before you start filling everything out. |
        If you are *not* using the Beta/Redesign already please do **not** open a feature request. New features |
        will only be added to the Redesign version of the app!

- type: checkboxes
    id: type
    attributes:
        label: Type of Feature
        description: You can select multiple if applicable
        options:
            - label: Something new
            - label: Extension of a feature
            - label: Improvement of a feature
            - label: Accessibility
            - label: None of the above
    validations:
        required: true

- type: textarea
    id: description
    attributes:
        label: Description
        description: Please describe what the feature precisely is
  validations:
    required: true

- type: textarea
    id: reason
    attributes:
        label: Reasoning
        description: Please describe why this feature would benefit Finamp
  validations:
    required: true

- type: textarea
    id: implementation
    attributes:
        label: Implementation Notes
        description: If you are able to please describe how this feature might |
                     work behind the scenes, what needs to be done an so on

- type: textarea
    id: others
    attributes:
        label: Additional Information
        description: If you want to add something which doesn't fit in the above categories feel free to add this here :)


- type: checkboxes
    id: updated
    attributes:
        label: Are you using the newest Version?
        description: Did you make sure you are already using the newest beta version of Finamp?
        options:
            - label: Yes. This feature request is still valid
              required: true
