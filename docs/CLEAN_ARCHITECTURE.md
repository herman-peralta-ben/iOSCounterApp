# Clean Architecture

```mermaid
graph TD
    Data --> |Depends on| Domain
    iOSCounterApp --> |Depends on| Data 
    iOSCounterApp --> |Depends on| Domain    
```
1. Make sure that `Domain` and `Data` are listed in `Frameworks, Libraries, and Embedded Content`.

<img src="./images/Presentation.webp" width="300" alt="Domain and Data listed">

2. Make sure that `Data`'s `Packages.swift` adds `Domain` as **Package** and **Target dependency**.

<img src="./images/Data.webp" width="300" alt="Data references Domain">

3. Clean & Build by pressing <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>K</kbd> (Clean) and then <kbd>Cmd</kbd> + <kbd>B</kbd> (Build) to refresh the index.
