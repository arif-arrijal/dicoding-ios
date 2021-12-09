import Foundation
import RxSwift
import Alamofire

class MainPresenter: ObservableObject {
    private let disposeBag = DisposeBag()
    private let homeUseCase: HomeUseCase

    let datas = BehaviorSubject<[GameModel]>(value: [])
    let loadingState = PublishSubject<Bool>()
    let errorMessage = PublishSubject<String>()

    var query: String?
    var nextPageUrl: String?
    var totalData: Int = 0

    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }

    private func hasNextPage() -> Bool {
        return nextPageUrl != nil && !nextPageUrl!.isEmpty
    }

    func firstPage() {
        datas.onNext([])
        totalData = 0

        nextPageUrl = nil
        findAll()
    }

    func search(query: String) {
        self.query = query.isEmpty ? nil : query
        firstPage()
    }

    func nextPage() {
        if hasNextPage() {
            findAll()
        }
    }

    func findAll() {
        loadingState.onNext(true)
        homeUseCase.findAll(query: query, pageUrl: nextPageUrl)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                do {
                    var data = try self.datas.value()
                    data.append(contentsOf: result)
                    self.totalData = data.count

                    self.datas.onNext(data)
                } catch {
                    print("error when get data")
                }
            } onError: { error in
                self.errorMessage.onNext(error.localizedDescription)
            } onCompleted: {
                self.loadingState.onNext(false)
            }.disposed(by: disposeBag)
    }
}
