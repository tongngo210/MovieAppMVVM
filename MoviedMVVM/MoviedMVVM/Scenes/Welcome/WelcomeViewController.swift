import UIKit

final class WelcomeViewController: UIViewController {
    @IBOutlet private weak var welcomeCollectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    private var viewModel = WelcomeViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configView()
    }
}
//MARK: - Configure UI
extension WelcomeViewController {
    private func configViewModel() {
        viewModel.createCell()
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.welcomeCollectionView.reloadData()
            }
        }
    }
    
    private func configView() {
        configCollectionView()
        configPageControl()
    }
    
    private func configPageControl() {
        pageControl.numberOfPages = viewModel.cellViewModels.count
    }
    
    private func configCollectionView() {
        welcomeCollectionView.isPagingEnabled = true
        welcomeCollectionView.delegate = self
        welcomeCollectionView.dataSource = self
        welcomeCollectionView.registerNib(cellName: WelcomeCollectionViewCell.className)
    }
}
//MARK: - WelcomeCollectionCell Delegate
extension WelcomeViewController: WelcomeCollectionViewCellDelegate {
    func didTapButton(cell: WelcomeCollectionViewCell) {
        guard let indexPathItem = welcomeCollectionView.indexPath(for: cell)?.item,
              let appWindow = UIApplication.shared.keyWindow
        else { return }
        
        if indexPathItem < viewModel.cellViewModels.count - 1 {
            let nextIndexPath = IndexPath(item: indexPathItem + 1, section: 0)
            welcomeCollectionView.scrollToItem(at: nextIndexPath,
                                               at: .centeredHorizontally,
                                               animated: true)
            pageControl.currentPage += 1
        } else {
            let mainVC = MainViewController.instantiate(storyboardName: MainViewController.className)
            
            appWindow.rootViewController = mainVC
            appWindow.makeKeyAndVisible()
            UIView.transition(with: appWindow,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}
//MARK: - Collection View Delegate, Datasource
extension WelcomeViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: WelcomeCollectionViewCell.self,
                                                      for: indexPath)
        if viewModel.cellViewModels.indices ~= indexPath.item {
            cell.delegate = self
            let cellViewModel = viewModel.getCellViewModel(at: indexPath)
            cell.fillData(with: cellViewModel)
        }
        
        return cell
    }
}
//MARK: - Collection View Flow Layout
extension WelcomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width,
                          height: collectionView.frame.height)
        return size
    }
}
//MARK: - Scroll View
extension WelcomeViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
}
