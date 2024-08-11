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
//    private var questionFactory: QuestionFactoryProtocol?
    private var alertModel: AlertModel?
    var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
       
        activityIndicator.hidesWhenStopped = true
        showLoadingIndicator()
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        statisticService = StatisticService()
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
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
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            presenter.didAnswer(isCorrectAnswer: isCorrect)
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.presenter.showNextQuestionOrResult()
            self.buttonState(isEnabled: true)
        }
    }
    
    func buttonState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func showQuizResult() {
        guard let statisticService = statisticService else { return }
        statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        let bestGame = statisticService.bestGame
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        
        let text = """
        Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
        Средняя точность: \(accuracy)%
        """
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен",
            message: text,
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
                presenter.correctAnswers = 0
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
