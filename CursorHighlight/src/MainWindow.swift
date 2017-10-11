//
//  MainWindow.swift
//  CursorHighlight
//
//  Copyright © 2017 Petteri Huusko <phuusko@gmail.com>. All rights reserved.
//

import Foundation
import Cocoa
import Carbon

class MainWindow : NSWindow
{
    var hideAfter : CFTimeInterval = 0.5
    var cursorEnabled = true

    fileprivate let label = NSTextField(labelWithString: "")

    fileprivate let cursor = CursorView(frame: NSRect(x: 0, y: 0, width: 40, height: 40))

    init()
    {
        super.init(contentRect: NSScreen.main!.frame, styleMask: .borderless, backing: .buffered, defer: false)

        backgroundColor = NSColor.clear
        isOpaque = false
        hasShadow = false
        level = .floating
        ignoresMouseEvents = true

        label.isHidden = true
        label.wantsLayer = true
        label.alignment = .center
        label.font = NSFont.systemFont(ofSize: 40)
        label.layer!.backgroundColor = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.8).cgColor
        label.layer!.isOpaque = false

        label.textColor = NSColor.white
        contentView!.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        contentView!.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: contentView!, attribute: .centerX, multiplier: 1.0, constant: 1.0))
        contentView!.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: contentView!, attribute: .centerY, multiplier: 0.6, constant: 1.0))

        cursor.isHidden = true
        contentView!.addSubview(cursor)
        contentView!.wantsLayer = true

        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved, handler: { [weak self] event in
            self?.mouseMoved(with: event)
        })

        let hideImmediatelyEvents : NSEvent.EventTypeMask =
        [
            .leftMouseDragged,
            .rightMouseDragged,
            .otherMouseDragged,
            .leftMouseUp,
            .leftMouseDown,
            .rightMouseUp,
            .rightMouseDown,
            .otherMouseUp
        ]
        NSEvent.addGlobalMonitorForEvents(matching: hideImmediatelyEvents, handler: { [weak self] event in
            self?.cursor.hide()
        })
    }

    override func mouseMoved(with event: NSEvent)
    {
        guard cursorEnabled else
        {
            return
        }
        cursor.updatePosition(mousePoint: event.locationInWindow)
        cursor.show()
        NSObject.cancelPreviousPerformRequests(withTarget: cursor, selector: #selector(CursorView.hide), object: nil)
        cursor.perform(#selector(CursorView.hide), with: nil, afterDelay: hideAfter)
    }

    @objc
    func toggleCursorEnabled()
    {
        cursorEnabled = !cursorEnabled
        showLabel(cursorEnabled ? "Cursor Highlight Enabled" : "Cursor Highlight Disabled")
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideLabel), object: nil)
        self.perform(#selector(hideLabel), with: nil, afterDelay: 2.0)
    }

    @objc
    func showLabel(_ string : String)
    {
        label.isHidden = false
        label.stringValue = string
    }

    @objc
    func hideLabel()
    {
        self.label.isHidden = true
    }
}
