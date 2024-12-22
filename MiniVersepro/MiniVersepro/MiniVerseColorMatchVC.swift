//
//  ColorMatchVC.swift
//  MiniVerse pro
//
//  Created by MiniVerse pro on 2024/12/22.
//


import UIKit

class MiniVerseColorMatchVC: UIViewController {
    
    // UI Elements
    var targetColorLabel: UILabel!
    var scoreLabel: UILabel!
    var timerLabel: UILabel!
    var colorButtons: [UIButton] = []
    
    // Game Variables
    let colors: [UIColor] = [.red, .blue, .green]
    var targetColor: UIColor = .red
    var score = 0
    var timeRemaining = 5 // Timer starts with 5 seconds
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startGame()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Target Color Label
        targetColorLabel = UILabel()
        targetColorLabel.text = "Match This Color!"
        targetColorLabel.font = UIFont.boldSystemFont(ofSize: 24)
        targetColorLabel.textAlignment = .center
        targetColorLabel.backgroundColor = .black
        targetColorLabel.layer.cornerRadius = 10
        targetColorLabel.clipsToBounds = true
        targetColorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(targetColorLabel)
        
        NSLayoutConstraint.activate([
            targetColorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            targetColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            targetColorLabel.widthAnchor.constraint(equalToConstant: 200),
            targetColorLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Timer Label
        timerLabel = UILabel()
        timerLabel.text = "Time: \(timeRemaining)"
        timerLabel.font = UIFont(name: "AvenirNext-Bold", size: 28) // Larger and modern font
        timerLabel.textAlignment = .center
        timerLabel.textColor = .black // Make the timer more visually prominent
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: targetColorLabel.bottomAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Score Label
        scoreLabel = UILabel()
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 28) // Larger and modern font
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .black // Make the score visually distinct
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Color Buttons
        let buttonSize: CGFloat = 100
        let buttonSpacing: CGFloat = 30
        let totalWidth = CGFloat(colors.count) * buttonSize + CGFloat(colors.count - 1) * buttonSpacing
        let startX = (view.bounds.width - totalWidth) / 2
        let startY = view.bounds.height / 2
        
        for i in 0..<colors.count {
            let button = UIButton(frame: CGRect(
                x: startX + CGFloat(i) * (buttonSize + buttonSpacing),
                y: startY,
                width: buttonSize,
                height: buttonSize
            ))
            button.layer.cornerRadius = buttonSize / 2
            button.backgroundColor = colors[i]
            button.tag = i
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            colorButtons.append(button)
            view.addSubview(button)
        }
    }
    
    func startGame() {
        score = 0
        timeRemaining = 5
        updateScore()
        updateTimerLabel()
        setNewTargetColor()
        
        // Start the timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func setNewTargetColor() {
        targetColor = colors.randomElement() ?? .red
        targetColorLabel.backgroundColor = targetColor
        targetColorLabel.text = "Match This Color!"
    }
    
    @objc func updateTimer() {
        timeRemaining -= 1
        updateTimerLabel()
        
        if timeRemaining <= 0 {
            timer?.invalidate()
            endGame()
        }
    }
    
    func updateTimerLabel() {
        timerLabel.text = "Time: \(timeRemaining)"
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        let tappedColor = colors[sender.tag]
        if tappedColor == targetColor {
            // Correct tap
            score += 1
            timeRemaining = 5 // Reset timer
            updateScore()
            updateTimerLabel()
            setNewTargetColor()
        } else {
            // Incorrect tap
            timer?.invalidate()
            endGame()
        }
    }
    
    func updateScore() {
        scoreLabel.text = "Score: \(score)"
    }
    
    func endGame() {
        let alert = UIAlertController(title: "Game Over", message: "Your Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.startGame()
        }))
        alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
