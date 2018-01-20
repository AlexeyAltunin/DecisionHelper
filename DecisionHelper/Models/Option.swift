struct Option {
    private let title: String
    private var points: Double = 0
    
    init(title: String) {
        self.title = title
    }
    
    var Title: String {
        get {
            return title
        }
    }
    
    var Points: Double {
        get {
            return points
        }
        set(points) {
            self.points = points
        }
    }
}

