//
//  ViewController.swift
//  Milestone Project 3
//
//  Created by Carmen Morado on 12/8/20.
//

import UIKit

class ViewController: UIViewController {
    var allWords = [String]()
    var cluesLabel: UILabel!
    var hangManLabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var letterArray = [String]()
    var correctLetters = [String]()
    var scoreLabel: UILabel!
    var hangManIndex = 0
    var hangMan = ["""


""", """
   O



""", """
   O
   |


""", """
   O
  /|
      

""", """
   O
   /|\\


""", """
   O
   /|\\
 /
        
""", """
   O
   /|\\
   / \\
        
""", """
    +---+
    |   |
   O  |
  /|\\  |
  / \\  |
        |
  =========
 """]
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 100)
        cluesLabel.text = ""
        cluesLabel.textAlignment = .center
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        hangManLabel = UILabel()
        hangManLabel.translatesAutoresizingMaskIntoConstraints = false
        hangManLabel.font = UIFont.systemFont(ofSize: 50)
        hangManLabel.text = hangMan[0]
        hangManLabel.textAlignment = .center
        hangManLabel.numberOfLines = 0
        hangManLabel.lineBreakMode = .byClipping
        hangManLabel.minimumScaleFactor = 0.5
        hangManLabel.adjustsFontSizeToFitWidth = true
        hangManLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview( hangManLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Choose a letter"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 60)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cluesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -50),
            cluesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cluesLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -800),
            hangManLabel.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: -100),
            hangManLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: hangManLabel.bottomAnchor, constant: 20),
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            buttonsView.widthAnchor.constraint(equalToConstant: 850),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 120
        let height = 80
        let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        
        for row in 0..<5 {
            for col in 0..<7 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                letterButton.setTitle("", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                buttonsView.addSubview(letterButton)

                letterButtons.append(letterButton)
            }
        }
        
        for i in 0 ..< 32 {
            if i >= alphabet.count {
                letterButtons[i].setTitle("", for: .normal)
            }
            
            else {
                letterButtons[i].setTitle(alphabet[i], for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        startGame()
    }
    
    func startGame() {
        cluesLabel.text! = ""
        
        hangManLabel.text = hangMan[0]
        
        score = 0
        
        hangManIndex = 0
        
        for btn in letterButtons {
            btn.isHidden = false
        }
        
        if !letterArray.isEmpty {
            letterArray.removeAll(keepingCapacity: true)
        }
        
        if !correctLetters.isEmpty {
            correctLetters.removeAll(keepingCapacity: true)
        }
        
        let word = allWords.randomElement()!.map { String($0) }
        letterArray = Array(word)
        print(letterArray)
    
        for _ in letterArray
        {
            cluesLabel.text! += "?"
        }
        
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for btn in activatedButtons {
            btn.isHidden = false
        }

        activatedButtons.removeAll()
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        if  currentAnswer.text == "" {
            let ac = UIAlertController(title: "Please select a letter!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        
        guard let answerText = currentAnswer.text else { return }
        
        var letterArray2 = letterArray
        
        for i in 0..<letterArray.count {
            if letterArray[i] == answerText {
                letterArray2[i] = answerText
                correctLetters.append(answerText)
                activatedButtons.removeAll()
                score += 1
            }
            
            else {
                if !correctLetters.contains(letterArray2[i]) {
                    letterArray2[i] = "?"
                    activatedButtons.removeAll()
                }
                
                if ((!letterArray.contains(answerText)) && (i == letterArray.count - 1)) {
                    hangManIndex += 1
                    if hangManIndex == 7 {
                        let ac = UIAlertController(title: "You lost!!!!", message: nil, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Retry", style: .default, handler: restartGame))
                        present(ac, animated: true)
                    }
                    hangManLabel.text = hangMan[hangManIndex]
                    let ac = UIAlertController(title: "Incorrect!", message: "Please enter a different letter.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
                    present(ac, animated: true)
                    score -= 1
                }
            }
        }
        
        cluesLabel.text = letterArray2.joined()
        currentAnswer.text = ""
        
        if letterArray.joined() == letterArray2.joined() {
            let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next word?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: restartGame))
            present(ac, animated: true)
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        if !currentAnswer.text!.isEmpty {
            return
        }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    func restartGame(action: UIAlertAction) {
        startGame()
    }


}

