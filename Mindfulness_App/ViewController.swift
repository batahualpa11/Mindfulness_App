//
//  ViewController.swift
//  Mindfulness_App
//
//  Created by Brian Atahualpa on 12/3/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let cardContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pageIndicator: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 4
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .gray
        pc.currentPageIndicatorTintColor = .systemMint
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private let swipeHintLabel: UILabel = {
        let label = UILabel()
        label.text = "← Swipe right or left →"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var cards: [(card: CardView, type: DetailType)] = []
    private var currentCardIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createCards()
        displayCurrentCard()
    }
    
    private func setupUI() {
        title = "Mindfulness"
        view.backgroundColor = .systemMint.withAlphaComponent(0.3)
        
        view.addSubview(cardContainerView)
        view.addSubview(pageIndicator)
        view.addSubview(swipeHintLabel)
        
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            cardContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardContainerView.heightAnchor.constraint(equalToConstant: 500),
            
            pageIndicator.topAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: 30),
            pageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            swipeHintLabel.topAnchor.constraint(equalTo: pageIndicator.bottomAnchor, constant: 20),
            swipeHintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swipeHintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            swipeHintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Add swipe gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    private func createCards() {
        // Music/Podcasts Card
        let musicCard = CardView()
        musicCard.configure(
            with: UIImage(systemName: "headphones"),
            title: "MUSIC/PODCASTS",
            description: "Help users feel understood and empathized with"
        )
        musicCard.onButtonTap = { [weak self] in
            self?.navigateToMusicPodcasts()
        }
        cards.append((card: musicCard, type: .musicPodcasts))
        
        // Breathing Exercise Card
        let breathingCard = CardView()
        breathingCard.configure(
            with: UIImage(systemName: "lungs.fill"),
            title: "DIFFICULT INTERACTION",
            description: "A short, guided breathing exercise to help calm the nervous system after being yelled at or facing a challenging patient/family interaction"
        )
        breathingCard.onButtonTap = { [weak self] in
            self?.navigateToBreathing()
        }
        cards.append((card: breathingCard, type: .breathing))
        
        // Coping with Loss Card
        let lossCard = CardView()
        lossCard.configure(
            with: UIImage(systemName: "heart.fill"),
            title: "COPING WITH LOSS",
            description: "A reflection exercise to process emotions after a patient passes away, helping users acknowledge their grief without suppressing it"
        )
        lossCard.onButtonTap = { [weak self] in
            self?.navigateToLoss()
        }
        cards.append((card: lossCard, type: .loss))
        
        // Affirmations Card
        let affirmationsCard = CardView()
        affirmationsCard.configure(
            with: UIImage(systemName: "quote.bubble.fill"),
            title: "AFFIRMATIONS",
            description: "For busy, on-the-go workers"
        )
        affirmationsCard.onButtonTap = { [weak self] in
            self?.navigateToAffirmations()
        }
        cards.append((card: affirmationsCard, type: .affirmations))
    }
    
    private func displayCurrentCard() {
        // Remove previous card if any
        cardContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        let currentCard = cards[currentCardIndex].card
        cardContainerView.addSubview(currentCard)
        
        NSLayoutConstraint.activate([
            currentCard.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            currentCard.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            currentCard.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            currentCard.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor)
        ])
        
        pageIndicator.currentPage = currentCardIndex
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right:
            // Swipe right goes to previous card
            if currentCardIndex > 0 {
                currentCardIndex -= 1
                animateCardTransition()
            }
        case .left:
            // Swipe left goes to next card
            if currentCardIndex < cards.count - 1 {
                currentCardIndex += 1
                animateCardTransition()
            }
        default:
            break
        }
    }
    
    private func animateCardTransition() {
        UIView.transition(
            with: cardContainerView,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                self.displayCurrentCard()
            }
        )
    }
    
    private func navigateToMusicPodcasts() {
        let vc = DetailViewController(type: .musicPodcasts)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToBreathing() {
        let vc = DetailViewController(type: .breathing)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToLoss() {
        let vc = DetailViewController(type: .loss)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAffirmations() {
        let vc = DetailViewController(type: .affirmations)
        navigationController?.pushViewController(vc, animated: true)
    }
}

