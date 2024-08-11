import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    

    private var presenter: MovieQuizPresenter!
    private var alertModel: AlertModel?
    private var alertPresenter: AlertPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
       
        activityIndicator.hidesWhenStopped = true
        showLoadingIndicator()
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        imageView.layer.cornerRadius = 20
        
    }
    
    // MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    //    MARK: - Methods
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func buttonState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func showQuizResult() {
        let message = presenter.makeResultsMessage()
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен",
            message: message,
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
                guard let self else { return }
                self.presenter.restartGame()
                
            })
        alertPresenter?.showResultAlert(alertModel)
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: {[weak self] in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
        )
        alertPresenter?.showResultAlert(alertModel)
    }
}

//MARK: - Extensions

// MARK: AlertPresenterDelegate
extension MovieQuizViewController: AlertPresenterDelegate {
    func showAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}
