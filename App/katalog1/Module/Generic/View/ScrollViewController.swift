import Foundation
import UIKit

enum MarginType {
    case horizontal(CGFloat = 0)
    case bottom(CGFloat = 0)
    case top(CGFloat = 0)

    var value: CGFloat {
        switch self {
        case .horizontal(let value):
            return value
        case .bottom(let value):
            return value
        case .top(let value):
            return value
        }
    }

    var seqVal: Int {
        switch self {
        case .top:
            return 0
        case .horizontal:
            return 1
        case .bottom:
            return 2
        }
    }

}

class ScrollViewController: BaseUIController {
    private var mainStack: UIStackView!
    private var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStack()
    }

    func addSubview(
        views: [(
            view: UIView,
            margins: [MarginType]
        )]
    ) {
        views.forEach({ child in
            let view = child.view
            let margins = child.margins.sorted(by: { $0.seqVal < $1.seqVal })

            guard !margins.isEmpty else {
                mainStack.addArrangedSubview(view)
                return
            }

            margins.forEach { margin in
                switch margin {
                case .top(let value):
                    let topMargin = EmptySpaceView(sizeHeight: value)
                    mainStack.addArrangedSubview(topMargin)
                case .horizontal(let value):

                    if value != 0 {
                        let rightView = UIView()
                        let leftView = UIView()
                        let hStack = UIStackView(arrangedSubviews: [leftView, view, rightView])

                        mainStack.addArrangedSubview(hStack)

                        rightView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                        leftView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                        NSLayoutConstraint.activate([
                            leftView.widthAnchor.constraint(equalToConstant: value),
                            rightView.widthAnchor.constraint(equalToConstant: value)
                        ])
                    } else {
                        mainStack.addArrangedSubview(view)
                    }
                case .bottom(let value):
                    let bottomMargin = EmptySpaceView(sizeHeight: value)
                    mainStack.addArrangedSubview(bottomMargin)
                }
            }
        })
    }

    private func setupStack() {

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            mainStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

}

class EmptySpaceView: UIView {
    convenience init(sizeHeight: CGFloat) {
        self.init()
        heightAnchor.constraint(equalToConstant: sizeHeight).isActive = true
    }

}
