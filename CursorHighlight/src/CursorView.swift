//
//  CursorView.swift
//  CursorHighlight
//
//  Copyright © 2017 Petteri Huusko <phuusko@gmail.com>. All rights reserved.
//

import Foundation
import Cocoa

class CursorView : NSView
{
    var lineWidth : CGFloat = 3.0
    {
        didSet
        {
            updatePath()
        }
    }
    var color : NSColor = NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    {
        didSet
        {
            self.needsDisplay = true
        }
    }

    fileprivate let fadeDuration = 0.2
    fileprivate var path : NSBezierPath!

    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
        self.wantsLayer = true
        updatePath()
    }

    override func draw(_ dirtyRect: NSRect)
    {
        color.setStroke()
        path.stroke()
    }

    func updatePath()
    {
        let rect = NSInsetRect(bounds, 0.5 * lineWidth, 0.5 * lineWidth)
        path = NSBezierPath(ovalIn: rect)
        self.needsDisplay = true
    }

    func updatePosition(mousePoint : NSPoint)
    {
        var pt = mousePoint
        let size = self.frame.size
        pt.x -= 0.5 * size.width
        pt.y -= 0.5 * size.height
        self.frame = NSRect(origin: pt, size: size)
    }

    @objc
    func hide()
    {
        NSAnimationContext.runAnimationGroup({context in
            context.duration = fadeDuration
            self.animator().alphaValue = 0.0
        }, completionHandler: {
            self.isHidden = true
        })
    }

    func show()
    {
        self.isHidden = false
        NSAnimationContext.runAnimationGroup({context in
            context.duration = fadeDuration
            self.animator().alphaValue = 1.0
        }, completionHandler:{
            self.alphaValue = 1.0
        })
    }

    required init?(coder decoder: NSCoder) { fatalError() }
}
