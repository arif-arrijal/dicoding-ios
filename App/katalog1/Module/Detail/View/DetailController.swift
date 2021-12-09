import UIKit
import RxSwift
import RxCocoa

class DetailController: ScrollViewController {
    private let bag = DisposeBag()
    var presenter: DetailPresenter?
    var isAlreadyBookmark = false
    var selectedId: Int?

    @IBOutlet weak var barButtonBookmark: UIBarButtonItem!
    var ivGame = UIImageView()
    var labelTitle = UIViewController.dynamicHeightLabel(text: nil)
    var labelPlatform = UIViewController.dynamicHeightLabel(text: nil)
    var labelGenre = UIViewController.dynamicHeightLabel(text: nil)
    var labelReleaseDate = UIViewController.dynamicHeightLabel(text: nil)
    var labelDeveloper = UIViewController.dynamicHeightLabel(text: nil)
    var labelPublisher = UIViewController.dynamicHeightLabel(text: nil)
    var labelRating = UIViewController.dynamicHeightLabel(text: nil)
    var labelTags = UIViewController.dynamicHeightLabel(text: nil)
    var labelWebsite = UIViewController.dynamicHeightLabel(text: nil)
    var labelDescription = UIViewController.dynamicHeightLabel(text: nil)

    @IBAction func onBookmarkClicked(_ sender: UIBarButtonItem) {
        if self.isAlreadyBookmark {
            confirmationDialog(msg: "Apakah anda yakin ingin menghapus game ini dari daftar favorit?") {
                self.deleteBookmark()
            }
        } else {
            saveBookmark()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindListener()
        presenter?.findOne(gameId: self.selectedId ?? 0)
    }

    private func initView() {
        let defaultTopMargin: CGFloat = 12
        let defaultHorizontalMargin: CGFloat = 14

        let stackPlatform = verticalStackWithLabel(text: "Platform", labelValue: labelPlatform)
        let stackGenre = verticalStackWithLabel(text: "Genre", labelValue: labelGenre)
        let line1Stack = horizontalProportionalStack(arr: [stackPlatform, stackGenre])

        let stackReleaseDate = verticalStackWithLabel(text: "Release Date", labelValue: labelReleaseDate)
        let stackDeveloper = verticalStackWithLabel(text: "Developer", labelValue: labelDeveloper)
        let line2Stack = horizontalProportionalStack(arr: [stackReleaseDate, stackDeveloper])

        let stackPublisher = verticalStackWithLabel(text: "Publisher", labelValue: labelPublisher)
        let stackRating = verticalStackWithLabel(text: "Rating", labelValue: labelRating)
        let line3Stack = horizontalProportionalStack(arr: [stackPublisher, stackRating])

        let stackTag = verticalStackWithLabel(text: "Tags", labelValue: labelTags)
        let stackWebsite = verticalStackWithLabel(text: "Website", labelValue: labelWebsite)

        addSubview(views: [
            (view: ivGame, margins: []),
            (view: labelTitle, margins: [.top(defaultTopMargin), .horizontal(defaultHorizontalMargin)]),
            (view: line1Stack, margins: [.top(defaultTopMargin), .horizontal(defaultHorizontalMargin)]),
            (view: line2Stack, margins: [.top(defaultTopMargin), .horizontal(defaultHorizontalMargin)]),
            (view: line3Stack, margins: [.top(defaultTopMargin), .horizontal(defaultHorizontalMargin)]),
            (view: largeLabel(text: "About This Game"), margins: [.top(20), .horizontal(defaultHorizontalMargin)]),
            (view: labelDescription, margins: [.top(4), .horizontal(defaultHorizontalMargin)]),
            (view: stackTag, margins: [.top(defaultTopMargin), .horizontal(defaultHorizontalMargin)]),
            (view: stackWebsite, margins: [.top(defaultTopMargin), .horizontal(defaultHorizontalMargin), .bottom(10)])
        ])

        [labelDescription, labelPlatform, labelGenre,
         labelReleaseDate, labelDeveloper, labelPublisher,
         labelRating, labelTags, labelWebsite].forEach { label in
            label.font = UIFont.systemFont(ofSize: 14)
         }
        labelTitle.font = UIFont(name: "futura", size: 25)
        labelDescription.textAlignment = .justified
        ivGame.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        ivGame.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16).isActive = true
    }

    func initDetailData(data: GameModel) {
        title = "Detail"
        labelTitle.text = data.name
        labelRating.text = data.completeRating
        labelDescription.text = data.description?.htmlStripped
        labelReleaseDate.text = data.released ?? "TBA"
        labelDeveloper.text = data.developers?.first?.name ?? "-"
        labelPublisher.text = data.publishers?.first?.name ?? "-"
        labelWebsite.text = data.website ?? "-"

        if let genres = data.genres {
            labelGenre.text = genres.map { genre in genre.name }.joined(separator: ", ")
        } else {
            labelGenre.text = "-"
        }

        if let platforms = data.platforms {
            labelPlatform.text = platforms.map { genre in genre.platform.name }.joined(separator: ", ")
        } else {
            labelPlatform.text = "-"
        }

        if let tags = data.tags {
            labelTags.text = tags.map { tag in tag.name }.joined(separator: ", ")
        } else {
            labelTags.text = "-"
        }

        ivGame.sd_setImage(
            with: data.backgroundImage != nil ? URL(string: data.backgroundImage!) : nil,
            placeholderImage: UIImage(named: "image_unavailable")
        )
        initView()
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

        presenter?.data.subscribe(onNext: { data in
            self.initDetailData(data: data)
            self.checkIsAlreadyBookmark()
        }).disposed(by: bag)

        presenter?.alreadyBookmarkState.subscribe(onNext: { state in
            self.isAlreadyBookmark = state

            DispatchQueue.main.async {
                self.barButtonBookmark.image = UIImage(systemName: state ? "bookmark.fill" : "bookmark")
            }
        }).disposed(by: bag)

        presenter?.saveBookmarkState.subscribe(onNext: { state in
            let message = state ?
                "Game berhasil dimasukkan ke daftar favorit" :
                "Game gagal dimasukkan ke daftar favorit. Silahkan coba lagi"
            self.toast(message: message)
            self.checkIsAlreadyBookmark()
        }).disposed(by: bag)

        presenter?.deleteBookmarkState.subscribe(onNext: { state in
            let message = state ?
                "Game berhasil dihapus dari daftar favorit" :
                "Game gagal dihapus dari ke daftar favorit. Silahkan coba lagi"
            self.toast(message: message)
            self.checkIsAlreadyBookmark()
        }).disposed(by: bag)
    }

    func checkIsAlreadyBookmark() {
        if let game = presenter?.toBeSavedGame {
            self.presenter?.checkAlreadyBookmark(gameId: game.gameId)
        }
    }

    func saveBookmark() {
        if let game = presenter?.toBeSavedGame {
            self.presenter?.saveBookmark(data: game)
        }
    }

    func deleteBookmark() {
        if let game = presenter?.toBeSavedGame {
            self.presenter?.deleteBookmark(gameId: game.gameId)
        }
    }
}
