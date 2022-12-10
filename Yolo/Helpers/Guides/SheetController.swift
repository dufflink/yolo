//
//  SheetController.swift
//  Yolo
//
//  Created by Maxim Skorynin on 10.12.2022.
//

import SwiftUI

public extension View {
    
    /// Presents passed content at the bottom of a target view using detents (`detents`) properties from UIKit
    /// as in the iOS 15.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the sheet that you create in the modifier's
    ///     `content` closure.
    ///   - detents: The array of heights where a sheet can rest.
    ///   - content: A closure that returns the content of the sheet.
    func sheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent],
        @ViewBuilder content: @escaping () -> Content,
        onDismiss: (() -> Void)? = nil) -> some View {
            self.background(
                SheetController(isPresented: isPresented, detents: detents, content: content(), onDismiss: onDismiss)
            )
    }
    
}

public struct SheetController<Content: View>: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    
    let detents: [UISheetPresentationController.Detent]
    let content: Content
    
    let onDismiss: (() -> Void)?
    
    // MARK: - Life Cycle
    
    public init(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent],
        content: Content,
        onDismiss: (() -> Void)? = nil
    ) {
        _isPresented = isPresented
        self.detents = detents
        self.content = content
        self.onDismiss = onDismiss
    }
    
    // MARK: - Functions
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            guard uiViewController.presentedViewController == nil else {
                (uiViewController.presentedViewController as? UIHostingController)?.rootView = content
                return
            }
            
            let hostingController = UIHostingController(rootView: content)
            
            if let sheet = hostingController.sheetPresentationController {
                sheet.delegate = context.coordinator
                sheet.detents = detents
                sheet.preferredCornerRadius = 20
                sheet.prefersGrabberVisible = true
            }

            uiViewController.present(hostingController, animated: true)
        } else {
            uiViewController.presentedViewController?.dismiss(animated: true) {
                onDismiss?()
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        .init(parent: self)
    }
    
}

// MARK: - Coordinator

public extension SheetController {
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var controller: SheetController
        
        init(parent: SheetController) {
            self.controller = parent
        }
        
        public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            controller.isPresented = false
            controller.onDismiss?()
        }
    }
    
}
