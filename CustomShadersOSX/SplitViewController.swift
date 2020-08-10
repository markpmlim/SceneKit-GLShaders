//
//  SplitViewController.swift
//  CustomShaders
//
//  Created by Mark Lim on 6/11/16.
//  Copyright © 2016 Incremental Innovation. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {
	var displayController: GameViewController {
		let splitViewItem = splitViewItems[0] as NSSplitViewItem
		return splitViewItem.viewController as! GameViewController
	}

	var settingsController: SettingsViewController {
		let splitViewItem = splitViewItems[1] as NSSplitViewItem
		return splitViewItem.viewController as! SettingsViewController
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// Checked: both controllers have been instantiated.
	// This does not seem to be called!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	// this property can be set by an instance of NSWindowController
	override var representedObject: Any? {
		didSet {
			for viewController in self.childViewControllers as [NSViewController] {
				viewController.representedObject = representedObject
				//Swift.print("representedObject:", representedObject)
			}
		}
	}
}
