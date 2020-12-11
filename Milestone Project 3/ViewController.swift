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
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var letterArray = [String]()
    var correctLetters = [String]()
    var scoreLabel: UILabel!
    
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
        cluesLabel.font = UIFont.systemFont(ofSize: 80)
        cluesLabel.text = ""
        cluesLabel.textAlignment = .center
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Type a letter"
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
            cluesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // make the clues label 60% of the width of our layout margins, minus 100
            //cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.9, constant: 100),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
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
        
        // set some values for the width and height of each button
        let width = 120
        let height = 80
        let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        
        for row in 0..<5 {
            for col in 0..<7 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                // give the button some temporary empty String value
                letterButton.setTitle("", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                // and also to the letterButtons array
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
        
        for btn in letterButtons {
            btn.isHidden = false
        }
        
        score = 0
        
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

