//
//  ViewController.swift
//  Project5
//
//  Created by Alex Cannizzo on 16/08/2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
        
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true, completion: nil)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
//        let errorTitle: String
//        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    if isLongerThanThreeWords(word: lowerAnswer) {
                        if isNotStartWord(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                        } else {
                            showErrorMessage(eTitle: "Word not allowed", eMessage: "You know what you've done...")
                        }
                    } else {
                        showErrorMessage(eTitle: "Word is too short", eMessage: "Your word must be at least 3 letters long")
                    }
                } else {
                    showErrorMessage(eTitle: "Word not recognised", eMessage: "You can't invent words!")
                }
            } else {
                showErrorMessage(eTitle: "Word already used", eMessage: "Again??")
            }
        } else {
            guard let title = title?.lowercased() else { return }
            showErrorMessage(eTitle: "Word not possible", eMessage: "You can't spell that word from \(title)")
        }
        
//        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Got it", style: .default))
//        present(ac, animated: true, completion: nil)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isLongerThanThreeWords(word: String) -> Bool {
        if word.count > 3 {
            return true
        } else {
            return false
        }
    }
    
    func isNotStartWord(word: String) -> Bool {
        if word != title {
            return true
        } else {
            return false
        }
    }
    
    func showErrorMessage(eTitle: String, eMessage: String) {
        let ac = UIAlertController(title: eTitle, message: eMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Got it", style: .default))
        present(ac, animated: true, completion: nil)
    }
    
}

