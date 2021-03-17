//
//  ViewController.swift
//  concentration
//
//  Created by ChuckLiu on 23/02/21.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
   private(set) var flipCount = 0 {
        didSet{
            updateFlipCountLabel()
           // flipCountLabel.text = "Flip: \(flipCount)"
        }
    }
    private func updateFlipCountLabel() {
        
        let arrtibutes: [NSAttributedString.Key:Any] = [
            .strokeWidth :5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5683031082, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: arrtibutes)
        flipCountLabel.attributedText = attributedString
    }
    @IBOutlet weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        
        if let cardNumber = cardButtons.firstIndex(of:sender){
            
            game.chooseCard(at: cardNumber)
            
            print("cardNumber = \(cardNumber)")
//            flipCard(withEmoji: emohiChoices[cardNumber], on: sender)
            updateViewFromModel()
        }else{
            print("choosen card was not in cardbuttons")
        }
    }
    
    func updateViewFromModel() {
        if cardButtons != nil{
            for index in cardButtons.indices{
             
                    let button = cardButtons[index]
                    let card = game.cards[index]
                    if card.isFaceUp{
                        button.setTitle(emoji(for: card), for: UIControl.State.normal)
                        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    } else {
                        button.setTitle("", for: UIControl.State.normal)
                        button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1):#colorLiteral(red: 1, green: 0.5683031082, blue: 0, alpha: 1)
                    }
                }
        }
        
           
        
    }
    
    func flipCard(withEmoji emoji:String, on button: UIButton) {
            print("flipcard")
        if button.currentTitle == emoji{
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5683031082, blue: 0, alpha: 1)
        }
        else{
            button.setTitle(emoji, for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        }
    }
    
    var theme: String? {
        didSet {
            emohiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    
    
//   private var emohiChoices=["😃","👻","👻","👩‍🔧","🦷","😈","😎","🐨","🐤","🦋","🐷","🥑"]
    private var emohiChoices="😃👻👻👩‍🔧🦷😈😎🐨🐤🦋🐷🥑"
  private  var emoji = [Card:String]()
  private  func emoji(for card: Card) -> String {
        if emoji[card] == nil, emohiChoices.count > 0 {
            let randomStringIndex =  emohiChoices.index(emohiChoices.startIndex, offsetBy: emohiChoices.count.arc4Random)
            emoji[card] = String(emohiChoices.remove(at: randomStringIndex))
            
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4Random: Int{
        if self > 0 {
            return Int( arc4random_uniform( UInt32(self)))
        }else if self < 0 {
            return -Int( arc4random_uniform( UInt32(abs(self))))
        } else{
            return 0
        }
        
    }
    
}
