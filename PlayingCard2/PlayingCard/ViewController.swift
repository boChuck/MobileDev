//
//  ViewController.swift
//  PlayingCard
//
//  Created by ChuckLiu on 1/03/21.
//

import UIKit

struct Constants {
    static var flipCardAnimationDuration: TimeInterval = 0.6
    static var matchCardAnimationDuration: TimeInterval = 0.6
    static var matchCardAnimationScaleUp: CGFloat = 3.0
    static var matchCardAnimationScaleDown: CGFloat = 0.1
    static var behaviorResistance: CGFloat = 0
    static var behaviorElasticity: CGFloat = 1.0
    static var behaviorPushMagnitudeMinimum: CGFloat = 0.5
    static var behaviorPushMagnitudeRandomFactor: CGFloat = 1.0
    static var cardsPerMainViewWidth: CGFloat = 5
}

class ViewController: UIViewController {

    private var deck = PlayingCardDeck()

    @IBOutlet var cardViews: [PlayingCardView]!
    
    private lazy var animator = UIDynamicAnimator(referenceView: view)
    private lazy var cardBehavior = CardBehavior(in: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count + 1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        let cardScaleFactor = (view.bounds.width / Constants.cardsPerMainViewWidth)/cardViews[0].frame.width
        for cardView in cardViews {
            cardView.frame.size.width *= cardScaleFactor
            cardView.frame.size.height *= cardScaleFactor
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4Random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)
        }
    }
    
    private var faceUpCardViews: [PlayingCardView]  {
        return cardViews.filter { cardView in
            !matchedCardViews.contains(cardView) && cardView.isFaceUp == true
        }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 && faceUpCardViews[0] == faceUpCardViews[1]
    }
    
    private var matchedCardViews: Set<PlayingCardView> = []
    private var lastChoosenCardview: PlayingCardView?
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            if let chosenCardView = sender.view as? PlayingCardView, faceUpCardViews.count < 2 {
                lastChoosenCardview = chosenCardView
                cardBehavior.removeItem(chosenCardView)
                chosenCardView.flipCard(completion: { [unowned self] in
                    if self.faceUpCardViewsMatch {
                        self.faceUpCardViews.forEach { cardView in
                            self.matchedCardViews.insert(cardView)
                            cardView.cardsMatchAnimation(completion: nil)
                        }
                    } else if self.faceUpCardViews.count == 2 && chosenCardView == self.lastChoosenCardview {
                        self.faceUpCardViews.forEach { cardView in
                            cardView.flipCard(completion: { [unowned self] in
                                self.cardBehavior.addItem(cardView)
                            })
                        }
                    } else if !chosenCardView.isFaceUp {
                        self.cardBehavior.addItem(chosenCardView)
                    }
                })
            }
        default: break
        }
    }
}

