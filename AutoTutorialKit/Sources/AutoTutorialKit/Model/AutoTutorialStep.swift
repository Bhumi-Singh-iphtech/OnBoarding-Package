//
//  AutoTutorialStep.swift
//  AutoTutorialKit
//
//  Created by iPHTech 28 on 22/04/26.
//


import UIKit

// MARK: - Step Configuration
public struct AutoTutorialStep {
    public let accessibilityID: String?
    public let propertyName: String?
    public let uiText: String?
    public let tabBarItemIndex: Int?
    public let highlightAllImages: Bool
    public let imageIndex: Int?
    public let collectionViewName: String?
    public let cellIndex: Int?
    public let title: String
    public let description: String
    public let shrinkBoxHeight: CGFloat
    public let image: UIImage?
    public let highlightStyle: TutorialHighlightStyle?
    
    // MARK: - Init with Number ID
    public init(viewID: Int,
                title: String,
                description: String,
                image: UIImage? = nil,
                shrinkBoxHeight: CGFloat = 0,
                style: TutorialHighlightStyle? = nil) {
        self.accessibilityID = "\(viewID)"
        self.propertyName = nil
        self.uiText = nil
        self.tabBarItemIndex = nil
        self.highlightAllImages = false
        self.imageIndex = nil
        self.collectionViewName = nil
        self.cellIndex = nil
        self.title = title
        self.description = description
        self.shrinkBoxHeight = shrinkBoxHeight
        self.image = image
        self.highlightStyle = style
    }
    
    // MARK: - Init with accessibilityID
    public init(accessibilityID: String,
                title: String,
                description: String,
                image: UIImage? = nil,
                shrinkBoxHeight: CGFloat = 0,
                style: TutorialHighlightStyle? = nil) {
        self.accessibilityID = accessibilityID
        self.propertyName = nil
        self.uiText = nil
        self.tabBarItemIndex = nil
        self.highlightAllImages = false
        self.imageIndex = nil
        self.collectionViewName = nil
        self.cellIndex = nil
        self.title = title
        self.description = description
        self.shrinkBoxHeight = shrinkBoxHeight
        self.image = image
        self.highlightStyle = style
    }
    
    // MARK: - Init with propertyName
    public init(propertyName: String,
                title: String,
                description: String,
                image: UIImage? = nil,
                shrinkBoxHeight: CGFloat = 0,
                style: TutorialHighlightStyle? = nil) {
        self.accessibilityID = nil
        self.propertyName = propertyName
        self.uiText = nil
        self.tabBarItemIndex = nil
        self.highlightAllImages = false
        self.imageIndex = nil
        self.collectionViewName = nil
        self.cellIndex = nil
        self.title = title
        self.description = description
        self.shrinkBoxHeight = shrinkBoxHeight
        self.image = image
        self.highlightStyle = style
    }
    
    // MARK: - Init with uiText
    public init(uiText: String,
                title: String,
                description: String,
                image: UIImage? = nil,
                shrinkBoxHeight: CGFloat = 0,
                style: TutorialHighlightStyle? = nil) {
        self.accessibilityID = nil
        self.propertyName = nil
        self.uiText = uiText
        self.tabBarItemIndex = nil
        self.highlightAllImages = false
        self.imageIndex = nil
        self.collectionViewName = nil
        self.cellIndex = nil
        self.title = title
        self.description = description
        self.shrinkBoxHeight = shrinkBoxHeight
        self.image = image
        self.highlightStyle = style
    }
    
    // MARK: - Init with tabBarItemIndex
    public init(tabBarItemIndex: Int,
                title: String,
                description: String,
                image: UIImage? = nil,
                shrinkBoxHeight: CGFloat = 0,
                style: TutorialHighlightStyle? = nil) {
        self.accessibilityID = nil
        self.propertyName = nil
        self.uiText = nil
        self.tabBarItemIndex = tabBarItemIndex
        self.highlightAllImages = false
        self.imageIndex = nil
        self.collectionViewName = nil
        self.cellIndex = nil
        self.title = title
        self.description = description
        self.shrinkBoxHeight = shrinkBoxHeight
        self.image = image
        self.highlightStyle = style
    }
    
    // MARK: - Init with imageIndex
    public init(imageIndex: Int,
                title: String,
                description: String,
                image: UIImage? = nil,
                shrinkBoxHeight: CGFloat = 0,
                style: TutorialHighlightStyle? = nil) {
        self.accessibilityID = nil
        self.propertyName = nil
        self.uiText = nil
        self.tabBarItemIndex = nil
        self.highlightAllImages = false
        self.imageIndex = imageIndex
        self.collectionViewName = nil
        self.cellIndex = nil
        self.title = title
        self.description = description
        self.shrinkBoxHeight = shrinkBoxHeight
        self.image = image
        self.highlightStyle = style
    }
    
    // MARK: - Init with collectionView cell
    public init(collectionViewName: String,
                cellIndex: Int,
                title: String,
                description: String,
                image: UIImage? = nil,
                shrinkBoxHeight: CGFloat = 0,
                style: TutorialHighlightStyle? = nil) {
        self.accessibilityID = nil
        self.propertyName = nil
        self.uiText = nil
        self.tabBarItemIndex = nil
        self.highlightAllImages = false
        self.imageIndex = nil
        self.collectionViewName = collectionViewName
        self.cellIndex = cellIndex
        self.title = title
        self.description = description
        self.shrinkBoxHeight = shrinkBoxHeight
        self.image = image
        self.highlightStyle = style
    }
}