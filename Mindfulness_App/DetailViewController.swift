import UIKit

enum DetailType {
    case musicPodcasts
    case breathing
    case loss
    case affirmations
    
    var title: String {
        switch self {
        case .musicPodcasts: return "Music & Podcasts"
        case .breathing: return "Breathing Exercise"
        case .loss: return "Coping with Loss"
        case .affirmations: return "Daily Affirmations"
        }
    }
    
    var content: String {
        switch self {
        case .musicPodcasts:
            return """
            Recommended Playlists:
            1. Calming Classical
            2. Nature Sounds
            3. Meditation Music
            
            Recommended Podcasts:
            1. Mindfulness in Medicine
            2. Healthcare Worker Wellness
            3. Stress Relief for Caregivers
            """
        case .breathing:
            return """
            Follow this simple breathing exercise:
            
            1. Find a quiet place to sit or stand
            2. Close your eyes (if comfortable)
            3. Breathe in slowly through your nose for 4 counts
            4. Hold for 4 counts
            5. Exhale slowly through your mouth for 6 counts
            6. Repeat 5-10 times
            
            Remember: Your well-being matters. Take this moment for yourself.
            """
        case .loss:
            return """
            It's normal to feel grief after losing a patient. Here are some ways to cope:
            
            1. Acknowledge your feelings
            2. Share with trusted colleagues
            3. Write down your thoughts
            4. Remember it's okay to take breaks
            5. Consider joining a support group
            
            If you need professional support, please reach out to our counseling services.
            """
        case .affirmations:
            return """
            Daily Affirmations:
            
            1. I am making a difference in people's lives
            2. I am strong and capable
            3. I choose to be present in this moment
            4. My work has meaning and purpose
            5. I deserve rest and self-care
            6. I am doing my best, and that is enough
            
            Take a moment to breathe and repeat these to yourself.
            """
        }
    }
}

class DetailViewController: UIViewController {
    private let type: DetailType
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(type: DetailType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = type.title
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentLabel)
        
        contentLabel.text = type.content
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
} 