//
//  FriendContactsController.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 21/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class FriendContactsController: UITableViewController, UISearchBarDelegate {
    //MARK: - жизненный цикл FriendContactsController
    let cellId = "cellId"
    var filtredFriendContact = [FriendsContact]()
    var friendContact = [FriendsContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        let name = NSNotification.Name(rawValue: placeHolders().rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(updateContacts), name: name, object: nil)
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationItem.titleView = searchBar
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.systemFont(ofSize: 14)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.systemFont(ofSize: 14)
        
        tableView.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: placeHolders().leftBarButtonTitle, style: .plain, target: self, action: #selector(HandleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: placeHolders().rightBarButtonTitle, style: .plain, target: self, action: #selector(HandleAdd))
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.title = "Друзья"
        tableView.register(FriendsContactsCell.self, forCellReuseIdentifier: cellId)
        tableView.keyboardDismissMode = .onDrag
        fetchAllContacts()
    }
    //данный метод указывает колличесвто ячеек на контроллере, которые получаются в методе fetchContacts а так же сортируеться в методе поисковой строки
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredFriendContact.count
    }
    //Регистрация кастомного cell класса для FriendContactsController, а так же передаем значения словаря с контактами на кастомный cell класс
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendsContactsCell
        cell.friendsContacts = filtredFriendContact[indexPath.item]
        return cell
    }
    // установление рзмера ячеек для FriendContactsController
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightForCell = 95
        return CGFloat(heightForCell)
    }
    // создание функции удаления конткретного контакта из базы данных
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let friendContacts = filtredFriendContact[indexPath.item]
        guard let contactId = friendContacts.id else {return}
        Database.database().reference().child("Friends_Contacts").child(uid).child(contactId).removeValue()
        self.filtredFriendContact.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    // функция перемещения пользователя на экран детализированного контакта с передачей данных конкретного контакта черех индекс ячейки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friendsDetailViewController = FriendsDetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
        friendsDetailViewController.friendsContact = filtredFriendContact[indexPath.item]
        navigationController?.pushViewController(friendsDetailViewController, animated: true)
    }
    //MARK: - создание эелементов интерфейса пользователя
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Введите фамилию"
        sb.delegate = self
        return sb
    }()
    //MARK: - создание функций
    //Функция поиска усли поисковый запрос пустой уравнивает значение словаря filtredFriendContact с значениями словаря friendContact, но при наличии поискового запроса проверяет запрос и фамилию в базе данных для контактов и выводит все совпадения
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filtredFriendContact = friendContact
        } else {
            filtredFriendContact = self.friendContact.filter { (contact) -> Bool in
                return contact.surName.lowercased().contains(searchText.lowercased())
            }
        }
        self.tableView.reloadData()
    }
    // функция загрузки данных из базы и помещение значений в словари
    func fetchContacts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child(placeHolders().friendContactsTableName).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            self.tableView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else {return}
                var contacts = FriendsContact(dictionary: dictionary)
                contacts.id = key
                self.friendContact.append(contacts)
                self.friendContact.sort(by: { (jc1, jc2) -> Bool in
                    return jc1.surName.compare(jc2.surName) == .orderedAscending
                })
                
            })
            self.filtredFriendContact = self.friendContact
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //функция которая инициализируется при ручном обновлении контроллера удаляя все данные с контроллера и заного их загружая
    @objc func handleRefresh() {
        friendContact.removeAll()
        fetchAllContacts()
    }
    // 2 следующии функции просто убирают дублирование
    func fetchAllContacts() {
        fetchContacts()
    }
    
    @objc func updateContacts() {
        handleRefresh()
    }
    // функция перемещения пользователя на экран создания контакта
    @objc func HandleAdd() {
        let crateContactsController = CreatContactController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(crateContactsController, animated: true)
    }
    // функция выхода из, аккаунта вывод alert controller и перемещение пользователя на экран авторизации
    @objc func HandleLogOut() {
        let alertContoroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertContoroller.addAction(UIAlertAction(title: "Выход", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let logincontroller = SignInController()
                self.present(logincontroller, animated: true, completion: nil)
            } catch let singOutErr {
                print("Failed to sing out", singOutErr)
            }
        }))
        alertContoroller.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alertContoroller, animated: true, completion: nil)
    }
    
}
