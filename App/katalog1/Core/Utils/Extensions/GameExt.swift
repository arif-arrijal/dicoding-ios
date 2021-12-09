extension GameModel {
    var fullRating: String {
        return "\(self.rating.description)/\(self.ratingTop.description)"
    }
    var completeRating: String {
        return "\(self.fullRating) Dari \(self.ratingsCount.description) Penilaian"
    }
}
