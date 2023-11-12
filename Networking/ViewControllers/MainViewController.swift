//
//  MainViewController.swift
//  Networking
//
//  Created by Alexey Efimov on 21/08/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import UIKit

enum Link {
    case imageURL
    case courseURL
    case coursesURL
    case aboutUsURL
    case aboutUsURL2
    
    var url: URL {
        switch self {
        case .imageURL:
            return URL(string: "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg")!
        case .courseURL:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_course")!
        case .coursesURL:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_courses")!
        case .aboutUsURL:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_website_description")!
        case .aboutUsURL2:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields")!
        }
    }
}

enum UserAction: CaseIterable {
    case showImage
    case fetchCourse
    case fetchCourses
    case aboutSwiftBook
    case aboutSwiftBook2
    case showCourses
    
    var title: String {
        switch self {
        case .showImage:
            return "Show Image"
        case .fetchCourse:
            return "Fetch Course"
        case .fetchCourses:
            return "Fetch Courses"
        case .aboutSwiftBook:
            return "About SwiftBook"
        case .aboutSwiftBook2:
            return "About SwiftBook 2"
        case .showCourses:
            return "Show Courses"
        }
    }
}

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "You can see the results in the Debug area"
        case .failed:
            return "You can see error in the Debug area"
        }
    }
}

var feed = "https://random-data-api.com/api/v2/users?size=10&is_xml=true" /*feed с ссылкой, не знаю где правильнее ее хранить оставил тут, JSON приходит корректно*/

final class MainViewController: UICollectionViewController {
    private let userActions = UserAction.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printOurData()
    }


    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath)
        guard let cell = cell as? UserActionCell else { return UICollectionViewCell() }
        cell.userActionLabel.text = userActions[indexPath.item].title
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .showImage: performSegue(withIdentifier: "showImage", sender: nil)
        case .fetchCourse: fetchCourse()
        case .fetchCourses: fetchCourses()
        case .aboutSwiftBook: fetchInfoAboutUs()
        case .aboutSwiftBook2: fetchInfoAboutUsWithEmptyFields()
        case .showCourses: performSegue(withIdentifier: "showCourses", sender: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Private Methods
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

// MARK: - Networking
extension MainViewController {
    private func fetchCourse() {
        URLSession.shared.dataTask(with: Link.courseURL.url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let course = try decoder.decode(Course.self, from: data)
                print(course)
                self?.showAlert(withStatus: .success)
            } catch let error {
                self?.showAlert(withStatus: .failed)
                print(error.localizedDescription)
            }
            
            
        }.resume()
    }
    
    private func fetchCourses() {
        URLSession.shared.dataTask(with: Link.coursesURL.url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let courses = try decoder.decode([Course].self, from: data)
                print(courses)
                self?.showAlert(withStatus: .success)
            } catch let error {
                self?.showAlert(withStatus: .failed)
                print(error.localizedDescription)
            }
            
            
        }.resume()
    }
    
    private func fetchInfoAboutUs() {
        URLSession.shared.dataTask(with: Link.aboutUsURL.url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let sbInfo = try decoder.decode(SwiftbookInfo.self, from: data)
                print(sbInfo)
                self?.showAlert(withStatus: .success)
            } catch let error {
                self?.showAlert(withStatus: .failed)
                print(error.localizedDescription)
            }
            
            
        }.resume()
    }
    
    private func fetchInfoAboutUsWithEmptyFields() {
        URLSession.shared.dataTask(with: Link.aboutUsURL2.url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let sbInfo = try decoder.decode(SwiftbookInfo.self, from: data)
                print(sbInfo)
                self?.showAlert(withStatus: .success)
            } catch let error {
                self?.showAlert(withStatus: .failed)
                print(error)
            }
            
        }.resume()
    }
    
    private func printOurData() {
        guard let ourLink: URL = URL(string: feed) else //feed хранит ссылку
        {return}
        URLSession.shared.dataTask(with: ourLink) { data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let jsonDecoder = JSONDecoder()
            
            do {
                let person = try jsonDecoder.decode([Person].self, from: data)
                print(person)
            } catch let error {
                print(error.localizedDescription)
            }
            
        }.resume()
            
    }
}
