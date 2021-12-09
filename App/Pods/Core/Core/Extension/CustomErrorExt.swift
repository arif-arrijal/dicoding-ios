import Foundation

public enum CustomError: LocalizedError {
    case dataNotFound
    case serverError
    case keyNotFound
    case nameMandatory
    case emailMandatory
    case phoneMandatory

    public var errorDescription: String? {
        switch self {
        case .dataNotFound:
            return "Data tidak ditemukan."
        case .serverError:
            return "Gagal mengambil data. silahkan coba beberapa saat lagi"
        case .keyNotFound:
            return "Key tidak ditemukan"
        case .phoneMandatory:
            return "Nomor telepon tidak boleh kosong."
        case .nameMandatory:
            return "Nama tidak boleh kosong."
        case .emailMandatory:
            return "Email tidak boleh kosong."
        }
    }
}
