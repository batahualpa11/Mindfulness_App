//
//  ViewController.swift
//  Mindfulness_App
//
//  Created by Brian Atahualpa on 12/3/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let row1StackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let row2StackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCards()
    }
    
    private func setupUI() {
        title = "Mindfulness"
        view.backgroundColor = .systemMint.withAlphaComponent(0.3)
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(row1StackView)
        stackView.addArrangedSubview(row2StackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        // Set a fixed height for the rows to ensure proper card sizing
        row1StackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        row2StackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setupCards() {
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
        
        row1StackView.addArrangedSubview(musicCard)
        row1StackView.addArrangedSubview(breathingCard)
        row2StackView.addArrangedSubview(lossCard)
        row2StackView.addArrangedSubview(affirmationsCard)
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

