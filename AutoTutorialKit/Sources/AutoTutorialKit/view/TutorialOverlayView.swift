//
//  TutorialOverlayView.swift
//  AutoTutorialKit
//
//  Created by iPHTech 28 on 22/04/26.
//


import UIKit

// MARK: - Tutorial Overlay View
@MainActor
class TutorialOverlayView: UIView {
    private var steps: [AutoTutorialStep]
    private weak var targetVC: UIViewController?
    private var currentIndex = 0
    private var themeColor: UIColor
    private var isAnimating = false
    private var modifiedScrollViews: [UIScrollView: UIEdgeInsets] = [:]
    private let overlayAlpha: CGFloat
    private let defaultStyle: TutorialHighlightStyle
    private let showGlow: Bool
    
    private let dimmingView = UIView()
    private let maskLayer = CAShapeLayer()
    private let focusRingLayer = CAShapeLayer()
    private let plainBoxLayer = CAShapeLayer()
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private let bottomSheet = UIView()
    private let skipButton = UIButton(type: .system)
    private let pageControl = UIPageControl()
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let stepImageView = UIImageView()
    private let nextButton = UIButton(type: .system)
    
    // MARK: - Init
    init(frame: CGRect,
         steps: [AutoTutorialStep],
         targetVC: UIViewController,
         themeColor: UIColor,
         overlayAlpha: CGFloat,
         defaultStyle: TutorialHighlightStyle,
         showGlow: Bool) {
        self.steps = steps
        self.targetVC = targetVC
        self.themeColor = themeColor
        self.overlayAlpha = overlayAlpha
        self.defaultStyle = defaultStyle
        self.showGlow = showGlow
        super.init(frame: frame)
        setupUI()
        showStep(index: 0)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.backgroundColor = .clear
        hapticGenerator.prepare()
        
        // Dimming
        dimmingView.frame = self.bounds
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(overlayAlpha)
        addSubview(dimmingView)
        
        maskLayer.fillRule = .evenOdd
        dimmingView.layer.mask = maskLayer
        
        // Spotlight ring
        focusRingLayer.fillColor = UIColor.clear.cgColor
        focusRingLayer.strokeColor = UIColor.white.cgColor
        focusRingLayer.lineWidth = 2.5
        focusRingLayer.shadowOpacity = 0
        focusRingLayer.shadowRadius = 0
        layer.addSublayer(focusRingLayer)
        
        // Plain white box
        plainBoxLayer.fillColor = UIColor.clear.cgColor
        plainBoxLayer.strokeColor = UIColor.white.cgColor
        plainBoxLayer.lineWidth = 2.5
        plainBoxLayer.shadowOpacity = 0
        plainBoxLayer.shadowRadius = 0
        layer.addSublayer(plainBoxLayer)
        
        // Bottom Sheet
        bottomSheet.backgroundColor = .white
        bottomSheet.layer.cornerRadius = 32
        bottomSheet.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheet.layer.shadowColor = UIColor.black.cgColor
        bottomSheet.layer.shadowOpacity = 0.2
        bottomSheet.layer.shadowRadius = 20
        bottomSheet.layer.shadowOffset = CGSize(width: 0, height: -5)
        bottomSheet.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomSheet)
        
