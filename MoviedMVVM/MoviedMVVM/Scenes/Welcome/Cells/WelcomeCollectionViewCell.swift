import UIKit

protocol WelcomeCollectionViewCellDelegate: AnyObject {
    func didTapButton(cell: WelcomeCollectionViewCell)
}

final class WelcomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var welcomeImageView: UIImageView!
    @IBOutlet private weak var nextButton: UIButton!
    
    weak var delegate: WelcomeCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    private func configCell() {
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        nextButton.backgroundColor = AppColor.orangePeel
    }
    
    func fillData(with viewModel: WelcomeCollectionViewCellViewModel) {
        welcomeImageView.image = viewModel.welcomeImage
        let customTitle = NSMutableAttributedString(string: viewModel.buttonTitle, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        nextButton.setAttributedTitle(customTitle, for: .normal)
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.didTapButton(cell: self)
    }
}
