//
//  TimerVC.swift
//  Iphone Clock
//
//  Created by Oleksandr Smakhtin on 31.01.2023.
//

import UIKit

//MARK: - Protocol

protocol SetTimerDelegate {
    func getTimer(timer: TimerModel)
}

class TimerVC: UIViewController {

    var timeRemaining = [TimerModel]()
    var timer: Timer!
    
    //MARK: - Arrays
    //створюємо константи з масивами, які передаємо за допомогою сінгелтона shared, створеного в TimerData класі
    private let allHours = TimerData.shared.hours()
    private let allMinutes = TimerData.shared.minutes()
    private let allSeconds = TimerData.shared.seconds()
    
    //MARK: - Delegate
    var delegate: SetTimerDelegate? //створюємо delegate - вказуємо йому опціональний тип нашого протоколу, що вище
    
    //MARK: - UI objects
    
    private let timerPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.isHidden = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        //label.text = "\(allHours):\(allMinutes):\(allSeconds) "
        label.font = UIFont.systemFont(ofSize: 80, weight: .ultraLight)
        label.textColor = .darkGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let labelHours: UILabel = {
        let label = UILabel()
        label.text = "год"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelMinutes: UILabel = {
        let label = UILabel()
        label.text = "хв"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelSeconds: UILabel = {
        let label = UILabel()
        label.text = "с"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Скинути", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .light)
        button.backgroundColor = .darkGray
        button.layer.borderColor = .init(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 1)
        button.layer.borderWidth = 2
        button.setTitleColor(.gray, for: .normal) //чомусь не працює колір
        button.layer.cornerRadius = 42
        button.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пуск", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .light)
        button.backgroundColor = UIColor(red: 6.0 / 255.0, green: 104.0 / 255.0, blue: 88.0 / 255.0, alpha: 1.0)
        button.setTitleColor(.green, for: .normal) //чомусь не працює колір
        button.layer.cornerRadius = 42
        button.layer.borderColor = .init(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 1)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пауза", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .light)
        button.backgroundColor = UIColor(red: 131.0 / 255.0, green: 85.0 / 255.0, blue: 40.0 / 255.0, alpha: 1.0)
        button.setTitleColor(.systemOrange, for: .normal) //чомусь не працює колір
        button.layer.cornerRadius = 42
        button.layer.borderColor = .init(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 1)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(stopAction), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Далі", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .light)
        button.backgroundColor = UIColor(red: 6.0 / 255.0, green: 104.0 / 255.0, blue: 88.0 / 255.0, alpha: 1.0)
        button.setTitleColor(.green, for: .normal) //чомусь не працює колір
        button.layer.cornerRadius = 42
        button.layer.borderColor = .init(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 1)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // change bg
        view.backgroundColor = .systemBackground
        // add subviews
        addSubviews()
        // apply constraints
        applyConstraints()
        // apply delegates
        applyDelegates()

        // Do any additional setup after loading the view.
    }
    

    //MARK: - add subviews
    private func addSubviews() {
        view.addSubview(timerPicker)
        view.addSubview(timeLabel)
        timerPicker.addSubview(labelHours)
        timerPicker.addSubview(labelMinutes)
        timerPicker.addSubview(labelSeconds)
        view.addSubview(resetButton)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(continueButton)
    }
    
    //MARK: - Actions
    
    @objc func resetAction() {
        timerPicker.isHidden = false
        timeLabel.isHidden = true
        startButton.isHidden = false
        stopButton.isHidden = true
        continueButton.isHidden = true
        print("MyResetButton clicked")
    }
    
    
    @objc func startAction() {
        
        let hour = allHours[timerPicker.selectedRow(inComponent: 0)]
        let minute = allMinutes[timerPicker.selectedRow(inComponent: 1)]
        let second = allSeconds[timerPicker.selectedRow(inComponent: 2)]
        
        let model = TimerModel(hours: hour, minutes: minute, seconds: second) // робимо модель з нашими створеними константами в Alarm
        
        if model.hours != "0" || model.minutes != "00" || model.seconds != "00" {
            
            timerPicker.isHidden = true
            timeLabel.isHidden = false
            stopButton.isHidden = false
 
            // send alarm to alarm vc with the help of delegation
            delegate?.getTimer(timer: model)
            
            if model.hours == "0" {
                timeLabel.text = "\(minute):\(second)"
            } else {
                timeLabel.text = "\(hour):\(minute):\(second)"
            }
            
            //Приведення типу значень до Int
//            let hourInt = Int(hour)
//            let minuteInt = Int(minute)
//            let secondInt = Int(second)
            
//            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true
//
//            @objc func step() {
//                if secondInt > 0 {
//                    secondInt -= 1
//                    } else {
//                        timer.invalidate()
//                        secondInt = 10
//                        label.text = "\(timeRemaining)"
//                    }
//            }
                                        
            print("\(hour):\(minute):\(second)")
            print("MyStartButton clicked")
        }
    }
    
    //функція не працює - так як не можу достукатися до створених змінних у функціяї екшена до кнопки, винести їх теж не виходить. - помилки
//    @objc func step() {
//        if secondInt > 0 {
//            secondInt -= 1
//        } else {
//            timer.invalidate()
//            secondInt = 10
//            label.text = "\(timeRemaining)"
//        }
//    }
    
    
    @objc func stopAction() {
        continueButton.isHidden = false
        print("MyStopButton clicked")
    }
    
    
    @objc func continueAction() {
        stopButton.isHidden = false
        continueButton.isHidden = true
        print("MyContinueButton clicked")
    }
    
    //MARK: - apply constraints
    private func applyConstraints() {
        
        let timerPickerConstraints = [
            timerPicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            timerPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timerPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let timeLabelConstraints = [
            timeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        
        let labelHoursConstraints = [
            labelHours.topAnchor.constraint(equalTo: timerPicker.centerYAnchor, constant: -10),
            labelHours.leadingAnchor.constraint(equalTo: timerPicker.leadingAnchor, constant: 90)
        ]
        
        let labelMinutesConstraints = [
            labelMinutes.topAnchor.constraint(equalTo: timerPicker.centerYAnchor, constant: -10),
            labelMinutes.leadingAnchor.constraint(equalTo: timerPicker.leadingAnchor, constant: 214)
        ]
        
        let labelSecondsConstraints = [
            labelSeconds.topAnchor.constraint(equalTo: timerPicker.centerYAnchor, constant: -10),
            labelSeconds.leadingAnchor.constraint(equalTo: timerPicker.leadingAnchor, constant: 339)
        ]
        
        let resetButtonConstraints = [
            resetButton.topAnchor.constraint(equalTo: timerPicker.bottomAnchor, constant: 80),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resetButton.heightAnchor.constraint(equalToConstant: 85),
            resetButton.widthAnchor.constraint(equalToConstant: 85)
        ]
        
        let startButtonConstraints = [
            startButton.topAnchor.constraint(equalTo: timerPicker.bottomAnchor, constant: 80),
            startButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 84),
            startButton.widthAnchor.constraint(equalToConstant: 84)
        ]
        
        let stopButtonConstraints = [
            stopButton.topAnchor.constraint(equalTo: timerPicker.bottomAnchor, constant: 80),
            stopButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stopButton.heightAnchor.constraint(equalToConstant: 84),
            stopButton.widthAnchor.constraint(equalToConstant: 84)
        ]
        
        let continueButtonConstraints = [
            continueButton.topAnchor.constraint(equalTo: timerPicker.bottomAnchor, constant: 80),
            continueButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 84),
            continueButton.widthAnchor.constraint(equalToConstant: 84)
        ]
        
        NSLayoutConstraint.activate(timerPickerConstraints)
        NSLayoutConstraint.activate(timeLabelConstraints)
        NSLayoutConstraint.activate(labelHoursConstraints)
        NSLayoutConstraint.activate(labelMinutesConstraints)
        NSLayoutConstraint.activate(labelSecondsConstraints)
        NSLayoutConstraint.activate(resetButtonConstraints)
        NSLayoutConstraint.activate(startButtonConstraints)
        NSLayoutConstraint.activate(stopButtonConstraints)
        NSLayoutConstraint.activate(continueButtonConstraints)
    }
    
    //MARK: - Configure label
    //Конфіругуємо дані будильника так як ми самі обираємо дані для відображення
    public func configure(with model: TimerModel) {
        timeLabel.text = "\(model.hours):\(model.minutes):\(model.seconds)"
    }
}

//MARK: - SetTimerDelegate
//робимо розширення яке буде додавати дані в наш масив alarms, коли ми обираємо години і хвилини і натискаємо Зберегти додаються дані у масив і перезапускається наше вью - де буде відображено встановлений будильник. Все відбувається в момент виконання протоколу.
extension TimerVC: SetTimerDelegate {
    
    func getTimer(timer: TimerModel) {
        timeRemaining.append(timer) //додає TimerModel дані до масиву alarms
    }
    
}


//MARK: - UIPickerViewDelegate & DataSource
//екстешн для роботи пікера
extension TimerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    private func applyDelegates() {
        timerPicker.delegate = self
        timerPicker.dataSource = self
    }
    
    //Налаштовуємо кількість компонентів у пікера
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 //компонентів у пікері 3 (по індексу воні передаються як 0(наш 1 масив з годинами), 1(наш другий масив з хвилинами) і 2(наш 3 масив з секундами))
    }
    //Кількість рядків в компоненті - тут так само як із секціями
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { //вказуємо що якщо 1 компонент (по індексу він 0)
            return allHours.count //то повертаємо кількість рядків годин (тобто в масиві у нас їх 24 - у першому пікері з'явиться 24 значення)
        } else if component == 1 { //на 2 компонент (тобто по індексу 1)
            return allMinutes.count //ми повертаємо хвилини (буде 60 значень у пікери)
        } else { //на 3 компонент
            return allSeconds.count //ми повертаємо секунди (буде 60 значень у пікери)
        }
    }
    //передаємо значення для відображення в рядках
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //щоб не передавати значення з масивів - ми передаємо значення через індекси так як вони відповідні для значень годин і хвилин теж - тобто починаються від 0 і значення рівне своєму індексу. Едине треба для індексів від 0 до 9 треба попереду додати 0. Тож прописуємо далі умови для цього.
        if component == 0 { //для першого масиву який у нас 0 за індексом
            return "\(row)" //повертаємо просто значення індекса
        } else if component == 1 { //інший компонент далі з такими ж умовами як і для першого
            return "\(row)"
        } else {
            return "\(row)"
            }
    }
}
