---
name: Bug Report
about: Use this template reporting bugs and unexpected behavior.
labels: bug, needs triage
---

body:
- type: markdown
    attributes:
        value: "# Bug Report"

- type: markdown
    attributes:
        value: Thank you for opening a bug report! Please take the time to properly and thoughtfully fill |
        out this form to make it easier for us ^^ thanks :)

- type: markdown
    attributes:
        value: Final Info before you start filling everything out. |
        If you are *not* using the Beta/Redesign already please only report **critical / app breaking** issues. |
        This is because the beta version is likely to already have all the features and bug fixes you might be searching for.


- type: checkboxes
    id: type
    attributes:
        label: Type of Report
        description: You can select multiple if applicable
        options:
            - label: The app is unusable
            - label: Something isn't working
            - label: Unexpected behavior
            - label: Design feedback
            - label: Accessibility
            - label: none of the above
    validations:
        required: true

- type: checkboxes
    id: branch
    attributes:
        label: App Branch
        options:
            - label: Stable
            - label: Redesign (beta)
    validations:
        required: true

- type: input
    id: version
    attributes: 
        label: The exact version of the app
        description: You can find the app version inside the settings screen at the top right (the circle with the I)
        placeholder: 0.9.18
    validations:
        required: true

- type: checkboxes
    id: affects
    attributes:
        label: Affected Devices/Platform
        options:
            - label: Android
            - label: Android Auto
            - label: iOS
            - label: Linux
            - label: MacOS
            - label: Windows
    validations:
        required: true

- type: input
    id: device
    attributes: 
        label: Device
        description: If you think the device you are using is part of the problem please fill give some details here

- type: textarea
    id: description
    attributes:
        label: Description & Steps to Reproduce
        description: Please describe what the issue precisely is and if possible how to reproduce it
  validations:
    required: true

- type: textarea
    id: logs
    attributes:
        label: Logs
        description: If necessary paste the relevant section of the logs here. |
                     |
                     Alternatively state the approximate/exact time of the issue here |
                     and upload the log file as a comment on this issue. You may need to |
                     put the text file into a .zip due to file size. |
                     |
                     To get the logs Open the side menu, click "Logs", and then use the |
                     *share* button at the top right to get the log file. DO NOT use the copy
                     button, since that doesn't contain all logs!

- type: textarea
    id: others
    attributes:
        label: Additional Information
        description: If you want to add something which doesn't fit in the above categories feel free to add this here :)

- type: checkboxes
    id: updated
    attributes:
        label: Are you using the newest Version?
        description: Did you make sure you are already using the newest version of Finamp?
        options:
            - label: Yes. This bug report is still valid
              required: true
