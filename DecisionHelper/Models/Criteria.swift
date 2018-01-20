enum Importance: Double {
    case level1, level2, level3, level4
}

struct Criteria {
    private let title: String
    private var importance: Double
    private var optionRank = [String: Double]()
    
    init(title: String, importance: Importance) {
        self.title = title
        
        switch importance {
        case .level1:
            self.importance = 0.25
        case .level2:
            self.importance = 0.5
        case .level3:
            self.importance = 0.75
        case .level4:
            self.importance = 1
        }
    }
    
    var Title: String {
        get {
            return title
        }
    }
    
    var Importance: Double {
        get {
            return self.importance
        }
        set(value) {
            self.importance = value
        }
    }
    
    var OptionRank: [String: Double] {
        get {
            return self.optionRank
        }
        set(optionRank) {
            self.optionRank = optionRank
        }
    }
}
