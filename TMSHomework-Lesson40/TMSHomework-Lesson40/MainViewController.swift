//
//  ViewController.swift
//  TMSHomework-Lesson40
//
//  Created by Наталья Мазур on 7.05.24.
//

import UIKit
import FirebaseAnalytics

class MainViewController: UIViewController {

    enum Constants {
        static let yellowCircleSide: CGFloat = 300
        static let redCircleSide: CGFloat = 300
        static let littleYellowCircleSide: CGFloat = 170
        static let profilePictureSide: CGFloat = 180
        static let buttonsHeight: CGFloat = 50
        static let buttonsCornerRadius: CGFloat = 25
    }
    
    let yellowCircle: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
    
    let redCircle: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
    
    let greetingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 30)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let littleYellowCircle: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
    
    let buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let teaDiaryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.buttonsCornerRadius
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.setTitle("Мой чайный дневник", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemRed, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        
        button.configuration = UIButton.Configuration.plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0)
        return button
    }()
    
    let friendsButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.buttonsCornerRadius
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.setTitle("Мои друзья", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemRed, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        
        button.configuration = UIButton.Configuration.plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0)
        return button
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.buttonsCornerRadius
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.setTitle("Редактировать профиль", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemRed, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        
        button.configuration = UIButton.Configuration.plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0)
        return button
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.buttonsCornerRadius
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    var profilePicture = UIImageView(image: UIImage(named: "defaultAvatar"))
    
    var username = AuthService.shared.getUsername()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        setupCircleViews()
        setupAvatar()
        setupLittleYellowCircle()
        setupGreetingLabel()
        setupStackView()
    }
    
    private func setupCircleViews() {
        makeCircle(yellowCircle, side: Constants.yellowCircleSide, color: .systemYellow)
        makeCircle(redCircle, side: Constants.redCircleSide, color: .systemRed)
        
        view.addSubview(yellowCircle)
        view.addSubview(redCircle)
        
        NSLayoutConstraint.activate([
            yellowCircle.topAnchor.constraint(equalTo: view.topAnchor, constant: -50),
            yellowCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -80),
            yellowCircle.widthAnchor.constraint(equalToConstant: Constants.yellowCircleSide),
            yellowCircle.heightAnchor.constraint(equalToConstant: Constants.yellowCircleSide),
            
            redCircle.topAnchor.constraint(equalTo: yellowCircle.topAnchor, constant: -70),
            redCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20),
            redCircle.widthAnchor.constraint(equalToConstant: Constants.redCircleSide),
            redCircle.heightAnchor.constraint(equalToConstant: Constants.redCircleSide)
        ])
        
    }
    
    private func makeCircle(_ circle: UIView, side: CGFloat, color: UIColor) {
        circle.layer.cornerRadius = side / 2
        circle.backgroundColor = color
    }
    
    private func setupAvatar() {
        profilePicture.layer.cornerRadius = 20
        profilePicture.layer.masksToBounds = true
        
        view.addSubview(profilePicture)
        
        let avatarURL = AuthService.shared.getUserPicture()
        loadAvatar(from: avatarURL)
        
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profilePicture.trailingAnchor.constraint(equalTo: redCircle.trailingAnchor, constant: 10),
            profilePicture.bottomAnchor.constraint(equalTo: yellowCircle.bottomAnchor, constant: 10),
            profilePicture.widthAnchor.constraint(equalToConstant: Constants.profilePictureSide),
            profilePicture.heightAnchor.constraint(equalToConstant: Constants.profilePictureSide)
        ])
    }
    
    private func loadAvatar(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.profilePicture = UIImageView(image: UIImage(named: "defaultAvatar"))
            } else if let data = data {
                if let image = UIImage(data: data) {
                    self.profilePicture = UIImageView(image: image)
                } else {
                    self.profilePicture = UIImageView(image: UIImage(named: "defaultAvatar"))
                }
            } else {
                self.profilePicture = UIImageView(image: UIImage(named: "defaultAvatar"))
            }
        }.resume()
    }

    
    private func setupLittleYellowCircle() {
        makeCircle(littleYellowCircle, side: Constants.littleYellowCircleSide, color: .systemYellow)
        
        view.addSubview(littleYellowCircle)
        
        NSLayoutConstraint.activate([
            littleYellowCircle.trailingAnchor.constraint(equalTo: profilePicture.leadingAnchor, constant: 20),
            littleYellowCircle.bottomAnchor.constraint(equalTo: yellowCircle.bottomAnchor, constant: -10),
            littleYellowCircle.widthAnchor.constraint(equalToConstant: Constants.littleYellowCircleSide),
            littleYellowCircle.heightAnchor.constraint(equalToConstant: Constants.littleYellowCircleSide)
        ])
    }
    
    private func setupGreetingLabel() {
        greetingLabel.text = "Привет,\n" + username + "!"
        let greetingLabelText = greetingLabel.text ?? "nil"
        
        let attributedGreetingLabel = NSMutableAttributedString(string: greetingLabelText)
        let usernameRange = (greetingLabelText as NSString).range(of: username)
        attributedGreetingLabel.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: greetingLabel.font.pointSize), range: usernameRange)
        greetingLabel.attributedText = attributedGreetingLabel
        
        view.addSubview(greetingLabel)
        
        NSLayoutConstraint.activate([
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            greetingLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 20),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupStackView() {
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 20
        buttonsStack.distribution = .fillEqually
        
        buttonsStack.addArrangedSubview(teaDiaryButton)
        buttonsStack.addArrangedSubview(friendsButton)
        buttonsStack.addArrangedSubview(editProfileButton)
        buttonsStack.addArrangedSubview(signOutButton)
        
        view.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            teaDiaryButton.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight),
            friendsButton.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight),
            editProfileButton.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight),
            
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStack.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20),
        ])
    }

    @objc func signOut() {
        AuthService.shared.signOut()
        self.navigationController?.popToRootViewController(animated: true)
    }

}



