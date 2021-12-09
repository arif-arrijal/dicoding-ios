import UIKit

class LoadingController: UIViewController {

    var spinner = UIActivityIndicatorView(style: .medium)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        spinner.color = UIColor.white
        spinner.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
