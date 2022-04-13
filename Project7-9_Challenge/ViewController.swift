//
//  ViewController.swift
//  Project7-9_Challenge
//
//  Created by Oscar Lui on 31/3/2022.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    var wordsLabel: UILabel!
    var scoreLabel: UILabel!
    var mistakeLabel: UILabel!
    var currentAnswer: UITextField!
    var wordslist:[String] = []
    var level = 0
    var mistake = 0 {
        didSet {
            mistakeLabel.text = "Mistake: \(mistake)"
        }
    }
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
        scoreLabel.text = "Score: \(score)"
        view.addSubview(scoreLabel)
        
        mistakeLabel = UILabel()
        
        mistakeLabel.translatesAutoresizingMaskIntoConstraints = false
        mistakeLabel.textAlignment = .center
        mistakeLabel.text = "Mistake: \(mistake)"
        view.addSubview(mistakeLabel)
        
        wordsLabel = UILabel()
        wordsLabel.translatesAutoresizingMaskIntoConstraints = false
        wordsLabel.textAlignment = .center
        wordsLabel.textColor = .darkText
        wordsLabel.text = "Testing"
        wordsLabel.font = UIFont.systemFont(ofSize: 40)
        view.addSubview(wordsLabel)
        
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Guess please"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 30)
        
        
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
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            mistakeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mistakeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            wordsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -100),
            wordsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.topAnchor.constraint(equalTo: wordsLabel.bottomAnchor,constant: 80),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.5),
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor,constant: 20),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -40),
            submit.heightAnchor.constraint(equalToConstant: 44),
            clear.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor,constant: 20),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant:40),
            clear.heightAnchor.constraint(equalToConstant: 44)
            
        
        
        
        
        
        
        
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentAnswer.delegate = self
        loadwords()
        // Do any additional setup after loading the view.
    }
    
    @objc func submitTapped(_ sender:UIButton) {
        print("hi")
        guard let currentAnswer = currentAnswer.text else {
            print("no content")
            return
        }
        if wordslist[level].uppercased().contains(currentAnswer) {
            var text:String = wordsLabel.text!
            var word = wordslist[level]
            for (_,character) in wordslist[level].enumerated() {
                if character.uppercased() == currentAnswer {
                    
                    
                    let selectedchar = CharacterSet(charactersIn:String(character))
                    if let range = word.rangeOfCharacter(from: selectedchar) {
                        text.replaceSubrange(range, with: String(character))
                        word.replaceSubrange(range, with: "?")
                        
                    }
                }
            }
            wordsLabel.text = text
            clearTapped()
            if wordsLabel.text == wordslist[level] {
                nextlevel()
                            }
            
        }
        else {
            mistake += 1
        }
        
    }
    
    @objc func clearTapped() {
        currentAnswer.text = ""
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return updatedText.count <= 1
    }
    
    func loadwords() {

            if let levelFileURL = Bundle.main.url(forResource: "words", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelFileURL) {
                let lines = levelContents.components(separatedBy: "\n")
                //lines.shuffle()
                wordslist = lines
                wordsLabel.text = String(repeating: "?", count: wordslist[0].count)
                
            }
            }
    }
    
    
    func nextlevel() {
        level += 1
        score += 1
        mistake = 0
        let ac = UIAlertController(title: "Congrats!", message: "You will enter level \(level+1) now.  ", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
        present(ac,animated: true)
        wordsLabel.text = String(repeating: "?", count: wordslist[level].count)
        
    }

}

