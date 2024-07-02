import UIKit

final class MovieQuizViewController: UIViewController {
    
// MARK: IB Outlets
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
// MARK: Properties
    // переменная индекса вопроса
    private var currentQuestionIndex = 0
    // переменная количества правильных ответов
    private var correctAnswers = 0
    // для вопросов
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    // для состояния "Вопрос показан"
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    // для результата
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    //  набор вопросов
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        let resultOfConvert = convert(model: currentQuestion)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        show(quiz: resultOfConvert)
    }
// MARK: IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        buttonState(isEnabled: false)
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        buttonState(isEnabled: false)
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
//    MARK: Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionResult()
            self.buttonState(isEnabled: true)
        }
    }
    
    private func showNextQuestionResult() {
        if currentQuestionIndex == questions.count - 1 {
            let resultString = "Ваш результат \(correctAnswers)/\(questions.count)"
            let alertView = QuizResultsViewModel(title: "Этот раунд окончен", text: resultString, buttonText: "Сыграть еще раз")
            show(quiz: alertView)
        } else {
            currentQuestionIndex += 1
            let currentQuestion = questions[currentQuestionIndex]
            let resultOfConvert = convert(model: currentQuestion)
            show(quiz: resultOfConvert)
        }
    }
    // включение - выключение кнопок после ответа
    private func buttonState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    // Алерт с результатом
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
