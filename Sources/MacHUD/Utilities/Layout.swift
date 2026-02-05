//
//  Layout.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit

extension NSView {
    func addFrameConstraints(toParent parentView: NSView) {
        let childView = self
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(
                equalTo: childView.topAnchor
            ),
            parentView.rightAnchor.constraint(
                equalTo: childView.rightAnchor
            ),
            parentView.bottomAnchor.constraint(
                equalTo: childView.bottomAnchor
            ),
            parentView.leftAnchor.constraint(
                equalTo: childView.leftAnchor
            )
        ])
        
        // parentView.addConstraint(.init(
        //     item: childView as Any,
        //     attribute: .centerY,
        //     relatedBy: .equal,
        //     toItem: parentView,
        //     attribute: .centerY,
        //     multiplier: 1,
        //     constant: 0
        // ))
        // parentView.addConstraint(.init(
        //     item: childView as Any,
        //     attribute: .centerX,
        //     relatedBy: .equal,
        //     toItem: parentView,
        //     attribute: .centerX,
        //     multiplier: 1,
        //     constant: 0
        // ))
        // parentView.addConstraint(.init(
        //     item: childView as Any,
        //     attribute: .width,
        //     relatedBy: .equal,
        //     toItem: childView,
        //     attribute: .width,
        //     multiplier: 1,
        //     constant: 0
        // ))
        // parentView.addConstraint(.init(
        //     item: childView as Any,
        //     attribute: .height,
        //     relatedBy: .equal,
        //     toItem: childView,
        //     attribute: .height,
        //     multiplier: 1,
        //     constant: 0
        // ))
    }
}

#endif
