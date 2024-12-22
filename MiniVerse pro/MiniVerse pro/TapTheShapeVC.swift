//
//  TapTheShapeVC.swift
//  MiniVerse pro
//
//  Created by jin fu on 2024/12/22.
//


import UIKit

class TapTheShapeVC: UIViewController {
    
    // UI Elements
    var targetShapeLabel: UILabel!
    var scoreLabel: UILabel!
    var shapeButtons: [UIButton] = []
    
    // Game Variables
    let shapes = ["Circle", "Square", "Triangle"]
    var targetShape: String = "Circle"
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startGame()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Target Shape Label
        targetShapeLabel = UILabel()
        targetShapeLabel.text = "Target: Circle"
        targetShapeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        targetShapeLabel.textAlignment = .center
        targetShapeLabel.backgroundColor = .lightGray
        targetShapeLabel.layer.cornerRadius = 10
        targetShapeLabel.clipsToBounds = true
        targetShapeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(targetShapeLabel)
        
        NSLayoutConstraint.activate([
            targetShapeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            targetShapeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            targetShapeLabel.widthAnchor.constraint(equalToConstant: 200),
            targetShapeLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Score Label
        scoreLabel = UILabel()
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 18)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .black
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: targetShapeLabel.bottomAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Shape Buttons
        let buttonSize: CGFloat = 100
        let buttonSpacing: CGFloat = 30
        let totalWidth = CGFloat(shapes.count) * buttonSize + CGFloat(shapes.count - 1) * buttonSpacing
        let startX = (view.bounds.width - totalWidth) / 2
        let startY = view.bounds.height / 2
        
        for i in 0..<shapes.count {
            let button = UIButton(frame: CGRect(
                x: startX + CGFloat(i) * (buttonSize + buttonSpacing),
                y: startY,
                width: buttonSize,
                height: buttonSize
            ))
            button.layer.cornerRadius = buttonSize / 2
            button.backgroundColor = .systemBlue
            button.setTitle(shapes[i], for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(shapeButtonTapped(_:)), for: .touchUpInside)
            shapeButtons.append(button)
            view.addSubview(button)
        }
    }
    
    func startGame() {
        score = 0
        updateScore()
        setNewTargetShape()
    }
    
    func setNewTargetShape() {
        targetShape = shapes.randomElement() ?? "Circle"
        targetShapeLabel.text = "Target: \(targetShape)"
    }
    
    @objc func shapeButtonTapped(_ sender: UIButton) {
        let tappedShape = shapes[sender.tag]
        if tappedShape == targetShape {
            // Correct tap
            score += 1
            updateScore()
            setNewTargetShape()
        } else {
            // Incorrect tap
            endGame()
        }
    }
    
    func updateScore() {
        scoreLabel.text = "Score: \(score)"
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func endGame() {
        let alert = UIAlertController(title: "Game Over", message: "Your Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.startGame()
        }))
        alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    @IBAction func cancle(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}