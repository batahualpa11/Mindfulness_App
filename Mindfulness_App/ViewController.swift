//
//  ViewController.swift
//  Mindfulness_App
//
//  Created by Brian Atahualpa on 12/3/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let slider = SlidingCardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAdaptiveCardsFromJSONAndSetup()
    }
    
    private func setupUI() {
        title = "Mindfulness"
        view.backgroundColor = .systemMint.withAlphaComponent(0.3)

        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)

        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            slider.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.7)
        ])

        // handle card button taps
        slider.onCardButtonTap = { [weak self] model in
            guard let self = self else { return }
            let dt = self.detailType(from: model.type)
            switch dt {
            case .musicPodcasts: self.navigateToMusicPodcasts()
            case .breathing: self.navigateToBreathing()
            case .loss: self.navigateToLoss()
            case .affirmations: self.navigateToAffirmations()
            }
        }
    }
    
    private func loadAdaptiveCardsFromJSONAndSetup() {
        // Example JSON array (in real use this would come from a server or local file)
        let json = """
        [
          { "id": "1", "title": "MUSIC/PODCASTS", "description": "Help users feel understood and empathized with", "imageSystemName": "headphones", "type": "musicPodcasts" },
          { "id": "2", "title": "DIFFICULT INTERACTION", "description": "A short, guided breathing exercise to help calm the nervous system after a stressful interaction", "imageSystemName": "lungs.fill", "type": "breathing" },
          { "id": "3", "title": "COPING WITH LOSS", "description": "A reflection exercise to process emotions after a patient passes away", "imageSystemName": "heart.fill", "type": "loss" },
          { "id": "4", "title": "AFFIRMATIONS", "description": "For busy, on-the-go workers", "imageSystemName": "quote.bubble.fill", "type": "affirmations" }
        ]
        """

        let data = Data(json.utf8)
        do {
            let models = try JSONDecoder().decode([AdaptiveCardModel].self, from: data)
            slider.setCards(models)
        } catch {
            // Fallback to programmatic creation if decoding fails
            let fallback = [
                AdaptiveCardModel(id: "1", title: "MUSIC/PODCASTS", description: "Help users feel understood and empathized with", imageSystemName: "headphones", type: "musicPodcasts"),
                AdaptiveCardModel(id: "2", title: "DIFFICULT INTERACTION", description: "A short breathing exercise", imageSystemName: "lungs.fill", type: "breathing"),
                AdaptiveCardModel(id: "3", title: "COPING WITH LOSS", description: "Reflection exercise", imageSystemName: "heart.fill", type: "loss"),
                AdaptiveCardModel(id: "4", title: "AFFIRMATIONS", description: "For busy, on-the-go workers", imageSystemName: "quote.bubble.fill", type: "affirmations")
            ]
            slider.setCards(fallback)
        }
    }

    private func detailType(from typeString: String?) -> DetailType {
        switch typeString {
        case "musicPodcasts": return .musicPodcasts
        case "breathing": return .breathing
        case "loss": return .loss
        case "affirmations": return .affirmations
        default: return .musicPodcasts
        }
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

