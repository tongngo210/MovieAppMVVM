import Foundation

final class WelcomeViewControllerViewModel {
    
    var reloadCollectionView: (()->())?
    
    var cellViewModels = [WelcomeCollectionViewCellViewModel]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func createCell() {
        var cellViewModels = [WelcomeCollectionViewCellViewModel]()
        for page in WelcomePage.welcomePages {
            cellViewModels.append(WelcomeCollectionViewCellViewModel(with: page))
        }
        self.cellViewModels = cellViewModels
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> WelcomeCollectionViewCellViewModel {
        return cellViewModels[indexPath.item]
    }
}
