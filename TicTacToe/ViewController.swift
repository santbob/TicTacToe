//
//  ViewController.swift
//  TicTacToe
//
//  Created by srao13  on 2/6/20.
//  Copyright © 2020 Santbob Inc. All rights reserved.
//

import UIKit



enum Player: Int {
    case none, one, two
}

class Spot {
    var id: Int
    var filedBy: Player
    
    init(id: Int) {
        self.id = id
        self.filedBy = Player.none;
    }
}


class ViewController: UIViewController {
    
    let possiblities = [
        [11,12,13],
        [21,22,23],
        [31,32,33],
        [11,21,31],
        [12,22,32],
        [13,23,33],
        [11,22,33],
        [13,22,31]
    ];
    var spots: [Int:Spot] = [:];
    var currentPlayer: Player = Player.none;
    var spotsFilled:Int = 0
    
    @IBOutlet weak var tictactoeView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var restButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetGame()
    }
    
    func checkResult(player: Player, currentSpot: Int) {
        let result = possiblities.filter { (sequence) -> Bool in
            return sequence.contains(currentSpot) && sequence.allSatisfy({ (spotId) -> Bool in
                self.spots[spotId]?.filedBy == player
            })
        }
        
        if result.count > 0 {
            resultLabel.text = "Player \(currentPlayer) has won!"
        } else {
            if self.spotsFilled == 9 {
                resultLabel.text = "Its a Tie"
            } else {
                switchPlayer()
            }
        }
    }
    
    func switchPlayer() {
        self.currentPlayer = currentPlayer == Player.one ? Player.two : Player.one
        self.resultLabel.text = "Player \(currentPlayer): Its your Turn!"
    }
    
    
    @IBAction func resetGame() {
        //setting defaults
        spots = [:]
        spotsFilled = 0;
        currentPlayer = Player.none;
        
        // reseting the models
        for r in 1...3 {
            for c in 1...3 {
                let id = (r * 10) + c
                spots[id] = Spot(id: id)
            }
        }
        //reset all views to original state.
        for subview in tictactoeView.subviews {
            if let subview = subview as? UIButton {
                subview.setBackgroundImage(UIImage.init(systemName: "circle"), for: UIControl.State.normal)
            }
        }
        switchPlayer()
    }
    
    @IBAction func onTap(_ sender: UIButton) {
        let spotId = sender.tag;
        guard let puck = spots[sender.tag], puck.filedBy == Player.none else { return }
        
        self.spots[sender.tag]?.filedBy = currentPlayer;
        
        let imageName = (self.currentPlayer == Player.one) ? "xmark.circle.fill" : "checkmark.circle.fill"
        
        sender.setBackgroundImage(UIImage.init(systemName: imageName), for: UIControl.State.normal)
        self.spotsFilled += 1;
        checkResult(player:currentPlayer, currentSpot: spotId)
    }
}

