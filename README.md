
# OnBoarding-Package

OnBoarding-Package is a modular iOS library that helps you build interactive onboarding tutorials with automatic UI highlighting, smooth animations, and guided user flows.

✨ Designed to simplify onboarding and improve feature discoverability with minimal effort.

---

## ✨ Features

- 🔍 Automatic UI highlighting using `accessibilityIdentifier`
- 🎨 Multiple highlight styles: `.plain`, `.spotlight`, `.none`
- 📜 Smart scrolling for off-screen elements
- 🎬 Smooth animations with optional haptics
- ⚡ Auto start support on screen load
- 🧩 Modular and easily extendable architecture
- 📱 Compatible with UIKit and SwiftUI

---

## 🛠️ Tech Stack

| 🧱 Layer | ⚙️ Tech Used |
|---------|-------------|
| 💻 Language | Swift 5.7+ |
| 🎨 UI Framework | UIKit, SwiftUI |
| 🎬 Animation | Core Animation |
| 💾 Persistence | UserDefaults |
| 📦 Packaging | Swift Package Manager (SPM) |

---

## ⚙️ Requirements

- Xcode 14.0 or later
- Swift 5.7 or later
- iOS 13.0+

---

## 📦 Installation & Setup

### ⚙️ Prerequisites
- ✅ Xcode installed
- 📘 Basic knowledge of UIKit or SwiftUI

### 🧑‍💻 Setup Instructions

1. 📂 Open your project in Xcode  
2. ➡️ Go to:
```

File → Add Package Dependencies

```
3. ➕ Select:
```

Add Local Package

````
4. 📁 Choose the package folder and click **Add Package**

---

## 🚀 Quick Start (UIKit)

### 1️⃣ Import Library
```swift
import AutoTutorialKit
````

💡 Imports the onboarding library into your project.

---

### 2️⃣ Reset Tutorial (For Testing Only)

```
UserDefaults.standard.removeObject(forKey: "AutoTutorial_HomeViewController")
```

⚠️ Clears saved state so tutorial runs again. Remove in production.

---

### 3️⃣ Configure Manager

```swift id="jq0fso"
AutoTutorialManager.shared.globalOverlayAlpha = 0.7
AutoTutorialManager.shared.globalHighlightStyle = .plain
AutoTutorialManager.shared.start()
```

💡 Controls:

* Overlay transparency
* Default highlight style
* Starts tutorial engine

---

### 4️⃣ Register Tutorial

```
AutoTutorialManager.shared.registerTutorial(
    forViewController: "HomeViewController",
    steps: [
        AutoTutorialStep(viewID: 101, title: "Profile", description: "Your profile picture."),
        AutoTutorialStep(viewID: 102, title: "Add New", description: "Create something.", style: .spotlight),
        AutoTutorialStep(viewID: 200, title: "First Item", description: "Tap to open.")
    ],
    themeColor: .systemPurple
)
```

💡 Defines:

* Screen identifier
* Step-by-step onboarding flow
* Theme color for next button 

---

### 5️⃣ Tag Views

```
profileImage.accessibilityIdentifier = "101"
```

💡 Links UI element with tutorial step.

---


## 🧪 Quick Start (SwiftUI)

### 1. Configure Tutorial

```swift
.onAppear {
    AutoTutorialManager.shared.globalOverlayAlpha = 0.7
    AutoTutorialManager.shared.globalHighlightStyle = .plain
    AutoTutorialManager.shared.start()
}
````

---

### 2. Register Tutorial

```swift
AutoTutorialManager.shared.registerTutorial(
    forViewController: "HomeView",
    steps: [
        AutoTutorialStep(viewID: 101, title: "Profile", description: "Your profile section."),
        AutoTutorialStep(viewID: 102, title: "Add Item", description: "Tap to add new item.", style: .spotlight)
    ],
    themeColor: .purple
)
```

---

### 3. Tag Views

```swift
Image("profile")
    .accessibilityIdentifier("101")

Button("Add") {
    // action
}
.accessibilityIdentifier("102")
```


---



## 📚 Usage Guide

* Initialize manager and configure global settings
* Register tutorial steps for a screen
* Assign identifiers to UI elements
* Start tutorial automatically or manually

---

## 🧩 Core Components

### AutoTutorialManager

* Manages tutorial lifecycle
* Controls step transitions
* Applies global configuration

### AutoTutorialStep

* Represents a single tutorial step
* Contains title and description
* Targets a specific UI element

### TargetHighlight

* Locates UI elements
* Calculates position on screen
* Passes data to overlay

### TutorialHighlightStyle

```swift id="sjg2v0"
.plain
.spotlight
.none
```

💡 Defines how highlighted UI appears.

---

### TutorialOverlayView

* Renders overlay UI
* Displays content
* Handles animations and interactions

---

## 📁 Folder Structure

```
AutoTutorialKit/
│
├── Sources/
│   └── AutoTutorialKit/
│       ├── Manager/
│       │   └── AutoTutorialManager.swift
│       │
│       ├── Model/
│       │   ├── AutoTutorialStep.swift
│       │   ├── TargetHighlight.swift
│       │   └── TutorialHighlightStyle.swift
│       │
│       ├── View/
│       │   └── TutorialOverlayView.swift
│
├── Package.swift
└── README.md
```

---

## How It Works

1. Register tutorial steps  
2. Manager detects screen load  
3. Views are matched using identifiers  
4. Overlay highlights elements  
5. User proceeds step-by-step
---

## Contributing

Contributions are welcome.

* 🐛 Report bugs via issues
* 💡 Suggest improvements
* 🔧 Submit pull requests

---

## 📜 License

Open source for learning and development purposes.

---

## Support

* Open an issue for help
* Contact: [email protected]

---

## Acknowledgements

* Apple Developer Community
* Official documentation and resources

---

## 🎥 Demo

[https://github.com/user-attachments/assets/9d8bb452-b59c-41d8-a4c8-9b15854964e1](https://github.com/user-attachments/assets/9d8bb452-b59c-41d8-a4c8-9b15854964e1)

```


