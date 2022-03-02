//
//  String_EXT.swift
//
//

import Foundation

extension String {
    func htmlAttributedString() -> NSMutableAttributedString? {
        
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: 14\">%@</span>", self)

        guard let data = modifiedFont.data(using: .unicode) else {
            return nil
        }

        return try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSMutableAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }

    func shortenID() -> String {
        (self.components(separatedBy: "-").last ?? "").uppercased()
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
    
    //"Your password must be between 8 to 16 characters, include uppercase letter, lowercase letter and number."
    //Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number:
    var isValidPassword: Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,16}$")
        return passwordRegex.evaluate(with: self)
    }
    
    func maskPhone() -> String {
    return String(self.enumerated().map { index, char in
        return [self.count - 2, self.count - 1].contains(index) ?
       char : "*"
       })
    }
    
    // guide: input: " a b c " -> output: "abc"
    func trim() -> String {
        return self.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines).trimmingCharacters(in: .whitespaces)
    }
}

extension Date {
    func toString( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
