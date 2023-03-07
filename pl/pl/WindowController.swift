//
//  WindowController.swift
//  pl
//
//  Created by Hiroshi Tadokoro on 2023/03/07.
//

import Cocoa

class WindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.makeKeyAndOrderFront(nil)
        window?.center()
    }
}
