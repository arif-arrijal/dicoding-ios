import UIKit
import RxSwift
import RxCocoa

class FavoritesController: BaseUIController {
    private let bag = DisposeBag()
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var presenter: FavoritesPresenter?
    var selectedId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindListener()
        bindTableView()
        gameTableView.rx.setDelegate(self).disposed(by: bag)
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter?.findAll()

    }

    func initView() {
        searchBar.delegate = self
        gameTableView.register(GameTableViewCell.getNib(), forCellReuseIdentifier: GameTableViewCell.identifier)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFromFavorites" {
            if let destination = segue.destination as? DetailController {
                destination.selectedId = selectedId
            }
        }
    }

    func bindListener() {
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

    func bindTableView() {
        gameTableView.register(GameTableViewCell.getNib(), forCellReuseIdentifier: GameTableViewCell.identifier)
        presenter?
            .data
            .bind(to: gameTableView.rx.items(
                    cellIdentifier: GameTableViewCell.identifier,
                    cellType: GameTableViewCell.self)) { (_, item, cell) in
                cell.configureCell(item)
        }.disposed(by: bag)

        gameTableView.rx.modelSelected(GameModel.self).subscribe(onNext: { item in
            self.selectedId = item.gameId
            self.performSegue(withIdentifier: "showDetailFromFavorites", sender: nil)
        }).disposed(by: bag)
    }
}

/*
 * Extension list
 **/
extension FavoritesController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.findAll(query: searchText)
    }
}

extension FavoritesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
