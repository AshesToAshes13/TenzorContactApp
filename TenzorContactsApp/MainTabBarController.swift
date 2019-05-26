//
//  MainTabBarController.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 21/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    // MARK: - жизененный цикл MainTabBarContoller
    override func viewDidLoad() {
        super.viewDidLoad()
        // данный метод проверяет авторизован ли пользователь если да то таб бар остаеться открытым и пользователь может работать с программой , а в случае если пользователь не авторизован его перемещает на экран авторизации
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let signInController = SignInController()
                self.present(signInController, animated: true, completion: nil)
            }
            return
        }
        // Изменение размера шрифта  для элементов таб бара, но лучше использовать изображения(так как их расположение можно отрегулировать относительно границ таб бара)
        let systemFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)]
        UITabBarItem.appearance().setTitleTextAttributes(systemFontAttributes, for: .normal)
        
        setupNavControllers()
        
    }
    // MARK: - созданеие функции
    // данный метод создает элементы таб бара и задает для них действия
    func setupNavControllers() {
        let jobController = JobContactsController()
        let friendsController = FriendContactsController()
        
        UITabBar.appearance().tintColor = UIColor.black
        
        let jobNavController = UINavigationController(rootViewController: jobController)
        let friendsNavController = UINavigationController(rootViewController: friendsController)
        jobNavController.tabBarItem.title = "Работа"
        friendsNavController.tabBarItem.title = "Друзья"
        
        viewControllers = [jobNavController, friendsNavController]
        
    }
}
