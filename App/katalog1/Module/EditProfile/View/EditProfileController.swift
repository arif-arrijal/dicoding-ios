import UIKit
import RxSwift
import User

class EditProfileController: BaseUIController {
    private let bag = DisposeBag()

    @IBOutlet weak var tfNama: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfNomorTelepon: UITextField!

    var presenter: EditProfilePresenter?

    @IBAction func onBtnSimpanClicked(_ sender: UIButton) {
        if let name = tfNama.text, let email = tfEmail.text, let phone = tfNomorTelepon.text {
            presenter?.saveProfile(name, email, phone)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindListener()
        presenter?.getProfile()

    }

    func bindListener() {
        presenter?.data.subscribe(onNext: { data in
            self.tfNama.text = data.name
            self.tfEmail.text = data.email
            self.tfNomorTelepon.text = data.phone
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

        presenter?.saveProfileState.subscribe(onNext: { state in
            if state {
                self.toast(message: "Profil berhasil disimpan.")
            }

        }).disposed(by: bag)
    }
}
