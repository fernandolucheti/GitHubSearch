# GitHubSearch


Lembre-se de adicionar a classe User.swift com o usuário e senha do git para autenticar as requisições

private let _userSharedInstance = User()
class User {
    var username = "asd"
    var password = "asd"
    static let sharedInstance = User()
    func setUser(nome:String,senha:String){
        self.username = nome
        self.password = senha
    }
}


