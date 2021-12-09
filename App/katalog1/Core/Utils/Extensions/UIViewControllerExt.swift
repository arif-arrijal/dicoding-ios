import UIKit
import Toast_Swift

extension UIViewController {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func setImage(url: String, imageView: UIImageView) {
        let imageData = try? Data(contentsOf: URL(string: url)!)
        DispatchQueue.main.async {
            imageView.image = UIImage(data: imageData!)
        }
    }
    func confirmationDialog(msg: String, completion: @escaping() -> Void) {
        let alert = UIAlertController(title: "Konfirmasi", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: { _ in
            completion()
        }))
        alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func toast(message: String, duration: Double = 1) {
        DispatchQueue.main.async {
            self.view.makeToast(message)
        }
    }
    func defaultLabel(text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "futura", size: 14)
        label.textColor = .darkGray
        return label
    }
    func largeLabel(text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "futura", size: 20)
        return label
    }
    func verticalStackWithLabel(text: String, labelValue: UILabel) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [defaultLabel(text: text), labelValue])
        stack.axis = .vertical
        return stack
    }
    func horizontalProportionalStack(arr: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: arr)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.alignment = .top
        return stack
    }
    static func dynamicHeightLabel(text: String?) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }
}
