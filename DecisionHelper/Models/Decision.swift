struct Decision {
    static func getBestDecision( options: [Option], criteria: [Criteria]) -> Option {
        
        var options = options
        let criteria = Decision.normalizeCriteriaImportanceValue(criteria:criteria)
        
        for index in 0..<options.count {
            for critery in criteria {
                options[index].Points += critery.Importance * critery.OptionRank[options[index].Title]!
               
                print("\(critery.Importance) * \(critery.OptionRank[options[index].Title]!) = \(critery.Importance * critery.OptionRank[options[index].Title]!)")
            }
            options[index].Points = (options[index].Points * 1000).rounded() / 1000
            print("\(options[index].Title) количество очков: \(options[index].Points)")
        }
        
        options = options.sorted { (lhs: Option, rhs: Option) -> Bool in
            return lhs.Points < rhs.Points
        }
        
        return options[options.count - 1]
    }
    
    private static func normalizeCriteriaImportanceValue(criteria: [Criteria]) -> [Criteria] {
        var criteria = criteria
        var maxImportanceValue: Double = 0
        
        for critery in criteria {
            maxImportanceValue += critery.Importance
        }
        
        for index in 0..<criteria.count {
            criteria[index].Importance = criteria[index].Importance / maxImportanceValue
        }
        
        return criteria
    }
    
}
