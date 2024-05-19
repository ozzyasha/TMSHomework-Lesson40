//
//  SignInViewController.swift
//  TMSHomework-Lesson40
//
//  Created by Наталья Мазур on 12.05.24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController {
    
    private enum Constants {
        static let yellowCircleSide: CGFloat = UIScreen.main.bounds.width * 2
        static let backgroundTopOffset: CGFloat = UIScreen.main.bounds.height / 11
        static let backgroundLeadingOffset: CGFloat = 30
        static let backgroundCornerRadius: CGFloat = 20
        static let stackViewTopOffset: CGFloat = 20
        static let signInlabelHeight: CGFloat = 60
        static let signInButtonCornerRadius: CGFloat = 15
        static let textFieldsHeight: CGFloat = 40
        static let signInButtonHeight: CGFloat = 55
        static let errorLabelHeight: CGFloat = 70
        static let signUpLabelHeight: CGFloat = 15
        static let alternativeSignInLabelHeight: CGFloat = 15
    }
    
    private let yellowCircle: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.cornerRadius = Constants.yellowCircleSide / 2
        circle.backgroundColor = .systemYellow
        return circle
    }()
    
    private let whiteBackground: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.cornerRadius = Constants.backgroundCornerRadius
        background.backgroundColor = .white
        return background
    }()
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.text = "Sign In"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.overrideUserInterfaceStyle = .light
        textField.placeholder = "e-mail"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.overrideUserInterfaceStyle = .light
        textField.placeholder = "password"
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.signInButtonCornerRadius
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = ""
        label.numberOfLines = 5
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        let attributedText = NSMutableAttributedString(string: "Don't have an account? Sign up")
        let signInRange = (attributedText.string as NSString).range(of: "Sign up")
        attributedText.addAttribute(.foregroundColor, value: UIColor.systemRed, range: signInRange)
        label.attributedText = attributedText
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpLabelTapped)))
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var alternativeSignInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.text = "or sign in with"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var googleSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "googleIcon"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(GoogleSignInButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var stackView = UIStackView()
    
    private var authHandler: AuthStateDidChangeListenerHandle! = nil
    
    // MARK: - SignInViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authHandler = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                let mainVC = MainViewController()
                self.navigationController?.pushViewController(mainVC, animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(authHandler!)
    }
    
    
    // MARK: - Setup UI
    private func setupBackground() {
        view.backgroundColor = .systemRed
        view.addSubview(yellowCircle)
        view.addSubview(whiteBackground)
        
        NSLayoutConstraint.activate([
            yellowCircle.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 3),
            yellowCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: UIScreen.main.bounds.width / 4),
            yellowCircle.widthAnchor.constraint(equalToConstant: Constants.yellowCircleSide),
            yellowCircle.heightAnchor.constraint(equalToConstant: Constants.yellowCircleSide),
            
            whiteBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.backgroundTopOffset),
            whiteBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.backgroundLeadingOffset),
            whiteBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.backgroundLeadingOffset),
            whiteBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.backgroundTopOffset)
        ])
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        stackView.addArrangedSubview(signInLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(alternativeSignInLabel)
        stackView.addArrangedSubview(googleSignInButton)
        stackView.addArrangedSubview(signUpLabel)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = googleSignInButton.imageView!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: whiteBackground.topAnchor, constant: Constants.stackViewTopOffset),
            stackView.leadingAnchor.constraint(equalTo: whiteBackground.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: whiteBackground.trailingAnchor, constant: -10),
            
            signInLabel.widthAnchor.constraint(equalTo: whiteBackground.widthAnchor, constant: -40),
            signInLabel.heightAnchor.constraint(equalToConstant: Constants.signInlabelHeight),
            
            emailTextField.widthAnchor.constraint(equalTo: whiteBackground.widthAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldsHeight),
            
            passwordTextField.widthAnchor.constraint(equalTo: whiteBackground.widthAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldsHeight),
            
            errorLabel.widthAnchor.constraint(equalTo: whiteBackground.widthAnchor, constant: -40),
            errorLabel.heightAnchor.constraint(equalToConstant: Constants.errorLabelHeight),
            
            signInButton.widthAnchor.constraint(equalTo: whiteBackground.widthAnchor, constant: -40),
            signInButton.heightAnchor.constraint(equalToConstant: Constants.signInButtonHeight),
            
            alternativeSignInLabel.widthAnchor.constraint(equalTo: whiteBackground.widthAnchor, constant: -40),
            alternativeSignInLabel.heightAnchor.constraint(equalToConstant: Constants.alternativeSignInLabelHeight),
            
            googleSignInButton.widthAnchor.constraint(equalToConstant: 48),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 48),
            
            imageView.leadingAnchor.constraint(equalTo: googleSignInButton.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: googleSignInButton.topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: googleSignInButton.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: -10),
            
            signUpLabel.widthAnchor.constraint(equalTo: whiteBackground.widthAnchor, constant: -40),
            signUpLabel.heightAnchor.constraint(equalToConstant: Constants.signUpLabelHeight),
        ])
    }
    
    // MARK: - @objc methods
    @objc func signIn() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            emailTextField.checkIfEmpty()
            passwordTextField.checkIfEmpty()
            errorLabel.text = "All fields should not be empty"
            return
        }
        AuthService.shared.signInWithEmail(email: email, password: password) { errorText in
            if errorText == "No errors" {
                return
            } else {
                self.errorLabel.text = errorText
            }
        }

    }
    
    @objc func signUpLabelTapped() {
        let signUpViewController = SignUpViewController()
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @objc func GoogleSignInButtonTapped() {
        AuthService.shared.signInWithGoogle(vc: self) { errorText in
            if errorText == "No errors" {
                return
            } else {
                self.errorLabel.text = errorText
            }
        }
    }

}
