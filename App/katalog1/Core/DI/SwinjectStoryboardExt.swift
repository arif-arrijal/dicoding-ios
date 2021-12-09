import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer.register(LocalDataSource.self) { _ in
            LocalDataSource.sharedInstance()
        }
        defaultContainer.register(RemoteDataSource.self) { _ in
            RemoteDataSource.sharedInstance(NetworkService.shared)
        }
        defaultContainer.register(GameRepository.self) { reg in
            GameRepository.sharedInstance(
                reg.resolve(LocalDataSource.self)!,
                reg.resolve(RemoteDataSource.self)!
            )
        }
        defaultContainer.register(UserRepository.self) { reg in
            UserRepository.sharedInstance(
                reg.resolve(LocalDataSource.self)!
            )
        }

        // Interactor injection
        // --------------------
        defaultContainer.register(HomeInteractor.self) { reg in
            HomeInteractor(repository: reg.resolve(GameRepository.self)!)
        }
        defaultContainer.register(DetailInteractor.self) { reg in
            DetailInteractor(repository: reg.resolve(GameRepository.self)!)
        }
        defaultContainer.register(FavoritesInteractor.self) { reg in
            FavoritesInteractor(repository: reg.resolve(GameRepository.self)!)
        }
        defaultContainer.register(ProfileInteractor.self) { reg in
            ProfileInteractor(repository: reg.resolve(UserRepository.self)!)
        }
        defaultContainer.register(EditProfileInteractor.self) { reg in
            EditProfileInteractor(repository: reg.resolve(UserRepository.self)!)
        }

        // Presenter injection
        // -------------------
        defaultContainer.register(MainPresenter.self) { reg in
            MainPresenter(homeUseCase: reg.resolve(HomeInteractor.self)!)
        }
        defaultContainer.register(DetailPresenter.self) { reg in
            DetailPresenter(useCase: reg.resolve(DetailInteractor.self)!)
        }
        defaultContainer.register(FavoritesPresenter.self) { reg in
            FavoritesPresenter(useCase: reg.resolve(FavoritesInteractor.self)!)
        }
        defaultContainer.register(ProfilePresenter.self) { reg in
            ProfilePresenter(useCase: reg.resolve(ProfileInteractor.self)!)
        }
        defaultContainer.register(EditProfilePresenter.self) { reg in
            EditProfilePresenter(useCase: reg.resolve(EditProfileInteractor.self)!)
        }

        // UI View Controller injection
        // -------------------
        defaultContainer.storyboardInitCompleted(MainController.self) { resolver, controller in
            controller.presenter = resolver.resolve(MainPresenter.self)
        }
        defaultContainer.storyboardInitCompleted(DetailController.self) { resolver, controller in
            controller.presenter = resolver.resolve(DetailPresenter.self)
        }
        defaultContainer.storyboardInitCompleted(FavoritesController.self) { resolver, controller in
            controller.presenter = resolver.resolve(FavoritesPresenter.self)
        }
        defaultContainer.storyboardInitCompleted(ProfileController.self) { resolver, controller in
            controller.presenter = resolver.resolve(ProfilePresenter.self)
        }
        defaultContainer.storyboardInitCompleted(EditProfileController.self) { resolver, controller in
            controller.presenter = resolver.resolve(EditProfilePresenter.self)
        }

    }
}
