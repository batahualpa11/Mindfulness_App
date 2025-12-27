import UIKit

/// Reusable sliding component that accepts an array of `AdaptiveCardModel`.
/// - Supports swipe gestures and left/right buttons.
final class SlidingCardView: UIView {
    // Public callback when a card's button is tapped
    var onCardButtonTap: ((AdaptiveCardModel) -> Void)?

    private var cards: [AdaptiveCardModel] = []
    private var cardViews: [CardView] = []
    private var currentIndex: Int = 0

    // UI
    private let leftButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("‹", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let rightButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("›", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()

    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.pageIndicatorTintColor = .secondaryLabel
        pc.currentPageIndicatorTintColor = .systemMint
        return pc
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(containerView)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(pageControl)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44),
            containerView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -8),

            leftButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),

            rightButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            pageControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 24)
        ])

        leftButton.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)

        // Swipe gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        addGestureRecognizer(swipeRight)
    }

    // MARK: - Public
    /// Set cards and build views.
    func setCards(_ models: [AdaptiveCardModel]) {
        // clear existing
        cardViews.forEach { $0.removeFromSuperview() }
        cardViews.removeAll()
        cards = models
        pageControl.numberOfPages = models.count
        currentIndex = 0

        // create views lazily
        for model in models {
            let cv = CardView()
            cv.translatesAutoresizingMaskIntoConstraints = false
            cv.configure(with: model.image(), title: model.title, description: model.description)
            cv.onButtonTap = { [weak self] in
                guard let self = self else { return }
                self.onCardButtonTap?(model)
            }
            containerView.addSubview(cv)
            NSLayoutConstraint.activate([
                cv.topAnchor.constraint(equalTo: containerView.topAnchor),
                cv.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                cv.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                cv.heightAnchor.constraint(equalTo: containerView.heightAnchor)
            ])
            cardViews.append(cv)
        }

        // position views horizontally
        for (i, cv) in cardViews.enumerated() {
            if i == 0 {
                cv.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            } else {
                cv.leadingAnchor.constraint(equalTo: cardViews[i-1].trailingAnchor).isActive = true
            }
        }

        // ensure trailing anchor for last
        if let last = cardViews.last {
            last.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        }

        updateButtonsVisibility()
        layoutIfNeeded()
    }

    // MARK: - Actions
    @objc private func didTapLeft() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        slideTo(index: currentIndex, direction: .right)
    }

    @objc private func didTapRight() {
        guard currentIndex < max(0, cards.count - 1) else { return }
        currentIndex += 1
        slideTo(index: currentIndex, direction: .left)
    }

    @objc private func didSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            didTapRight()
        case .right:
            didTapLeft()
        default:
            break
        }
    }

    private enum SlideDirection {
        case left, right
    }

    private func slideTo(index: Int, direction: SlideDirection) {
        guard index >= 0 && index < cardViews.count else { return }

        // Calculate x offset to show the requested index
        let offset = CGFloat(index) * containerView.bounds.width * -1

        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
            self.containerView.subviews.forEach { sub in
                sub.transform = CGAffineTransform(translationX: offset, y: 0)
            }
        }, completion: { _ in
            self.pageControl.currentPage = index
            self.updateButtonsVisibility()
        })
    }

    private func updateButtonsVisibility() {
        leftButton.isHidden = currentIndex == 0
        rightButton.isHidden = currentIndex >= (cards.count - 1)
    }
}
