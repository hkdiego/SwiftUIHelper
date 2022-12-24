//
//  CustomTabView.swift
//  
//
//  Created by Aleksandr Nesterov on 02.12.2020.
//

import Foundation
import SwiftUI

public struct CustomTabView: View {
    private let viewControllers: [UIHostingController<AnyView>]
    private let selectedIndex: Binding<Int>?
    private let selectedColor: UIColor
    private let defaultColor: UIColor
    private var shouldSelect: (_ index: Int) -> Bool
    @State private var fallbackSelectedIndex: Int = 0
    
    public init(
        selectedIndex: Binding<Int>? = nil,
        selectedColor: UIColor,
        defaultColor: UIColor,
        @TabBuilder _ views: () -> [Tab],
        shouldSelect: @escaping (_ index: Int) -> Bool = { _ in return true }) {
            self.selectedColor = selectedColor
            self.defaultColor = defaultColor
        self.viewControllers = views().map {
            let host = UIHostingController(rootView: $0.view)
            host.tabBarItem = $0.barItem
            return host
        }
        self.selectedIndex = selectedIndex
        self.shouldSelect = shouldSelect
    }
    
    public var body: some View {
        TabBarController(
            controllers: viewControllers,
            selectedColor: selectedColor,
            defaultColor: defaultColor,
            shouldSelect: shouldSelect,
            selectedIndex: selectedIndex ?? $fallbackSelectedIndex)
    }
    
    public struct Tab {
        let view: AnyView
        let barItem: UITabBarItem
    }
}


//MARK: - UIKit Representable
fileprivate struct TabBarController: UIViewControllerRepresentable {
    let controllers: [UIViewController]
    let selectedColor: UIColor
    let defaultColor: UIColor
    let shouldSelect: (_ index: Int) -> Bool
    @Binding var selectedIndex: Int

    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = controllers
        tabBarController.delegate = context.coordinator
        tabBarController.selectedIndex = 0
        if #available(iOS 15.0, *) {
            updateTabBarAppearance(tabBarController)
        }
        return tabBarController
    }
    
    @available(iOS 15.0, *)
    private func updateTabBarAppearance(_ controller: UITabBarController) {
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        let barTintColor: UIColor = .white
        tabBarAppearance.backgroundColor = barTintColor
        
        updateTabBarItemAppearance(appearance: tabBarAppearance.compactInlineLayoutAppearance)
        updateTabBarItemAppearance(appearance: tabBarAppearance.inlineLayoutAppearance)
        updateTabBarItemAppearance(appearance: tabBarAppearance.stackedLayoutAppearance)
        
        controller.tabBar.standardAppearance = tabBarAppearance
        controller.tabBar.scrollEdgeAppearance = tabBarAppearance
    }

    @available(iOS 13.0, *)
    private func updateTabBarItemAppearance(appearance: UITabBarItemAppearance) {
        let tintColor: UIColor = selectedColor
        let unselectedItemTintColor: UIColor = defaultColor
        
        appearance.selected.iconColor = tintColor
        appearance.normal.iconColor = unselectedItemTintColor
    }

    func updateUIViewController(_ tabBarController: UITabBarController, context: Context) {
        tabBarController.selectedIndex = selectedIndex
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITabBarControllerDelegate {
        var parent: TabBarController
        
        init(_ tabBarController: TabBarController) {
            self.parent = tabBarController
        }
        
        func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            guard let index = parent.controllers.firstIndex(of: viewController) else { return true }
            let shouldSelect = parent.shouldSelect(index)
            return shouldSelect
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            if parent.selectedIndex == tabBarController.selectedIndex {
                popToRootOrScrollUp(on: viewController)
            }
            parent.selectedIndex = tabBarController.selectedIndex
        }
        
        private func popToRootOrScrollUp(on viewController: UIViewController) {
            let nvc = navigationController(for: viewController)
            let popped = nvc?.popToRootViewController(animated: true)
            
            if (popped ?? []).isEmpty {
                let rootViewController = nvc?.viewControllers.first ?? viewController
                if let scrollView = firstScrollView(in: rootViewController.view ?? UIView()) {
                    let preservedX = scrollView.contentOffset.x
                    let y = -scrollView.adjustedContentInset.top
                    scrollView.setContentOffset(CGPoint(x: preservedX, y: y), animated: true)
                }
            }
        }
        
        private func navigationController(for viewController: UIViewController) -> UINavigationController? {
            for child in viewController.children {
                if let nvc = viewController as? UINavigationController {
                    return nvc
                } else if let nvc = navigationController(for: child) {
                    return nvc
                }
            }
            return nil
        }
        
        public func firstScrollView(in view: UIView) -> UIScrollView? {
            for subview in view.subviews {
                if let scrollView = view as? UIScrollView {
                    return scrollView
                } else if let scrollView = firstScrollView(in: subview) {
                    return scrollView
                }
            }
            return nil
        }
    }
}


//MARK: - Utilities
@_functionBuilder
public struct TabBuilder {
    public static func buildBlock(_ items: CustomTabView.Tab...) -> [CustomTabView.Tab] {
        items
    }
}

extension View {
    public func tab(title: String,
                    image: String? = nil,
                    selectedImage: String? = nil,
                    badgeValue: String? = nil) -> CustomTabView.Tab {
        
        func imageOrSystemImage(named: String?) -> UIImage? {
            guard let name = named else { return nil }
            return UIImage(named: name) ?? UIImage(systemName: name)
        }
        
        let image = imageOrSystemImage(named: image)
        let selectedImage = imageOrSystemImage(named: selectedImage)
        let barItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        
        barItem.badgeValue = badgeValue
        return CustomTabView.Tab(view: AnyView(self), barItem: barItem)
    }
    
    public func tab(title: String? = nil,
                    image: UIImage? = nil,
                    selectedImage: UIImage? = nil,
                    badgeValue: String? = nil) -> CustomTabView.Tab {
        
        let barItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        barItem.badgeValue = badgeValue
        return CustomTabView.Tab(view: AnyView(self), barItem: barItem)
    }
}
