//
//  ContactsController.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 20/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class JobContactsController: UITableViewController, UISearchBarDelegate {
    //MARK: - жизненный цикл JobContactsController
    let cellId = "cellId"
    var fitredJobContacts = [JobContacts]()
    var jobContacts = [JobContacts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: placeHolders().leftBarButtonTitle, style: .plain, target: self, action: #selector(HandleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: placeHolders().rightBarButtonTitle, style: .plain, target: self, action: #selector(HandleAdd))
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationItem.titleView = searchBar
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.systemFont(ofSize: 14)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.systemFont(ofSize: 14)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        let name = NSNotification.Name(rawValue: placeHolders().rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(updateContacts), name: name, object: nil)
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(JobContactCell.self, forCellReuseIdentifier: cellId)
        fetchAllContacts()
    }
    //данный метод указывает колличесвто ячеек на контроллере, которые получаются в методе fetchContacts а так же сортируеться в методе поисковой строки
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fitredJobContacts.count
    }
    //Регистрация кастомного cell класса для JobContactsController, а так же передаем значения словаря с контактами на кастомный cell класс
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JobContactCell
        cell.jobContacts = fitredJobContacts[indexPath.item]
        return cell
    }
    // установление рзмера ячеек для JobContactsController
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightForCell = 125
        return CGFloat(heightForCell)
    }
    // создание функции удаления конткретного контакта из базы данных
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let jobContacts = self.fitredJobContacts[indexPath.item]
        guard let contactId = jobContacts.id else {return}
        Database.database().reference().child("Job_Contacts").child(uid).child(contactId).removeValue()
        self.fitredJobContacts.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    // функция перемещения пользователя на экран детализированного контакта с передачей данных конкретного контакта черех индекс ячейки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobDetailViewController = JobDeatailViewController(collectionViewLayout: UICollectionViewFlowLayout())
        jobDetailViewController.jobContacts = fitredJobContacts[indexPath.item]
        navigationController?.pushViewController(jobDetailViewController, animated: true)
    }
    //MARK: - создание эелементов интерфейса пользователя
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = placeHolders().searchBarPlaceHolder
        sb.delegate = self
        return sb
    }()
    //MARK: - создание функций
    //Функция поиска усли поисковый запрос пустой уравнивает значение словаря fitredJobContacts с значениями словаря jobContacts, но при наличии поискового запроса проверяет запрос и фамилию в базе данных для контактов и выводит все совпадения
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fitredJobContacts = jobContacts
        } else {
            fitredJobContacts = self.jobContacts.filter { (contact) -> Bool in
                return contact.surName.lowercased().contains(searchText.lowercased())
            }
        }
        self.tableView.reloadData()
    }
    // функция загрузки данных из базы и помещение значений в словари
    func fetchContacts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Job_Contacts").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            self.tableView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else {return}
                var contacts = JobContacts(dictionary: dictionary)
                contacts.id = key
                self.jobContacts.append(contacts)
                self.jobContacts.sort(by: { (jc1, jc2) -> Bool in
                    return jc1.surName.compare(jc2.surName) == .orderedAscending
                })
            })
            self.fitredJobContacts = self.jobContacts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //функция которая инициализируется при ручном обновлении контроллера удаляя все данные с контроллера и заного их загружая
    @objc func handleRefresh() {
        jobContacts.removeAll()
        fetchAllContacts()
    }
    // 2 следующии функции просто убирают дублирование
    @objc func updateContacts() {
        handleRefresh()
    }
    
    func fetchAllContacts() {
        fetchContacts()
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
