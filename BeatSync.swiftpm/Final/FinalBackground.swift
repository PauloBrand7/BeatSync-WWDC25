import SwiftUI
import SceneKit

struct FinalBackground: UIViewRepresentable {
    var beatLevel: Float
    
    private let baseScale: CGFloat = 0.05
    private let pulsationFactor: CGFloat = 0.00005
    private let backgroundRadius: CGFloat = 50
    private let cameraFOV: CGFloat = 60
    private let cameraPosition = SCNVector3(0, 10, 0)
    private let backgroundPosition = SCNVector3(10, 10, 10)
    private let orbitAnimationDuration: CFTimeInterval = 50
    
    class Coordinator {
        var heartNode: SCNNode?
        var cameraNode: SCNNode?
    }
    
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.backgroundColor = .clear
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = false
        
        sceneView.scene = createScene(coordinator: context.coordinator)
        sceneView.pointOfView = context.coordinator.cameraNode
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        if let heartNode = context.coordinator.heartNode {
            let scale = baseScale + CGFloat(beatLevel) * pulsationFactor
            heartNode.scale = SCNVector3(scale, scale, scale)
        }
    }
    
    private func createScene(coordinator: Coordinator) -> SCNScene {
        let scene = SCNScene()
        
        let backgroundNode = createBackgroundNode()
        backgroundNode.position = backgroundPosition
        scene.rootNode.addChildNode(backgroundNode)
        
        guard let heart = SCNScene(named: "heart.usdz") else {
            print("Error to load heart")
            return scene
        }

        let heartNode = heart.rootNode
        coordinator.heartNode = heartNode
        scene.rootNode.addChildNode(heartNode)
        
        let cameraNode = createCameraNode(target: heartNode)
        coordinator.cameraNode = cameraNode
        
        let cameraOrbit = SCNNode()
        cameraOrbit.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cameraOrbit)
        
        let orbitAnimation = CABasicAnimation(keyPath: "rotation")
        orbitAnimation.toValue = NSValue(scnVector4: SCNVector4(0, 0, 1, Float.pi * 2))
        orbitAnimation.duration = orbitAnimationDuration
        orbitAnimation.repeatCount = .infinity
        cameraOrbit.addAnimation(orbitAnimation, forKey: "orbit")
        
        return scene
    }
    
    private func createBackgroundNode() -> SCNNode {
        let sphere = SCNSphere(radius: backgroundRadius)
        if let bgImage = UIImage(named: "background") {
            let material = SCNMaterial()
            material.diffuse.contents = bgImage
            material.isDoubleSided = true
            material.lightingModel = .constant
            sphere.materials = [material]
        }
        
        return SCNNode(geometry: sphere)
    }
    
    private func createCameraNode(target: SCNNode) -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = cameraFOV
        cameraNode.position = cameraPosition
        
        let lookAtConstraint = SCNLookAtConstraint(target: target)
        lookAtConstraint.isGimbalLockEnabled = true
        lookAtConstraint.worldUp = SCNVector3(0, 0, 1)
        cameraNode.constraints = [lookAtConstraint]
        
        return cameraNode
    }
}
