//
//  ViewController.swift
//  clusterRecon
//
//  Created by Rsabie on 11/03/2021.
//

import UIKit
import SceneKit
import ARKit


func pointCloudGeometry(for points:[float3]) -> SCNGeometry? {
       
        guard !points.isEmpty else { return nil }
        
        let stride = MemoryLayout<float3>.size
        let pointData = Data(bytes: points, count: stride * points.count)
        
        let source = SCNGeometrySource(data: pointData,
                                       semantic: SCNGeometrySource.Semantic.vertex,
                                       vectorCount: points.count,
                                       usesFloatComponents: true,
                                       componentsPerVector: 3,
                                       bytesPerComponent: MemoryLayout<Float>.size,
                                       dataOffset: 0,
                                       dataStride: stride)
        
        let pointSize:CGFloat = 10
        let element = SCNGeometryElement(data: nil, primitiveType: .point, primitiveCount: points.count, bytesPerIndex: 0)
        element.pointSize = 0.001
    element.minimumPointScreenSpaceRadius = pointSize
    element.maximumPointScreenSpaceRadius = pointSize
        
        let pointsGeometry = SCNGeometry(sources: [source], elements: [element])
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        material.isDoubleSided = true
        material.locksAmbientWithDiffuse = true
        
        return pointsGeometry
        
}

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var switchStatus = false
    
    var visualizedPointCloud : SCNNode? = nil
    
    
    
    let showDebugOptions = true
    let debugOptions : SCNDebugOptions  = [ARSCNDebugOptions.showFeaturePoints]
    
    //var points: [vector_float3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.session.delegate = self
        
        if showDebugOptions{
            sceneView.debugOptions = debugOptions
        }
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame){
        guard let featurePoints = frame.rawFeaturePoints else {
            //print("sukkkkkk--------")
            return
            
        }
        
        if switchStatus{
            
            let featurePointsGeometry = pointCloudGeometry(for: featurePoints.points)
            
            let featurePointsNode = SCNNode(geometry: featurePointsGeometry)
            
            //featurePointsNode.geometry = featurePointsGeometry
            
            if featurePointsNode.parent == nil {
                if let vPC = visualizedPointCloud {
                    sceneView.scene.rootNode.replaceChildNode(vPC, with: featurePointsNode)
                }
                else {
                    sceneView.scene.rootNode.addChildNode(featurePointsNode)
                    
                }
                visualizedPointCloud = featurePointsNode
                
            }
        }
    }
    
    @IBAction func statusChanged(_ sender: UISwitch) {
        switchStatus = sender.isOn
    }
    


    
    
    
    
    @IBAction func makeAction(_ sender: Any) {
        if let frame = sceneView.session.currentFrame {
            session(sceneView.session, didUpdate: frame)
        }
    }
    
    func mActionAnchors1(){
        var targettedAnchorNode: SCNNode?
        
        if let anchors = sceneView.session.currentFrame?.anchors {
            print("---- --"+anchors.debugDescription)
            for anchor in anchors {
                
                if let anchorNode = sceneView.node(for: anchor), let pointOfView = sceneView.pointOfView, sceneView.isNode(anchorNode, insideFrustumOf: pointOfView) {
                    targettedAnchorNode = anchorNode
                    break
                }
                
                debugPrint("---"+anchor.debugDescription)
                
            }
            
            if let targettedAnchorNode = targettedAnchorNode {
                addNode(position: SCNVector3Zero, anchorNode: targettedAnchorNode)
            } else {
                debugPrint("Targetted node not found")
            }
            
        } else {
            debugPrint("Anchors not found")
        }
    }
    
    
    func addNode(position : SCNVector3, anchorNode : SCNNode) {
        
        let sphere = SCNSphere(radius: 0.2)
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.green
        //material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
        sphere.materials = [material]
        
        
        let node = SCNNode()
        node.position = SCNVector3(0, 0.1, -0.5)
        
        node.geometry = sphere
        
        sceneView.scene.rootNode.addChildNode(node)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - ARSCNViewDelegate
    
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.1)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        
        return node
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
