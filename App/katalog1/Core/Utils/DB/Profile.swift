import Foundation

struct Profile {
    static let nameKey = "name"
    static let emailKey = "email"
    static let phoneKey = "phone"

    static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? "Muhamad Arif Ar Rijal"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }
    static var email: String {
        get {
            return UserDefaults.standard.string(forKey: emailKey) ?? "muhamad.arif.arrijal@gmail.com"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: emailKey)
        }
    }
    static var phone: String {
        get {
            return UserDefaults.standard.string(forKey: phoneKey) ?? "087835400004"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: phoneKey)
        }
    }
    static func synchronize() {
            UserDefaults.standard.synchronize()
    }
}
