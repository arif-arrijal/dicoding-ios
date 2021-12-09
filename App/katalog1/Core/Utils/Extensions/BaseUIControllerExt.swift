import UIKit

extension BaseUIController {
    func showLoader(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.addChild(self.loader)
            self.loader.view.frame = self.view.frame
            self.view.addSubview(self.loader.view)
            self.loader.didMove(toParent: self)
            completion?()
        }
    }

    func hideLoader(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.loader.willMove(toParent: nil)
            self.loader.view.removeFromSuperview()
            self.loader.removeFromParent()
            completion?()
        }
    }
}
