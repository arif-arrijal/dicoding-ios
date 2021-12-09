import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class MainController: BaseUIController {
    private let bag = DisposeBag()

    @IBAction func goToProfile(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showProfile", sender: sender)
    }

    @IBAction func goToFavorites(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "favorites", sender: sender)
    }

    @IBOutlet weak var gameTableView: UITableView!
    var selectedId: Int?
    var presenter: MainPresenter?

    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindListener()
        bindTableView()
        gameTableView.rx.setDelegate(self).disposed(by: bag)
        self.presenter?.firstPage()
    }

    func initView() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let destination = segue.destination as? DetailController {
                destination.selectedId = selectedId
            }
        }
    }

    @objc func search() {
        guard let searchText = searchController.searchBar.text else { return }
        self.presenter?.search(query: searchText)
    }

    func bindTableView() {
        gameTableView.register(GameTableViewCell.getNib(), forCellReuseIdentifier: GameTableViewCell.identifier)
        presenter?
            .datas
            .bind(to: gameTableView.rx.items(
                    cellIdentifier: GameTableViewCell.identifier,
                    cellType: GameTableViewCell.self)) { (_, item, cell) in
                cell.configureCell(item)
        }.disposed(by: bag)

        gameTableView.rx.modelSelected(GameModel.self).subscribe(onNext: { item in
            self.selectedId = item.gameId
            self.performSegue(withIdentifier: "showDetail", sender: nil)
        }).disposed(by: bag)
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
}

/*
 * Extension list
 **/

extension MainController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(MainController.search),
            object: nil)
        self.perform(#selector(self.search), with: nil, afterDelay: 0.7)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = presenter?.query
    }
}

extension MainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.nextPage()
    }
}
