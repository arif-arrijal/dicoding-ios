import UIKit

class GameTableViewCell: UITableViewCell {
    static var identifier = "GameTableViewCell"
    static func getNib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var gameImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(_ selectedData: GameModel) {
        title.text = selectedData.name
        rating.text = "\(selectedData.rating.description)/\(selectedData.ratingTop.description)"

        if let released = selectedData.released {
            releaseDate.text = "Dirilis pada \(released)"
        }

        gameImage.sd_setImage(
            with: selectedData.backgroundImage != nil ? URL(string: selectedData.backgroundImage!) : nil,
            placeholderImage: UIImage(named: "image_unavailable")
        )
    }
}
