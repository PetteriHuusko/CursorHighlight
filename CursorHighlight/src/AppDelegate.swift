//
//  AppDelegate.swift
//  CursorHighlight
//
//  Copyright © 2017 Petteri Huusko <phuusko@gmail.com>. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate
{
    var window = MainWindow()

    override init()
    {
        super.init()

        let mainMenu = NSMenu()
        let appItem = NSMenuItem(title: "CursorHighlight", action: nil, keyEquivalent: "")
        let appMenu = NSMenu()
        mainMenu.addItem(appItem)
        appItem.submenu = appMenu

        let toggleItem = NSMenuItem(title: "Toggle", action: #selector(MainWindow.toggleCursorEnabled), keyEquivalent: "e")
        toggleItem.target = window
        appMenu.addItem(toggleItem)

        let quitItem = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        quitItem.target = NSApplication.shared
        appMenu.addItem(quitItem)

        NSApp.mainMenu = mainMenu
    }

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        window.makeKeyAndOrderFront(NSApp)
    }
}
