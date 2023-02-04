//
//  SetAlarmVC.swift
//  Iphone Clock
//
//  Created by Oleksandr Smakhtin on 02.02.2023.
//

import UIKit
//MARK: - Protocol

//створюємо протокол в якому буде метод - оновити табличку(в extension AlarmVC: SetAlarmDelegate у файлі AlarmVC) і який має за параметр тип WorldTime
protocol SetAlarmDelegate {
    func getAlarm(alarm: Alarm)
}

class SetAlarmVC: UIViewController {
    
    //MARK: - Arrays
    //створюємо константи з масивами, які передаємо за допомогою сінгелтона shared, створеного в AlarmData класі
    private let allHours = AlarmData.shared.hours()
    private let allMinutes = AlarmData.shared.minutes()
    
    
    //MARK: - Delegate
    var delegate: SetAlarmDelegate? //створюємо delegate - вказуємо йому опціональний тип нашого протоколу, що вище
    
    //MARK: - UI objects
    //кнопка відміна у якої буде таргет екшн - dismiss (тобто - скасувати)
    private let cancelBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Скасувати", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        button.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let saveBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Зберегти", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        button.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addingLbl: UILabel = {
        let label = UILabel()
        label.text = "Додавання"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //пікер додаємо, але наразі він не налаштований функціонально
    private let timePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
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

    }
    
    
    //MARK: - add subviews
    private func addSubviews() {
        view.addSubview(cancelBtn)
        view.addSubview(saveBtn)
        view.addSubview(addingLbl)
        view.addSubview(timePicker)
    }
    
    //MARK: - Actions
    
    @objc private func saveAction() {
        let hour = allHours[timePicker.selectedRow(inComponent: 0)] //створюємо константу де ми на наших годинах (масив годин де їх 24) можемо викликати метод тайм пікера.обраний рядок(selectedRow) - тобто де зараз стоїть рядок, на якому елементі, і так як елементи масива і індекси співпадають - то ми отримаємо вірне значення для нас - відповідне до значення годин
        let minute = allMinutes[timePicker.selectedRow(inComponent: 1)] //тут так само як і з годинами
        
        
        let model = Alarm(hours: hour, minutes: minute, isOn: false) // робимо модель з нашими створеними константами в Alarm
        
        // send alarm to alarm vc with the help of delegation
        delegate?.getAlarm(alarm: model) //передаємо модель у делегат - тобто прописали змінну delegate? яку сворили на початку файлу вона має опуіональний тип створеного також зверху протоколу SetAlarmDelegate  - а протокол має функцію getAlarm, що приймає Alarm
        dismiss(animated: true) //закриваємо вьюшку в якій обираємо час і повертає нас на нашу вьюшку з Будильниками, де ми побачимо доданий новий будильник
        print("\(hour):\(minute)") //перевірка просто, що принтує ті часи, які ми обрали
    }
    
    @objc private func cancleAction() {
        dismiss(animated: true)
    }
    
    
    //MARK: - apply constraints
    private func applyConstraints() {
        
        let cancelBtnConstraints = [
            cancelBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            cancelBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ]
        
        let addingLblConstraints = [
            addingLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addingLbl.centerYAnchor.constraint(equalTo: saveBtn.centerYAnchor)
        ]
        
        let saveBtnConstraints = [
            saveBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            saveBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        
        let timePickerConstraints = [
            timePicker.topAnchor.constraint(equalTo: addingLbl.bottomAnchor, constant: 20),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(cancelBtnConstraints)
        NSLayoutConstraint.activate(addingLblConstraints)
        NSLayoutConstraint.activate(saveBtnConstraints)
        NSLayoutConstraint.activate(timePickerConstraints)
        
    }
 

}


//MARK: - UIPickerViewDelegate & DataSource
//екстешн для роботи пікера
extension SetAlarmVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
        
    private func applyDelegates() {
        timePicker.delegate = self
        timePicker.dataSource = self
    }
    
    //Налаштовуємо кількість компонентів у пікера
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 //компонентів у пікері 2 (по індексу воні передаються як 0(наш 1 масив) і 1(наш другий масив))
    }
    //Кількість рядків в компоненті - тут так само як із секціями
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { //вказуємо що якщо 1 компонент (по індексу він 0)
            return allHours.count //то повертаємо кількість рядків годин (тобто в масиві у нас їх 24 - у першому пікері з'явиться 24 значення)
        } else { //на 2 компонент (тобто по індексу 1)
            return allMinutes.count //ми повертаємо хвилини (буде 60 значень у пікери)
        }
    }
    //передаємо значення для відображення і рядках
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //щоб не передавати значення з масивів - ми передаємо значення через індекси так як вони відповідні для значень годин і хвилин теж - тобто починаються від 0 і значення рівне своєму індексу. Едине треба для індексів від 0 до 9 треба попереду додати 0. Тож прописуємо далі умови для цього.
        if component == 0 { //для першого масиву який у нас 0 за індексом
            
            if row < 10 { //якщо значення індекса менше 10
                return "0\(row)" //повертаємо стрінгу інтерполюємо 0 попереду і індекс
            } else { //якщо все інші значення далі по масиву
                return "\(row)" //повертаємо просто значення індекса
            }
            
        } else { //інший компонент далі з такими ж умовами як і для першого
            
            if row < 10 {
                return "0\(row)"
            } else {
                return "\(row)"
            }
            
        }
    }
    
}
