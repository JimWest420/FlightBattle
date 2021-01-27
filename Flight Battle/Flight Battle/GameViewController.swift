//
//  GameViewController.swift
//  Flight Battle
//
//  Created by Валерий Веселов on 22.01.2021.
//

import SceneKit //библиотека для работы с 3Д моделями

class GameViewController: UIViewController {
    
    
    // MARK: Outlets
    let scoreLabel = UILabel()
    
    // MARK: Stored Properties
    var duration: TimeInterval = 10
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // MARK: Computed Properties
    var scene: SCNScene {
        (view as! SCNView).scene!
    }
    
    var ship: SCNNode? {
        scene.rootNode.childNode(withName: "ship", recursively: true)
    }
    
    // MARK: Methods
    func addLabel() {
        scoreLabel.numberOfLines = 2
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.systemFont(ofSize: 30)
        scoreLabel.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        scoreLabel.textAlignment = .center
            
        view.addSubview(scoreLabel)
        score = 0
    }
    
    func addShip() {
        
    let x = Int.random(in: -25...25)
    let y = Int.random(in: -25...25)
    let z = -105
        
    ship?.position = SCNVector3(x, y, z) // задаем координату для самолета
        
    ship?.removeAllActions() // удаляем анимацию корабля
        
    ship?.look(at: SCNVector3(2 * x, 2 * y, 2 * z))
        
    ship?.runAction(SCNAction.move(to: SCNVector3(0, 0, 0), duration: duration)) { // создание анимации корабля
        DispatchQueue.main.async {
            self.scoreLabel.text = "GAME OVER\nScore: \(self.score)"
            self.ship?.removeFromParentNode()
        }
    } //Если инициализировать просто SCNVector3(), то по умолчанию координаты будут 0
        
        duration *= 0.9
        
}

    override func viewDidLoad() {
        super.viewDidLoad() //super показывет что это метод родителя
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")! //SCNScene - объект из библиотеки SceneKit. Объект верхнего уровня на котором все расположено.
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        //cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.green
        scene.rootNode.addChildNode(ambientLightNode)
        

        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        //add label
        addLabel()
        
        //add ship
        addShip()
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.2
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                material.emission.contents = UIColor.black
                
                DispatchQueue.main.async {
                    self.addShip()
                }
                self.score += 1
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    // MARK: Ingerited Computed Properties
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}

