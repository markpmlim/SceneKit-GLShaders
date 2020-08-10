//
//	ShaderData.swift
//	CustomShaders
//
//	Created by Nathanael Beisiegel on 11/23/14.
//	Copyright (c) 2014 Nathanael Beisiegel. All rights reserved.
//
// There is no provision to set arguments

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
import SceneKit

class ShaderData: NSObject {
	var filename: String
	var shaderProgram: String // Read only

	init(filename: String) {
		self.filename = filename
		let path = Bundle.main.path(forResource: self.filename,
                                    ofType: "shader")
		shaderProgram = try! String(contentsOfFile: path!,
                                    encoding: String.Encoding.utf8)
	}
}

// 2 designated initializers
// nodeSetup defaults to nil
// This class has 2 initializers. There is another option to setup the node.
class ModelData: NSObject {
	var filename: String
	var node: SCNNode

    // Instantiate an instance of SCNNode from a file.
	init(filename: String, nodeName: String, nodeSetup: ((SCNNode) -> Void)? = nil) {
		self.filename = filename
		node = SCNScene(named: "art.scnassets/\(filename).dae")?.rootNode.childNode(withName: nodeName,
                                                                                    recursively: true) as SCNNode!
        nodeSetup?(node)
	}

	init(name: String, node: SCNNode, nodeSetup: ((SCNNode) -> Void)? = nil) {
		self.filename = name
		self.node = node
		nodeSetup?(node)
	}
}

protocol SettingItem {
	var title: String {get}
	var selected: Bool {get set}
}

// Default -- None to be selected
class NoneSettingItem: SettingItem {
	var title: String = "None"
	var selected: Bool = true
}

// classes implementing the SettingItem protocol
class ModelSettingItem: SettingItem {
	var modelData: ModelData
	var selected: Bool
	
	var title: String {
		get {
			return modelData.filename
		}
	}

	init(modelData: ModelData, selected: Bool = false) {
		self.modelData = modelData
		self.selected = selected
	}
}

class ShaderSettingItem: SettingItem {
	var shaderData: ShaderData
	var selected: Bool
	var title: String {
		get {
			return shaderData.filename
		}
	}
	var shaderProgram: String {
		get {
			return shaderData.shaderProgram
		}
	}

	init(shaderData: ShaderData, selected: Bool = false) {
		self.shaderData = shaderData
		self.selected = selected
	}
}

class Settings: NSObject {
	var items: [SettingItem]
	
	init(items: [SettingItem]) {
		self.items = items
	}

	func selected() -> SettingItem? {
		for item in items {
			if item.selected {
				return item
			}
		}
		return nil
	}
}
