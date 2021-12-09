import Combine

public class GetListPresenter<Request, Response, Interactor: UseCase>: ObservableObject
where Interactor.Request == Request, Interactor.Response == [Response] {
    private let _useCase: Interactor
    
    public init(useCase: Interactor) {
        _useCase = useCase
    }
}
