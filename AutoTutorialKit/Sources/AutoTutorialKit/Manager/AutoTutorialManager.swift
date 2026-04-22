//
//  AutoTutorialManager.swift
//  AutoTutorialKit
//
//  Created by iPHTech 28 on 22/04/26.
//


import UIKit

// MARK: - Manager
@MainActor
public class AutoTutorialManager {
    public static let shared = AutoTutorialManager()
    internal var tutorials: [String: [AutoTutorialStep]] = [:]
    internal var themes: [String: UIColor] = [:]
    private var hasSwizzled = false
    public var globalOverlayAlpha: CGFloat = 0.4
    public var globalHighlightStyle: TutorialHighlightStyle = .plain
    public var showGlow: Bool = false
    
    private init() {}
    
    public func start() {
        guard !hasSwizzled else { return }
        hasSwizzled = true
        swizzleViewDidAppear()
    }
    
    public func registerTutorial(forViewController vcName: String,
                                  steps: [AutoTutorialStep],
                                  themeColor: UIColor? = nil) {
        tutorials[vcName] = steps
        if let color = themeColor { themes[vcName] = color }
    }
    
    internal func checkAndShowTutorial(for viewController: UIViewController) {
        let vcName = String(describing: type(of: viewController))
        guard let steps = tutorials[vcName], !steps.isEmpty else { return }
        
        let defaultsKey = "AutoTutorial_\(vcName)"
        // if UserDefaults.standard.bool(forKey: defaultsKey) { return }
        
        guard let window = viewController.view.window else { return }
        
        let fallbackColor = viewController.view.tintColor ?? window.tintColor ?? UIColor.systemBlue
        let appThemeColor = themes[vcName] ?? fallbackColor
        
        let overlay = TutorialOverlayView(
            frame: window.bounds,
            steps: steps,
            targetVC: viewController,
            themeColor: appThemeColor,
            overlayAlpha: globalOverlayAlpha,
            defaultStyle: globalHighlightStyle,
            showGlow: showGlow
        )
        window.addSubview(overlay)
        
        UserDefaults.standard.set(true, forKey: defaultsKey)
    }
    
    private func swizzleViewDidAppear() {
        let originalSelector = #selector(UIViewController.viewDidAppear(_:))
        let swizzledSelector = #selector(UIViewController.autoTut_viewDidAppear(_:))
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
extension UIViewController {
    @MainActor
    @objc internal func autoTut_viewDidAppear(_ animated: Bool) {
        self.autoTut_viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AutoTutorialManager.shared.checkAndShowTutorial(for: self)
        }
    }
}
