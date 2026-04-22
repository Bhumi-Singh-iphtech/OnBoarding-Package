
# AppTutorialPackage

It is a iOS library to create **interactive onboarding tutorials** with automatic UI highlighting and smooth animations.

---
## Features

* Automatic UI highlighting
* Multiple styles (Plain, Spotlight, None)
* Smart scrolling for off-screen items
* Smooth animations + haptics
* Auto starts on screen load
* Works with UIKit & SwiftUI

---

## Installation
 

1 . Download the package

2 . **File → Add Package Dependencies → Add local → Add Package** 

---

## Quick Start (UIKit)

```swift
import AutoTutorialKit

// In AppDelegate
UserDefaults.standard.removeObject(forKey: "AutoTutorial_HomeViewController") // Remove before release!

AutoTutorialManager.shared.globalOverlayAlpha = 0.7
AutoTutorialManager.shared.globalHighlightStyle = .plain
AutoTutorialManager.shared.start()

AutoTutorialManager.shared.registerTutorial(
    forViewController: "HomeViewController",
    steps: [
        AutoTutorialStep(viewID: 101, title: "Profile", description: "Your profile picture."),
        AutoTutorialStep(viewID: 102, title: "Add New", description: "Create something.", style: .spotlight),
        AutoTutorialStep(viewID: 200, title: "First Item", description: "Tap to open.")
    ],
    themeColor: .systemPurple
)

// Tag your views
profileImage.accessibilityIdentifier = "101"
addButton.accessibilityIdentifier = "102"

// Collection view cells
cell.accessibilityIdentifier = "\(200 + indexPath.item)"
```

Open the screen → tutorial starts automatically

---

## SwiftUI Usage

### Tag your views

```swift
struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .accessibilityIdentifier("101")
            
            Button("Add") { }
                .accessibilityIdentifier("102")
            
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Text(item).accessibilityIdentifier("\(200 + index)")
            }
        }
    }
}
```

### Configure in App Init

```swift
import SwiftUI
import AutoTutorialKit

@main
struct MyApp: App {
    init() {
        UserDefaults.standard.removeObject(forKey: "AutoTutorial_UIHostingController<HomeView>")
        
        AutoTutorialManager.shared.globalOverlayAlpha = 0.7
        AutoTutorialManager.shared.globalHighlightStyle = .plain
        AutoTutorialManager.shared.start()
        
        AutoTutorialManager.shared.registerTutorial(
            forViewController: "UIHostingController<HomeView>",
            steps: [
                AutoTutorialStep(viewID: 101, title: "Profile", description: "Your profile."),
                AutoTutorialStep(viewID: 102, title: "Add", description: "Create new.", style: .spotlight),
                AutoTutorialStep(viewID: 200, title: "First Item", description: "Tap to open.")
            ],
            themeColor: .systemPurple
        )
    }
    var body: some Scene {
        WindowGroup { HomeView() }
    }
}



```


## Testing

* Assign unique IDs to views
* Match IDs with steps
* Ensure UI is visible on load

## Contributing
Contributions are welcome.
If you find any issues or have suggestions for improvement, please submit an issue or create a pull request.


## License

Open source for learning and development purposes.

---

## Support

For questions or issues, please open an issue or contact the maintainer.
 [email protected]
 
---

## Acknowledgements
Thanks to the Apple Developer Community for their frameworks and documentation,
which greatly facilitated the development of this project.

---



https://github.com/user-attachments/assets/9d8bb452-b59c-41d8-a4c8-9b15854964e1