        // Skip Button
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.black, for: .normal)
        skipButton.backgroundColor = .clear
        skipButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        bottomSheet.addSubview(skipButton)
        
        // Page Control
        pageControl.numberOfPages = steps.count
        pageControl.currentPageIndicatorTintColor = themeColor
        if #available(iOS 13.0, *) {
            pageControl.pageIndicatorTintColor = UIColor.systemGray5
        }
        pageControl.isUserInteractionEnabled = false
        
        // Title
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        // Description
        descLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descLabel.textColor = .darkGray
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        
        // Optional Image
        stepImageView.contentMode = .scaleAspectFit
        stepImageView.clipsToBounds = true
        stepImageView.layer.cornerRadius = 12
        stepImageView.isHidden = true
        stepImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Next Button
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = themeColor
        nextButton.layer.cornerRadius = 25
        nextButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Stack
        let stack = UIStackView(arrangedSubviews: [pageControl, titleLabel, descLabel, stepImageView, nextButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.setCustomSpacing(24, after: descLabel)
        stack.setCustomSpacing(20, after: stepImageView)
        stack.translatesAutoresizingMaskIntoConstraints = false
        bottomSheet.addSubview(stack)
        
        // Constraints
        NSLayoutConstraint.activate([
            bottomSheet.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSheet.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSheet.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            skipButton.topAnchor.constraint(equalTo: bottomSheet.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor, constant: -20),
            
            stack.topAnchor.constraint(equalTo: bottomSheet.topAnchor, constant: 50),
            stack.leadingAnchor.constraint(equalTo: bottomSheet.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor, constant: -32),
            stack.bottomAnchor.constraint(equalTo: bottomSheet.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            stepImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 140)
        ])
    }
    
    // MARK: - Effective Style
    private func effectiveStyle(for step: AutoTutorialStep) -> TutorialHighlightStyle {
        return step.highlightStyle ?? defaultStyle
    }
    
    // MARK: - Show Step
    private func showStep(index: Int) {
        guard let vc = targetVC else { return }
        isAnimating = true
        let step = steps[index]
        let style = effectiveStyle(for: step)
        hapticGenerator.impactOccurred()
        
        pageControl.currentPage = index
        
        UIView.transition(with: titleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.titleLabel.text = step.title
            self.descLabel.text = step.description
            
            if let img = step.image {
                self.stepImageView.image = img
                self.stepImageView.isHidden = false
            } else {
                self.stepImageView.isHidden = true
                self.stepImageView.image = nil
            }
        })
        
        nextButton.setTitle(index == steps.count - 1 ? "Get Started" : "Next", for: .normal)
        
        // Style: .none
        if style == .none {
            let fullPath = UIBezierPath(rect: self.bounds)
            let maskAnim = CABasicAnimation(keyPath: "path")
            maskAnim.fromValue = self.maskLayer.path
            maskAnim.toValue = fullPath.cgPath
            maskAnim.duration = 0.35
            maskAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.maskLayer.add(maskAnim, forKey: "pathAnimation")
            self.maskLayer.path = fullPath.cgPath
            self.focusRingLayer.path = nil
            self.plainBoxLayer.path = nil
            self.isAnimating = false
            return
        }
        
        // Smart scroll
        var scrollDelay: TimeInterval = 0.0
        
        if let accID = step.accessibilityID {
            scrollDelay = scrollCollectionViewToCellIfNeeded(withAccessibilityID: accID, in: vc)
        }
        
        if let cvName = step.collectionViewName, let cellIdx = step.cellIndex {
            let legacyDelay = scrollCollectionView(named: cvName, toCell: cellIdx, in: vc)
            if legacyDelay > scrollDelay { scrollDelay = legacyDelay }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + scrollDelay) {
            let highlights = self.resolveHighlights(for: step)
            self.animateHighlights(highlights, style: style)
        }
    }
    
    // MARK: - Animate Highlights
    private func animateHighlights(_ highlights: [TargetHighlight], style: TutorialHighlightStyle) {
        
        if highlights.isEmpty {
            self.maskLayer.path = UIBezierPath(rect: self.bounds).cgPath
            self.focusRingLayer.path = nil
            self.plainBoxLayer.path = nil
            self.isAnimating = false
            return
        }
        
        let fullMaskPath = UIBezierPath(rect: self.bounds)
        let highlightPath = UIBezierPath()
        
        for highlight in highlights {
            var insetFrame = highlight.frame.insetBy(dx: -8, dy: -8)
            if highlight.shrinkHeight > 0 {
                insetFrame = insetFrame.insetBy(dx: 0, dy: highlight.shrinkHeight / 2)
            }
            let path = highlight.isCircle
                ? UIBezierPath(ovalIn: insetFrame)
                : UIBezierPath(roundedRect: insetFrame, cornerRadius: 14)
            highlightPath.append(path)
        }
        
        // Both plain and spotlight cut a hole
        fullMaskPath.append(highlightPath)
        
        switch style {
        case .spotlight:
            self.plainBoxLayer.path = nil
            
            let maskAnim = CABasicAnimation(keyPath: "path")
            maskAnim.fromValue = self.maskLayer.path
            maskAnim.toValue = fullMaskPath.cgPath
            maskAnim.duration = 0.35
            maskAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.maskLayer.add(maskAnim, forKey: "pathAnimation")
            self.maskLayer.path = fullMaskPath.cgPath
            
            focusRingLayer.strokeColor = UIColor.white.cgColor
            focusRingLayer.lineWidth = 2.5
            if showGlow {
                focusRingLayer.shadowColor = UIColor.white.cgColor
                focusRingLayer.shadowRadius = 8.0
                focusRingLayer.shadowOpacity = 0.8
            } else {
                focusRingLayer.shadowOpacity = 0
                focusRingLayer.shadowRadius = 0
            }
            
            let ringAnim = CABasicAnimation(keyPath: "path")
            ringAnim.fromValue = self.focusRingLayer.path
            ringAnim.toValue = highlightPath.cgPath
            ringAnim.duration = 0.35
            ringAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.focusRingLayer.add(ringAnim, forKey: "ringPathAnimation")
            self.focusRingLayer.path = highlightPath.cgPath
            
        case .plain:
            self.focusRingLayer.path = nil
            
            let maskAnim = CABasicAnimation(keyPath: "path")
            maskAnim.fromValue = self.maskLayer.path
            maskAnim.toValue = fullMaskPath.cgPath
            maskAnim.duration = 0.35
            maskAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.maskLayer.add(maskAnim, forKey: "pathAnimation")
            self.maskLayer.path = fullMaskPath.cgPath
            
            plainBoxLayer.strokeColor = UIColor.white.cgColor
            plainBoxLayer.lineWidth = 2.5
            plainBoxLayer.fillColor = UIColor.clear.cgColor
            if showGlow {
                plainBoxLayer.shadowColor = UIColor.white.cgColor
                plainBoxLayer.shadowRadius = 6.0
                plainBoxLayer.shadowOpacity = 0.6
            } else {
                plainBoxLayer.shadowOpacity = 0
                plainBoxLayer.shadowRadius = 0
            }
            
            let boxAnim = CABasicAnimation(keyPath: "path")
            boxAnim.fromValue = self.plainBoxLayer.path
            boxAnim.toValue = highlightPath.cgPath
            boxAnim.duration = 0.35
            boxAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.plainBoxLayer.add(boxAnim, forKey: "boxPathAnimation")
            self.plainBoxLayer.path = highlightPath.cgPath
            
        case .none:
            self.focusRingLayer.path = nil
            self.plainBoxLayer.path = nil
        }
        
        self.isAnimating = false
    }
    
    // MARK: - Smart Scroll for viewID Cells
    private func scrollCollectionViewToCellIfNeeded(withAccessibilityID accID: String, in vc: UIViewController) -> TimeInterval {
        
        if let _ = findView(withAccessibilityID: accID, in: vc.view) {
            // Check if truly visible above bottom sheet
            if let view = findView(withAccessibilityID: accID, in: vc.view) {
                let frameInWindow = view.convert(view.bounds, to: self)
                let sheetTop = self.bottomSheet.frame.origin.y
                let safeBottom = sheetTop - 20
                if frameInWindow.maxY < safeBottom && frameInWindow.minY > 0 {
                    return 0.0
                }
            }
        }
        
        guard let targetNumber = Int(accID) else { return 0.0 }
        
        let collectionViews = findAllCollectionViews(in: vc.view)
        
        for cv in collectionViews {
            guard cv.numberOfSections > 0 else { continue }
            let totalItems = cv.numberOfItems(inSection: 0)
            guard totalItems > 0 else { continue }
            
            // Find base number from visible cells
            let visibleCells = cv.visibleCells
            var baseNumber: Int? = nil
            
            for cell in visibleCells {
                if let cellID = cell.accessibilityIdentifier,
                   let cellNum = Int(cellID),
                   let ip = cv.indexPath(for: cell) {
                    baseNumber = cellNum - ip.item
                    break
                }
            }
            
            guard let base = baseNumber else { continue }
            
            // Calculate target index
            let targetIndex = targetNumber - base
            guard targetIndex >= 0 && targetIndex < totalItems else { continue }
            
            let indexPath = IndexPath(item: targetIndex, section: 0)
            let isHorizontal = (cv.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .horizontal
            
            // Adjust bottom inset
            if !isHorizontal {
                let sheetHeight = self.bottomSheet.bounds.height > 0 ? self.bottomSheet.bounds.height : 280
                if cv.contentInset.bottom < sheetHeight {
                    if self.modifiedScrollViews[cv] == nil {
                        self.modifiedScrollViews[cv] = cv.contentInset
                    }
                    cv.contentInset.bottom = sheetHeight + 30
                }
            }
            
            // Check if cell is truly visible above sheet
            if let cell = cv.cellForItem(at: indexPath) {
                let cellFrameInWindow = cell.convert(cell.bounds, to: self)
                let sheetTop = self.bottomSheet.frame.origin.y
                let safeVisibleBottom = sheetTop - 20
                
                if cellFrameInWindow.maxY < safeVisibleBottom && cellFrameInWindow.minY > 0 {
                    return 0.0
                }
            }
            
            // Need to scroll
            let savedOffset = cv.contentOffset
            
            if isHorizontal {
                cv.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                cv.layoutIfNeeded()
            } else {
                if let attrs = cv.collectionViewLayout.layoutAttributesForItem(at: indexPath) {
                    let sheetHeight = self.bottomSheet.bounds.height > 0 ? self.bottomSheet.bounds.height : 280
                    let visibleHeight = cv.bounds.height - sheetHeight
                    var targetY = attrs.frame.midY - (visibleHeight / 2)
                    let maxScrollY = max(0, cv.contentSize.height - cv.bounds.height + cv.contentInset.bottom)
                    targetY = max(0, min(targetY, maxScrollY))
                    cv.setContentOffset(CGPoint(x: cv.contentOffset.x, y: targetY), animated: false)
                    cv.layoutIfNeeded()
                } else {
                    cv.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
                    cv.layoutIfNeeded()
                }
            }
            
            let targetOffset = cv.contentOffset
            cv.setContentOffset(savedOffset, animated: false)
            
            let distance = isHorizontal
                ? abs(savedOffset.x - targetOffset.x)
                : abs(savedOffset.y - targetOffset.y)
            
            if distance > 10 {
                UIView.animate(withDuration: 0.6, delay: 0,
                               options: [.curveEaseInOut],
                               animations: {
                    cv.setContentOffset(targetOffset, animated: false)
                })
                return 0.7
            }
            return 0.0
        }
        
        return 0.0
    }
    
    // MARK: - Legacy Collection View Scroll
    private func scrollCollectionView(named cvName: String, toCell cellIdx: Int, in vc: UIViewController) -> TimeInterval {
        let selector = NSSelectorFromString(cvName)
        guard vc.responds(to: selector),
              let cv = vc.value(forKey: cvName) as? UICollectionView else { return 0.0 }
        guard cv.numberOfSections > 0 && cv.numberOfItems(inSection: 0) > cellIdx else { return 0.0 }
        
        let indexPath = IndexPath(item: cellIdx, section: 0)
        guard let attrs = cv.collectionViewLayout.layoutAttributesForItem(at: indexPath) else { return 0.0 }
        
        let isHorizontal = (cv.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .horizontal
        var targetOffset = cv.contentOffset
        
        if isHorizontal {
            var targetX = attrs.frame.midX - (cv.bounds.width / 2)
            let maxScrollX = max(0, cv.contentSize.width - cv.bounds.width + cv.contentInset.right)
            targetX = max(0, min(targetX, maxScrollX))
            targetOffset.x = targetX
        } else {
            let sheetHeight = self.bottomSheet.bounds.height > 0 ? self.bottomSheet.bounds.height : 280
            if cv.contentInset.bottom < sheetHeight {
                if self.modifiedScrollViews[cv] == nil { self.modifiedScrollViews[cv] = cv.contentInset }
                cv.contentInset.bottom = sheetHeight + 30
            }
            let visibleHeight = cv.bounds.height - sheetHeight
            var targetY = attrs.frame.midY - (visibleHeight / 2)
            let maxScrollY = max(0, cv.contentSize.height - cv.bounds.height + cv.contentInset.bottom)
            targetY = max(0, min(targetY, maxScrollY))
            targetOffset.y = targetY
        }
        
        let distance = isHorizontal
            ? abs(cv.contentOffset.x - targetOffset.x)
            : abs(cv.contentOffset.y - targetOffset.y)
        
        if distance > 10 {
            UIView.animate(withDuration: 0.8, delay: 0,
                           options: [.curveEaseInOut, .allowUserInteraction],
                           animations: { cv.contentOffset = targetOffset })
            return 0.9
        }
        return 0.0
    }
    
    // MARK: - Resolve Highlights
    private func resolveHighlights(for step: AutoTutorialStep) -> [TargetHighlight] {
        guard let vc = targetVC else { return [] }
        var highlights: [TargetHighlight] = []
        
        // PRIORITY 1: accessibilityIdentifier
        if let accID = step.accessibilityID {
            let searchRoots: [UIView?] = [
                vc.view,
                vc.tabBarController?.tabBar,
                vc.navigationController?.navigationBar,
                vc.view.window
            ]
            for root in searchRoots {
                guard let rootView = root else { continue }
                if let view = findView(withAccessibilityID: accID, in: rootView) {
                    let frame = view.convert(view.bounds, to: self)
                    let isCircle = abs(view.bounds.width - view.bounds.height) < 2.0 &&
                                  view.layer.cornerRadius >= (view.bounds.width / 2.0 - 2.0)
                    highlights.append(TargetHighlight(frame: frame, isCircle: isCircle, shrinkHeight: step.shrinkBoxHeight))
                    return highlights
                }
            }
            return highlights
        }
        
        // PRIORITY 2: CollectionView cell
        if let cvName = step.collectionViewName, let cellIdx = step.cellIndex {
            let selector = NSSelectorFromString(cvName)
            if vc.responds(to: selector), let cv = vc.value(forKey: cvName) as? UICollectionView {
                let indexPath = IndexPath(item: cellIdx, section: 0)
                if let cell = cv.cellForItem(at: indexPath) {
                    var tightRect = CGRect.null
                    for subview in cell.contentView.subviews {
                        if subview.isHidden || subview.alpha < 0.05 { continue }
                        tightRect = tightRect.union(subview.frame)
                    }
                    var frameToUse = cell.bounds
                    if !tightRect.isNull && !tightRect.isEmpty && tightRect.height < cell.bounds.height {
                        frameToUse = cell.contentView.convert(tightRect, to: cell)
                    }
                    let rectInOverlay = cell.convert(frameToUse, to: self)
                    highlights.append(TargetHighlight(frame: rectInOverlay, isCircle: false, shrinkHeight: step.shrinkBoxHeight))
                } else if let attrs = cv.collectionViewLayout.layoutAttributesForItem(at: indexPath) {
                    let rectInOverlay = cv.convert(attrs.frame, to: self)
                    highlights.append(TargetHighlight(frame: rectInOverlay, isCircle: false, shrinkHeight: step.shrinkBoxHeight))
                }
            }
        }
        // PRIORITY 3: Legacy
        else {
            var targetViews: [UIView] = []
            
            if let idx = step.imageIndex {
                let images = findAllImageViews(in: vc.view)
                if idx < images.count { targetViews.append(images[idx]) }
            }
            else if let propName = step.propertyName {
                let selector = NSSelectorFromString(propName)
                if vc.responds(to: selector), let targetView = vc.value(forKey: propName) as? UIView {
                    targetViews.append(targetView)
                }
            }
            else if let text = step.uiText {
                if let targetView = findView(withText: text, in: vc.view) {
                    if text.contains("Hello"), let parent = targetView.superview {
                        targetViews.append(parent)
                    } else {
                        targetViews.append(targetView)
                    }
                }
            }
            else if let tabIndex = step.tabBarItemIndex {
                if let tabBar = vc.tabBarController?.tabBar {
                    let tabButtons = tabBar.subviews
                        .filter { String(describing: type(of: $0)).contains("UITabBarButton") }
                        .sorted { $0.frame.minX < $1.frame.minX }
                    if tabIndex < tabButtons.count {
                        targetViews.append(tabButtons[tabIndex])
                    } else {
                        targetViews.append(tabBar)
                    }
                }
            }
            
            for v in targetViews {
                let frame = v.convert(v.bounds, to: self)
                let isCircle = abs(v.bounds.width - v.bounds.height) < 2.0 &&
                              v.layer.cornerRadius >= (v.bounds.width / 2.0 - 2.0)
                highlights.append(TargetHighlight(frame: frame, isCircle: isCircle, shrinkHeight: step.shrinkBoxHeight))
            }
        }
        
        return highlights
    }
    
    // MARK: - Find View by Accessibility Identifier
    private func findView(withAccessibilityID id: String, in view: UIView) -> UIView? {
        if view.accessibilityIdentifier == id { return view }
        for subview in view.subviews {
            if let found = findView(withAccessibilityID: id, in: subview) { return found }
        }
        return nil
    }
    
    // MARK: - Find All Collection Views
    private func findAllCollectionViews(in view: UIView) -> [UICollectionView] {
        var results: [UICollectionView] = []
        if let cv = view as? UICollectionView { results.append(cv) }
        for subview in view.subviews {
            results.append(contentsOf: findAllCollectionViews(in: subview))
        }
        return results
    }
    
    // MARK: - Find All Image Views
    private func findAllImageViews(in view: UIView) -> [UIImageView] {
        var results: [UIImageView] = []
        let className = String(describing: type(of: view))
        if className.contains("Background") { return results }
        if let iv = view as? UIImageView, !iv.isHidden, iv.alpha > 0.1,
           iv.bounds.width > 20, iv.bounds.height > 20 {
            results.append(iv)
        }
        for subview in view.subviews {
            results.append(contentsOf: findAllImageViews(in: subview))
        }
        return results
    }
    
    // MARK: - Find View by Text
    private func findView(withText text: String, in view: UIView) -> UIView? {
        if let label = view as? UILabel, label.text?.contains(text) == true { return label }
        if let button = view as? UIButton,
           (button.titleLabel?.text?.contains(text) == true ||
            button.title(for: .normal)?.contains(text) == true) { return button }
        for subview in view.subviews {
            if let found = findView(withText: text, in: subview) { return found }
        }
        return nil
    }
    
    // MARK: - Actions
    @objc private func nextTapped() {
        guard !isAnimating else { return }
        if currentIndex < steps.count - 1 {
            currentIndex += 1
            showStep(index: currentIndex)
        } else {
            dismiss()
        }
    }
    
    @objc private func skipTapped() {
        dismiss()
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            for (scrollView, originalInset) in self.modifiedScrollViews {
                UIView.animate(withDuration: 0.3) {
                    scrollView.contentInset = originalInset
                }
            }
            self.removeFromSuperview()
        }
    }
}