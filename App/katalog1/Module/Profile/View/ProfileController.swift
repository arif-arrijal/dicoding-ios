import UIKit
import RxSwift
import User

class ProfileController: BaseUIController {
    private let bag = DisposeBag()
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelNomorTelepon: UILabel!
    var presenter: ProfilePresenter?

    @IBAction func goToEditProfile(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editProfile", sender: sender)
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter?.getProfile()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ivProfile.layer.borderWidth = 1.0
        ivProfile.layer.masksToBounds = false
        ivProfile.layer.borderColor = UIColor.white.cgColor
        ivProfile.layer.cornerRadius = 100
        ivProfile.clipsToBounds = true

        bindListener()
    }

    func bindListener() {
        presenter?.data.subscribe(onNext: { data in
            self.labelNama.text = data.name
            self.labelEmail.text = data.email
            self.labelNomorTelepon.text = data.phone
        }).disposed(by: bag)

        presenter?.loadingState.subscribe(onNext: { loading in
            if loading {
                self.showLoader()
            } else {
                self.hideLoader()
            }
        }).disposed(by: bag)

        presenter?.errorMessage.subscribe(onNext: { error in
            self.toast(message: error)
        }).disposed(by: bag)
    }
}
