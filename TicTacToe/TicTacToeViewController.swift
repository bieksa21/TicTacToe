//
//  ViewController.swift
//  TicTacToe
//
//  Created by joey frenette on 2016-10-21.
//  Copyright © 2016 joey frenette. All rights reserved.
//

import UIKit

class TicTacToeViewController: UIViewController {

    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var replay: UIButton!
    @IBOutlet weak var resetScore: UIButton!
    var xTurn = true
    var xStartFirst = true
    var tagSetFlags = [Int:String]()
    let numEntries = 9
    var xWins: Int = 0
    var oWins: Int = 0
    @IBOutlet weak var xScore: UILabel!
    @IBOutlet weak var oScore: UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        resetFlags()
        replay.setTitle("Play again", for: [])
        replay.titleLabel?.textColor = UIColor.blue
        replay.alpha = 0
        turnLabel.text = "X's turn! 😏"

        //scoreboard
        if let tempxWins = UserDefaults.standard.object(forKey: "xwins") as? Int {
            self.xWins = tempxWins
            xScore.text = String(xWins)
        } else {
            xScore.text = String(0)
        }
        
        if let tempoWins = UserDefaults.standard.object(forKey: "owins") as? Int {
            self.oWins = tempoWins
            oScore.text = String(oWins)
        } else {
            oScore.text = String(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        //tags are unique identifiers for the UI buttons
        print(sender.tag)
        if tagSetFlags[sender.tag]! == "" {
            if xTurn {
                sender.setImage(UIImage(named: "cross.png"), for: [])
                tagSetFlags[sender.tag] = "x"
            } else {
                sender.setImage(UIImage(named: "nought.png"), for: [])
                tagSetFlags[sender.tag] = "o"
            }
            if doWeHaveWinner() {
                displayWinner()
            } else {
                if isFull() {
                    displayTie()
                }
            }
            xTurn = !xTurn
            updateTurnLabel()
        }
    }
    
    func doWeHaveWinner() -> Bool {
        if tagSetFlags[1] == tagSetFlags[2] && tagSetFlags[1] == tagSetFlags[3] && tagSetFlags[1] != "" || tagSetFlags[4] == tagSetFlags[5] && tagSetFlags[4] == tagSetFlags[6] && tagSetFlags[4] != "" || tagSetFlags[7] == tagSetFlags[8] && tagSetFlags[7] == tagSetFlags[9] && tagSetFlags[7] != "" || tagSetFlags[1] == tagSetFlags[4] && tagSetFlags[1] == tagSetFlags[7] && tagSetFlags[1] != "" || tagSetFlags[2] == tagSetFlags[5] && tagSetFlags[2] == tagSetFlags[8] && tagSetFlags[2] != "" || tagSetFlags[3] == tagSetFlags[6] && tagSetFlags[3] == tagSetFlags[9] && tagSetFlags[3] != "" || tagSetFlags[1] == tagSetFlags[5] && tagSetFlags[1] == tagSetFlags[9] && tagSetFlags[1] != "" || tagSetFlags[3] == tagSetFlags[5] && tagSetFlags[3] == tagSetFlags[7] && tagSetFlags[3] != "" {
            return true
        }
        return false
    }
    
    func displayWinner() {
        if xTurn {
            if xWins - oWins > 4 {
                winnerLabel.text = "X wins yet again.. 😂"
            } else {
                    winnerLabel.text = "X is the winner! 😄"
            }
            xWins += 1
            UserDefaults.standard.set(xWins, forKey: "xwins")
            xScore.text = String(xWins)
        } else {
            if oWins - xWins > 4 {
                winnerLabel.text = "O is hard to stop! 😮"
            } else {
                winnerLabel.text = "O Yeah! Go O! 😊"
            }
            oWins += 1
            UserDefaults.standard.set(oWins, forKey: "owins")
            oScore.text = String(oWins)
        }
        
        turnLabel.alpha = 0
        
        //disable all buttons (access all buttons by their 'tags')
        for i in 1...numEntries {
            let btn = self.view.viewWithTag(i)
            btn?.isUserInteractionEnabled = false
        }
        
        UIView.animate(withDuration: 1, animations: {
            self.replay.alpha = 1
            self.winnerLabel.alpha = 1
        })
    }
    
    func displayTie() {
        winnerLabel.text = "Game is a tie. 😒"
        turnLabel.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.replay.alpha = 1
            self.winnerLabel.alpha = 1
        })
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        //clear entries and enable all buttons
        for i in 1...numEntries {
            let btn = self.view.viewWithTag(i) as! UIButton
            btn.setImage(nil, for: [])
            btn.isUserInteractionEnabled = true
        }
        
        //hide winner display
        replay.alpha = 0
        winnerLabel.alpha = 0
        
        //reset defaults, switch who starts first
        xStartFirst = !xStartFirst
        xTurn = xStartFirst
        resetFlags()
        updateTurnLabel()
        turnLabel.alpha = 1
    }
    
    @IBAction func resetScore(_ sender: UIButton) {
        xWins = 0
        oWins = 0
        xScore.text = String(xWins)
        oScore.text = String(oWins)
        UserDefaults.standard.set(xWins, forKey: "xwins")
        UserDefaults.standard.set(oWins, forKey: "owins")
        playAgain(sender)
    }
    
    func isFull() -> Bool {
        for i in 1...numEntries {
            if tagSetFlags[i] == "" {
                return false
            }
        }
        return true
    }
    
    func resetFlags() {
        for i in 1...numEntries {
            tagSetFlags[i] = ""
        }
    }
    
    func updateTurnLabel() {
        if xTurn {
            turnLabel.text = "X's turn! 😏"
        } else {
            turnLabel.text = "O's turn! 😋"
        }
    }

}

