//
//	Settings.swift
//	CustomShaders
//
//	Created by Nathanael Beisiegel on 11/24/14.
//	Copyright (c) 2014 Nathanael Beisiegel. All rights reserved.
//

import Foundation
import SceneKit
#if os(iOS)
typealias ColorClass = UIColor
typealias FontClass = UIFont
#elseif os(OSX)
typealias ColorClass = NSColor
typealias FontClass = NSFont
#endif

class AllSettings: NSObject {
	
	var modelSettings = Settings(items: [
		ModelSettingItem(modelData: ModelData(name: "Sphere",
											  node: AllSettings.sphereNode()),
                         selected: true),
		ModelSettingItem(modelData: ModelData(name: "Cube", node: AllSettings.cubeNode())),
		ModelSettingItem(modelData: ModelData(name: "Torus", node: AllSettings.torusNode())),
		ModelSettingItem(modelData: ModelData(name: "Text", node: AllSettings.textNode("Graphics\nHearts\nYou"))),
		ModelSettingItem(modelData: ModelData(name: "Planets", node: AllSettings.planets())),
		ModelSettingItem(modelData: ModelData(filename: "ship", nodeName: "shipMesh")),
		ModelSettingItem(modelData: ModelData(filename: "suzanne_materials", nodeName: "Suzanne")),
		ModelSettingItem(modelData: ModelData(filename: "suzanne_painted", nodeName: "Suzanne"))
		])

    // "sm_geom" is not translated successfully by Metal
	var geometrySettings = Settings(items: [
		NoneSettingItem(),
		ShaderSettingItem(shaderData: ShaderData(filename: "geometry_ripple")),
		ShaderSettingItem(shaderData: ShaderData(filename: "sm_geom")),
		ShaderSettingItem(shaderData: ShaderData(filename: "twisted")),
		ShaderSettingItem(shaderData: ShaderData(filename: "bubble"))
	])

	var surfaceSettings = Settings(items: [
		NoneSettingItem(),
		ShaderSettingItem(shaderData: ShaderData(filename: "sm_surf")),
		ShaderSettingItem(shaderData: ShaderData(filename: "nb_surf"))
	])

	var lightingSettings = Settings(items: [
		NoneSettingItem(),
		ShaderSettingItem(shaderData: ShaderData(filename: "fixed_toon")),
		ShaderSettingItem(shaderData: ShaderData(filename: "light_source_toon")),
		ShaderSettingItem(shaderData: ShaderData(filename: "sm_light"))
	])
	
	var fragmentSettings = Settings(items: [
		NoneSettingItem(),
		ShaderSettingItem(shaderData: ShaderData(filename: "sm_frag")),
		ShaderSettingItem(shaderData: ShaderData(filename: "mask")),
		ShaderSettingItem(shaderData: ShaderData(filename: "red_dot_product")),
		ShaderSettingItem(shaderData: ShaderData(filename: "alpha_dot_product")),
		ShaderSettingItem(shaderData: ShaderData(filename: "outline"))
	])
	
	// MARK: - Class methods to build sample nodes
	
	// Simple, cyan sphere
	fileprivate class func sphereNode() -> SCNNode {
		let sphere = SCNSphere(radius: 3.0)
		sphere.firstMaterial!.diffuse.contents = ColorClass.cyan
		sphere.firstMaterial!.ambient.contents = ColorClass.white
		return SCNNode(geometry: sphere)
	}
	
	// Green, rounded cube
	fileprivate class func cubeNode() -> SCNNode {
		let cube = SCNBox(width: 5.0, height: 5.0, length: 5.0, chamferRadius: 1.5)
		cube.firstMaterial!.diffuse.contents = ColorClass.green
		cube.firstMaterial!.ambient.contents = ColorClass.white
		return SCNNode(geometry: cube)
	}
	
	// Text!
	fileprivate class func textNode(_ text: String) -> SCNNode {
		
		let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
		textGeometry.font = FontClass(name: "Avenir", size: 2.0)
		textGeometry.containerFrame = CGRect(origin: CGPoint(x: -5.0, y: -15.0), size: CGSize(width: 10.0, height: 20.0))
//		textGeometry.flatness = 0.2 // Smooth it more
//		textGeometry.chamferRadius = 0.25
		textGeometry.firstMaterial!.diffuse.contents = ColorClass(hue: 0.9, saturation: 0.8, brightness: 1.0, alpha: 1.0)
		textGeometry.firstMaterial!.ambient.contents = ColorClass.white
		return SCNNode(geometry: textGeometry)
	}
	
	// Torus
	fileprivate class func torusNode() -> SCNNode {
		let torus = SCNTorus(ringRadius: 4.0, pipeRadius: 1.5)
		torus.firstMaterial!.diffuse.contents = ColorClass(hue: 0.4, saturation: 0.8, brightness: 1.0, alpha: 1.0)
		torus.firstMaterial!.ambient.contents = ColorClass.white
		return SCNNode(geometry: torus)
	}
	
	// Planets
	fileprivate class func planets() -> SCNNode {
		let sun = SCNSphere(radius: 2.0)
		sun.firstMaterial!.diffuse.contents = ColorClass(hue: 0.7, saturation: 0.8, brightness: 1.0, alpha: 1.0)
		sun.firstMaterial!.ambient.contents = ColorClass.white
		
		let moon = SCNSphere(radius: 1.0)
		moon.firstMaterial!.diffuse.contents = ColorClass(hue: 0.5, saturation: 0.5, brightness: 0.9, alpha: 1.0)
		moon.firstMaterial!.ambient.contents = ColorClass.white
		
		let miniMoon = SCNSphere(radius: 0.5)
		moon.firstMaterial!.diffuse.contents = ColorClass(hue: 0.3, saturation: 0.5, brightness: 0.9, alpha: 1.0)
		moon.firstMaterial!.ambient.contents = ColorClass.white
		
		// the sun's position is at (0, 0, 0) of its parent node's coord system
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

		/*
			sun
			  |_ moon
					|_ miniMoon

			dummySun
				|_ moon2
					|_ miniMoon2
					|_ miniMoon3
		*/
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
