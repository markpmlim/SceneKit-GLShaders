//
//	GameViewController.swift
//	CustomShaders
//
//	Created by Nathanael Beisiegel on 11/18/14.
//	Copyright (c) 2014 Nathanael Beisiegel. All rights reserved.
//
// Modified by Mark Lim to work with macOS

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import QuartzCore
import SceneKit

#if os(iOS)
typealias ViewController = UIViewController
typealias GestureRecognizerClass = UIGestureRecognizer
typealias TapGestureRecognizerClass = UITapGestureRecognizer
#elseif os(OSX)
typealias ViewController = NSViewController
typealias GestureRecognizerClass = NSGestureRecognizer
typealias TapGestureRecognizerClass = NSClickGestureRecognizer
#endif

// Under OSX, an instance of this class manages the view embedded
// in the upper splitview item.
class GameViewController: ViewController {

	@IBOutlet weak var scnView: SCNView!
	// Modal object that holds settings with models, shaders, etc
	var settings: AllSettings = AllSettings()
	var currentNode: SCNNode?

	override func viewDidLoad() {
		super.viewDidLoad()
		// create a new scene
		let scene = SCNScene()

		// Configure lighting / camera nodes
		initLightsAndCamera(scene)
		
		// set the scene to the view
		scnView.scene = scene
		
		// Load Model into scene
		updateModel()
		
		// allows the user to manipulate the camera
		scnView.allowsCameraControl = true
		
		// show statistics such as fps and timing information
		scnView.showsStatistics = true
		
		// configure the view
		scnView.backgroundColor = ColorClass(hue: 0.8, saturation: 0.1, brightness: 0.2, alpha: 1.0)
		
	#if os(iOS)
		// add a tap gesture recognizer
		let tapGesture = TapGestureRecognizerClass(target: self,
                                                   action: #selector(GameViewController.handleTap(_:)))
		var gestureRecognizers = [GestureRecognizerClass]()
		gestureRecognizers.append(tapGesture)
		if let existingGestureRecognizers = scnView.gestureRecognizers {
			gestureRecognizers += existingGestureRecognizers
		}
	#elseif os(OSX)
		let tapGesture = NSClickGestureRecognizer(target: self,
                                                  action: #selector(GameViewController.handleTap(_:)))
		var gestureRecognizers = [NSGestureRecognizer]()
		gestureRecognizers.append(tapGesture)
		let existingGestureRecognizers = scnView.gestureRecognizers
		gestureRecognizers += existingGestureRecognizers
	#endif
		scnView.gestureRecognizers = gestureRecognizers

		// Keep Shaders animating
		scnView.isPlaying = true
		scnView.loops = true
	}
	
	
	func initLightsAndCamera(_ scene: SCNScene) {
		// create and add a camera to the scene
		let cameraNode = SCNNode()
		cameraNode.camera = SCNCamera()
		scene.rootNode.addChildNode(cameraNode)
		
		// place the camera
		cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
		
		// create and add a light to the scene
		let lightNode = SCNNode()
		lightNode.light = SCNLight()
		lightNode.light!.type = SCNLight.LightType.omni
		lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
		scene.rootNode.addChildNode(lightNode)
		
		// create and add an ambient light to the scene
		let ambientLightNode = SCNNode()
		ambientLightNode.light = SCNLight()
		ambientLightNode.light!.type = SCNLight.LightType.ambient
		ambientLightNode.light!.color = ColorClass.darkGray
		scene.rootNode.addChildNode(ambientLightNode)
	}
	
	// common to both iOS and OS X
	func handleTap(_ gestureRecognize: GestureRecognizerClass) {
		// check what nodes are tapped
		let p = gestureRecognize.location(in: scnView)
		let hitResults = scnView.hitTest(p, options: nil)

		// check that we clicked on at least one object
		if hitResults.count > 0 {
			// retrieved the first clicked object
			let result: AnyObject! = hitResults[0]
			
			// get its material
			let material = result.node!.geometry!.firstMaterial!
			
			// highlight it
			SCNTransaction.begin()
			SCNTransaction.animationDuration = 0.5
			// on completion - unhighlight
            SCNTransaction.completionBlock = {
				SCNTransaction.begin()
				SCNTransaction.animationDuration = 0.5

				material.emission.contents = ColorClass.black

				SCNTransaction.commit()
			}
			
			material.emission.contents = ColorClass.red
			
			SCNTransaction.commit()
		}
	}
	
	
	// MARK: - Updating Lambdas
	
	func updateShaders() {
		// Recreate shader modifiers
		var newShaderModifiers: [SCNShaderModifierEntryPoint: String] = [:]
		if let settingItem = settings.geometrySettings.selected() as? ShaderSettingItem {
			newShaderModifiers[SCNShaderModifierEntryPoint.geometry] = settingItem.shaderProgram
		}
		
		if let settingItem = settings.surfaceSettings.selected() as? ShaderSettingItem {
			newShaderModifiers[SCNShaderModifierEntryPoint.surface] = settingItem.shaderProgram
		}
		
		if let settingItem = settings.lightingSettings.selected() as? ShaderSettingItem {
			newShaderModifiers[SCNShaderModifierEntryPoint.lightingModel] = settingItem.shaderProgram
		}
		
		if let settingItem = settings.fragmentSettings.selected() as? ShaderSettingItem {
			newShaderModifiers[SCNShaderModifierEntryPoint.fragment] = settingItem.shaderProgram
		}

		currentNode!.geometry?.shaderModifiers = newShaderModifiers
		currentNode!.enumerateChildNodes( {
			(node: SCNNode, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
			node.geometry?.shaderModifiers = newShaderModifiers
			return
		})
	}
	
	
	func updateModel() {
		if let modelItem = settings.modelSettings.selected() as? ModelSettingItem {
			if currentNode == nil {
				currentNode = modelItem.modelData.node
				scnView.scene?.rootNode.addChildNode(currentNode!)
			}
			else if currentNode! != modelItem.modelData.node {
				scnView.scene?.rootNode.replaceChildNode(currentNode!, with: modelItem.modelData.node)
				currentNode = modelItem.modelData.node
			}
		}
		
		updateShaders()
	}

#if os(iOS)
	// MARK: - Lifecycle / Storyboard
	
	override var shouldAutorotate : Bool {
		return true
	}
	
	// TODO modify this for the table view?
	override var prefersStatusBarHidden : Bool {
		return true
	}
	
	override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return UIInterfaceOrientationMask.allButUpsideDown
		} else {
			return UIInterfaceOrientationMask.all
		}
	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// For the different settings popovers, set the items for that button 
		// and callback lambda for update
		switch segue.identifier!	{
		case "modelSettings":
			let settingsTableView = segue.destination as! SettingsTableViewController
			settingsTableView.settingData = settings.modelSettings.items
			settingsTableView.gameUpdater = updateModel
		case "geometrySettings":
			let settingsTableView = segue.destination as! SettingsTableViewController
			settingsTableView.settingData = settings.geometrySettings.items
			settingsTableView.gameUpdater = updateShaders
		case "surfaceSettings":
			let settingsTableView = segue.destination as! SettingsTableViewController
			settingsTableView.settingData = settings.surfaceSettings.items
			settingsTableView.gameUpdater = updateShaders
		case "lightSettings":
			let settingsTableView = segue.destination as! SettingsTableViewController
			settingsTableView.settingData = settings.lightingSettings.items
			settingsTableView.gameUpdater = updateShaders
		case "fragmentSettings":
			let settingsTableView = segue.destination as! SettingsTableViewController
			settingsTableView.settingData = settings.fragmentSettings.items
			settingsTableView.gameUpdater = updateShaders
		default:
			break
		}
	}
#endif
}

