import UIKit

struct Alert {
    static func getFormatedActionSheetGenerator(title: String, message: String) -> [String: NSMutableAttributedString] {
        var myMutableTitle = NSMutableAttributedString()
        myMutableTitle = NSMutableAttributedString(string: title as String, attributes: [NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 18.0)!])
        myMutableTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:title.count))
        
        let messageStyle = NSMutableParagraphStyle()
        messageStyle.alignment = NSTextAlignment.center
        messageStyle.firstLineHeadIndent = 15.0
        messageStyle.paragraphSpacingBefore = 10.0
        messageStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        var myMutableMessage = NSMutableAttributedString()
        myMutableMessage = NSMutableAttributedString(
            string: message as String,
            attributes: [
                NSAttributedStringKey.font:UIFont(name: "Avenir Next Condensed", size: 15.0)!,
                NSAttributedStringKey.paragraphStyle: messageStyle
            ]
        )
        myMutableMessage.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkText, range: NSRange(location:0,length:message.count))
        
        return [
            "myMutableTitle": myMutableTitle,
            "myMutableMessage": myMutableMessage
        ]
    }
}

