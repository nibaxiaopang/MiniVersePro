//
//  TapBlastArenaVC.swift
//  MiniVerse pro
//
//  Created by jin fu on 2024/12/22.
//


import UIKit
import AVFoundation

class TapBlastArenaVC: UIViewController {
    
    // UI Elements
    var scoreLabel: UILabel!
    var timerLabel: UILabel!
    var gameArea: UIView!
    
    // Game variables
    var score = 0
    var timeRemaining = 30
    var timer: Timer?
    var isGameStarted = false // Prevent multiple game starts
    
    // Audio players
    var tapSoundPlayer: AVAudioPlayer?
    var bombSoundPlayer: AVAudioPlayer?
    var gameOverSoundPlayer: AVAudioPlayer?
    
    // Predefined set of 12 colors
    let ballColors: [UIColor] = [
        .red, .blue, .green, .yellow, .orange, .purple,
        .cyan, .magenta, .brown, .systemPink, .gray, .black
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSounds()
    }
    
    // Ensure layout is ready before starting the game
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isGameStarted {
            isGameStarted = true
            startGame()
        }
    }
    
    // Setup the game UI
    func setupUI() {
        // Add a gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Score Label
        scoreLabel = UILabel()
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        scoreLabel.layer.cornerRadius = 8
        scoreLabel.clipsToBounds = true
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80), // Adjusted position
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scoreLabel.widthAnchor.constraint(equalToConstant: 120),
            scoreLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Timer Label
        timerLabel = UILabel()
        timerLabel.text = "Time: 30"
        timerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        timerLabel.textColor = .white
        timerLabel.textAlignment = .center
        timerLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        timerLabel.layer.cornerRadius = 8
        timerLabel.clipsToBounds = true
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80), // Adjusted position
            timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            timerLabel.widthAnchor.constraint(equalToConstant: 120),
            timerLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Game Area
        gameArea = UIView()
        gameArea.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        gameArea.layer.cornerRadius = 12
        gameArea.layer.borderWidth = 2
        gameArea.layer.borderColor = UIColor.white.cgColor
        gameArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameArea)
        
        NSLayoutConstraint.activate([
            gameArea.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 16),
            gameArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gameArea.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            gameArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // Load sound files
    func loadSounds() {
        tapSoundPlayer = loadSound(named: "tap")
        bombSoundPlayer = loadSound(named: "bomb")
        gameOverSoundPlayer = loadSound(named: "game_over")
    }
    
    func loadSound(named name: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return nil }
        return try? AVAudioPlayer(contentsOf: url)
    }
    
    // Start the game logic
    func startGame() {
        score = 0
        timeRemaining = 30
        updateScore()
        updateTimerLabel()
        
        // Start game timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        // Spawn balls
        spawnBall()
    }
    
    // Update score
    func updateScore() {
        scoreLabel.text = "Score: \(score)"
    }
    
    // Update timer label
    func updateTimerLabel() {
        timerLabel.text = "Time: \(timeRemaining)"
    }
    
    // Game timer logic
    @objc func updateTimer() {
        timeRemaining -= 1
        updateTimerLabel()
        
        if timeRemaining <= 0 {
            timer?.invalidate()
            gameOverSoundPlayer?.play()
            showGameOverAlert()
        }
    }
    
    // Spawn a ball (normal, bonus, or bomb)
    func spawnBall() {
        guard gameArea.bounds.width > 0, gameArea.bounds.height > 0 else { return }
        
        let ballSize: CGFloat = 60
        let xPosition = CGFloat.random(in: 0...(gameArea.bounds.width - ballSize))
        let yPosition = CGFloat.random(in: 0...(gameArea.bounds.height - ballSize))
        
        let ball = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: ballSize, height: ballSize))
        ball.layer.cornerRadius = ballSize / 2
        ball.layer.shadowColor = UIColor.black.cgColor
        ball.layer.shadowOpacity = 0.4
        ball.layer.shadowOffset = CGSize(width: 0, height: 4)
        ball.layer.shadowRadius = 4
        
        // Decide ball type (normal, bonus, or bomb)
        let randomType = Int.random(in: 0...9)
        if randomType < 7 {
            // Normal ball
            ball.backgroundColor = ballColors.randomElement()
            ball.addTarget(self, action: #selector(normalBallTapped(_:)), for: .touchUpInside)
        } else if randomType == 7 {
            // Bonus ball
            ball.backgroundColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // Gold color
            ball.addTarget(self, action: #selector(bonusBallTapped(_:)), for: .touchUpInside)
        } else {
            // Bomb ball
            ball.backgroundColor = .black
            ball.addTarget(self, action: #selector(bombBallTapped(_:)), for: .touchUpInside)
        }
        
        gameArea.addSubview(ball)
        
        // Fade-in animation
        ball.alpha = 0
        UIView.animate(withDuration: 0.5) {
            ball.alpha = 1
        }
        
        // Ball disappears after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.5, animations: {
                ball.alpha = 0
            }) { _ in
                ball.removeFromSuperview()
            }
        }
        
        // Spawn another ball after a random delay
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...1.0)) {
            self.spawnBall()
        }
    }
    
    // Handle normal ball tap
    @objc func normalBallTapped(_ sender: UIButton) {
        score += 1
        updateScore()
        tapSoundPlayer?.play()
        animateBallTap(sender)
    }
    
    // Handle bonus ball tap
    @objc func bonusBallTapped(_ sender: UIButton) {
        score += 5
        updateScore()
        tapSoundPlayer?.play()
        animateBallTap(sender)
    }
    
    // Handle bomb ball tap
    @objc func bombBallTapped(_ sender: UIButton) {
        score -= 2
        updateScore()
        bombSoundPlayer?.play()
        
        // Vibration feedback
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
        animateBallTap(sender)
    }
    
    // Animate ball tap (scale and fade out)
    func animateBallTap(_ ball: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            ball.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            ball.alpha = 0
        }) { _ in
            ball.removeFromSuperview()
        }
    }
    

    // Show game over alert
    func showGameOverAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Your score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.startGame()
        }))
        alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}