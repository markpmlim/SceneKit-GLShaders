//
//  SettingsViewController.swift
//  CustomShaders
//
//  Created by Mark Lim on 6/11/16.
//  Copyright © 2016 Incremental Innovation. All rights reserved.
//

import Cocoa
import SceneKit

// The controls in the lower split view item are managed by an
// instance of this class
class SettingsViewController: NSViewController {
	@IBOutlet var modelSetting: NSPopUpButton!
	@IBOutlet var geometrySetting: NSPopUpButton!
	@IBOutlet var surfaceSetting: NSPopUpButton!
	@IBOutlet var lightingSetting: NSPopUpButton!
	@IBOutlet var fragmentSetting: NSPopUpButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
    override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	@IBAction func modelSelected(_ sender: AnyObject)
	{
		let svc = self.parent as! SplitViewController
		let tag = self.modelSetting.selectedTag()
		for i in 0 ..< svc.displayController.settings.modelSettings.items.count
		{
			var item = svc.displayController.settings.modelSettings.items[i]
			item.selected = (tag == i)
		}
		svc.displayController.updateModel()
	}

	@IBAction func geometrySelected(_ sender: AnyObject)
	{
		let svc = self.parent as! SplitViewController
		let tag = self.geometrySetting.selectedTag()
		for i in 0 ..< svc.displayController.settings.geometrySettings.items.count
		{
			var item = svc.displayController.settings.geometrySettings.items[i] 
			item.selected = (tag == i)
		}
		svc.displayController.updateShaders()
	}

	@IBAction func surfaceSelected(_ sender: AnyObject)
	{
		let svc = self.parent as! SplitViewController
		let tag = self.surfaceSetting.selectedTag()
		for i in 0 ..< svc.displayController.settings.surfaceSettings.items.count
		{
			var item = svc.displayController.settings.surfaceSettings.items[i]
			item.selected = (tag == i)
		}
		svc.displayController.updateShaders()
	}

	@IBAction func lightingSelected(_ sender: AnyObject)
	{
		let svc = self.parent as! SplitViewController
		let tag = self.lightingSetting.selectedTag()
		for i in 0 ..< svc.displayController.settings.lightingSettings.items.count
		{
			var item = svc.displayController.settings.lightingSettings.items[i]
			item.selected = (tag == i)
		}
		svc.displayController.updateShaders()
	}

	@IBAction func fragmentSelected(_ sender: AnyObject)
	{
		let svc = self.parent as! SplitViewController
		let tag = self.fragmentSetting.selectedTag()
		for i in 0 ..< svc.displayController.settings.fragmentSettings.items.count 
		{
			var item = svc.displayController.settings.fragmentSettings.items[i]
			item.selected = (tag == i)
		}
		svc.displayController.updateShaders()
	}

	// MARK: - Class methods to build sample nodes
	
	// Simple, cyan sphere
	fileprivate class func sphereNode() -> SCNNode {
		let sphere = SCNSphere(radius: 3.0)
		sphere.firstMaterial!.diffuse.contents = NSColor.cyan
		sphere.firstMaterial!.ambient.contents = NSColor.white
		return SCNNode(geometry: sphere)
	}
	
	// Green, rounded cube
	fileprivate class func cubeNode() -> SCNNode {
		let cube = SCNBox(width: 5.0, height: 5.0, length: 5.0, chamferRadius: 1.5)
		cube.firstMaterial!.diffuse.contents = NSColor.green
		cube.firstMaterial!.ambient.contents = NSColor.white
		return SCNNode(geometry: cube)
	}
	
	// Text!
	fileprivate class func textNode(_ text: String) -> SCNNode {
		
		let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
		textGeometry.font = NSFont(name: "Avenir", size: 2.0)
		textGeometry.containerFrame = CGRect(origin: CGPoint(x: -5.0, y: -15.0),
											 size: CGSize(width: 10.0, height: 20.0))
		//		textGeometry.flatness = 0.2 // Smooth it more
		//		textGeometry.chamferRadius = 0.25
		textGeometry.firstMaterial!.diffuse.contents =  NSColor(hue: 0.9,
																saturation: 0.8,
																brightness: 1.0,
																alpha: 1.0)
		textGeometry.firstMaterial!.ambient.contents = NSColor.white
		return SCNNode(geometry: textGeometry)
	}
	
	// Torus
	fileprivate class func torusNode() -> SCNNode {
		let torus = SCNTorus(ringRadius: 4.0, pipeRadius: 1.5)
		torus.firstMaterial!.diffuse.contents = NSColor(hue: 0.4,
														saturation: 0.8,
														brightness: 1.0,
														alpha: 1.0)
		torus.firstMaterial!.ambient.contents = NSColor.white
		return SCNNode(geometry: torus)
	}
	
	// Planets
	fileprivate class func planets() -> SCNNode {
		let sun = SCNSphere(radius: 2.0)
		sun.firstMaterial!.diffuse.contents =   NSColor(hue: 0.7,
														saturation: 0.8,
														brightness: 1.0,
														alpha: 1.0)
		sun.firstMaterial!.ambient.contents = NSColor.white
		
		let moon = SCNSphere(radius: 1.0)
		moon.firstMaterial!.diffuse.contents =  NSColor(hue: 0.5,
														saturation: 0.5,
														brightness: 0.9,
														alpha: 1.0)
		moon.firstMaterial!.ambient.contents = NSColor.white
		
		let miniMoon = SCNSphere(radius: 0.5)
		moon.firstMaterial!.diffuse.contents =  NSColor(hue: 0.3,
														saturation: 0.5,
														brightness: 0.9,
														alpha: 1.0)
		moon.firstMaterial!.ambient.contents = NSColor.white
		
		
		let sunNode = SCNNode(geometry: sun)
		let dummySunNode = SCNNode() // used for different rotation speed
		
		let moonNode = SCNNode(geometry: moon)
		let moonNode2 = SCNNode(geometry: moon)
		
		let miniMoonNode = SCNNode(geometry: miniMoon)
		let miniMoonNode2 = SCNNode(geometry: miniMoon)
		let miniMoonNode3 = SCNNode(geometry: miniMoon)
		
		moonNode.position = SCNVector3Make(6, 0, -3)
		moonNode2.position = SCNVector3Make(-7, 0, 7)
		
		miniMoonNode.position = SCNVector3Make(2, 0, 0)
		miniMoonNode2.position = SCNVector3Make(-3, 0, 1)
		miniMoonNode3.position = SCNVector3Make(1, 0, -2)
		
		moonNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 4, z: 0, duration: 1)))
		moonNode2.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)))
		
		miniMoonNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 3, z: 0, duration: 1)))
		miniMoonNode2.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
		miniMoonNode3.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)))
		
		sunNode.addChildNode(moonNode)
		dummySunNode.addChildNode(moonNode2)
		moonNode.addChildNode(miniMoonNode)
		moonNode2.addChildNode(miniMoonNode2)
		moonNode2.addChildNode(miniMoonNode3)
		
		sunNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
		dummySunNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 3, z: 0, duration: 1)))
		
		let rootNode = SCNNode()
		rootNode.addChildNode(sunNode)
		rootNode.addChildNode(dummySunNode)
		return rootNode
	}
	
}
