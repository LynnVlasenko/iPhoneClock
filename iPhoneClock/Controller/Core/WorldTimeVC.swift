//
//  WorldTimeVC.swift
//  Iphone Clock
//
//  Created by Oleksandr Smakhtin on 31.01.2023.
//

import UIKit



class WorldTimeVC: UIViewController {
    
    //MARK: - array of time zones
    var times = [WorldTime]() //створюємо порожній масив з типом нашої моделі WorldTime, куди будуть зберигатися нові додані міста зі списку міст

    
    //MARK: - UI objects
    // створено табличку для відображення даних коли додаємо нове мисто з часом
    private let worldTimeTable: UITableView = {
        let table = UITableView()
        table.register(WorldTimeTableCell.self, forCellReuseIdentifier: WorldTimeTableCell.identifier) //реєструємо нашу комірку WorldTimeTableCell, ідентифікатор якої створений у WorldTimeTableCell
        
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // створено табличку, яка відображаєтся коли жодне місто не додано
    private let noTimeLbl: UILabel = {
        let label = UILabel()
        label.text = "Немає годинників"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // change bg
        view.backgroundColor = .black
        
        // change title
        title = "Світовий час"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]//колір не змінюється
        //title.titleTextAttributes = [.foregroundColor: UIColor.red]
        //title.foregroundColor = .white
        
        // configure nav bar //передаємо вигляд нашого верхнього Navigation Bar
        configureNavigationBar()
        
        // add subviews //Додаємо елементи UI
        addSubviews()
        
        // apply constraints //додаємо функцію з Констрейтами для Лояуту елементів
        applyConstraints()
        
        // apply delegates //передаємо функцію що запускає делегати таблички
        applyDelegates()
        
    }
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        worldTimeTable.frame = view.bounds //робимо по ширині екрану нашу вью з noTimeLbl, коли не обрані ще міста з часом
        worldTimeTable.backgroundColor = .black
    }
    
    //MARK: - Add subviews
    //функція у яку передаємо додавання кожного з наших UI елементів
    private func addSubviews() {
        view.addSubview(noTimeLbl)
        view.addSubview(worldTimeTable)
    }
    
    //MARK: - Configure NavBar
    //створюємо кнопки для Навігейшн бару у верхній частині нашого вью.
    private func configureNavigationBar() {
        // left button //кнопка "Корегувати", яка на разі не має ніякого екшена.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Корегувати", style: .done, target: self, action: nil)
        // right button //кнопка з зображенням + - для додавання нового міста з часом. Є селектор, в якому прописані дії коли натискаєш на кнопку
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addTime))
        
        navigationController?.navigationBar.tintColor = .systemOrange // колір для навігаційних елементів бару.
        navigationController?.navigationBar.prefersLargeTitles = true // розмір тайтлу збільшуемо до великого.
        //колір не змінюється..
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    //MARK: - Apply constraints
    //налаштовуємо Лояут для екрану, коли немає доданих міст з часом
    private func applyConstraints() {
        let noTimeLblConstraints = [
            noTimeLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTimeLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(noTimeLblConstraints)
    }
    
    //MARK: - Actions for Navigation bar items
    // for rigth button
    @objc private func addTime() {
        let vc = RegionsVC() //створюємо константу яка дорівнює класу RegionsVC() - вью контроллер, який відображає екран з вибором міста для додавання до WorldTimeVC
        // apply delegate
        vc.delegate = self
        
        showDetailViewController(vc, sender: self) //тут ми презентуємо новий екран для відображення після натискання кнопки.
        //Є ще інші методи для відображення нової вьюшки - типу PushNavigationController(створює нову вью для відображення - автоматичто відображає тайтл і з'являється кнопка "Назад", буде з анімацією - вперед-назад) - почитати про ці методи
        
    }
}

//MARK: - UpdateTimeDelegate
//робимо розширення яке буде додавати дані в наш масив times, коли ми обираємо нове місто і відображати нове місто на нашому вью. Все відбувається в момент виконання протоколу.
extension WorldTimeVC: UpdateTimeDelegate { //вказуємо що наш WorldTimeVC підкоряється протоколу UpdateTimeDelegate(комформиться з протоколом), свореному у файлі RegionsVC(який налаштовує вью зі списком міст)
    
    func updateTableTime(time: WorldTime) { //виконуємо метод протоколу - який приймає тип WorldTime
        times.append(time) //додає WorldTime до порожнього масиву, times, що створено вище
        worldTimeTable.reloadData()// і виконує метод оновити табличку - коли табличка починає оновлючатися іде перевірка у екстеншені нижче у функції з методом numberOfRowsInSection - бачит що times.count більше не 0 - і відображає worldTimeTable на нашому поточному вью
    }
    
}

//MARK: - UITableViewDelegate & DataSource
extension WorldTimeVC: UITableViewDelegate, UITableViewDataSource {
    
    //delegates //передаємо делегати для таблички, що відображає міста з часом
    private func applyDelegates() {
        worldTimeTable.delegate = self
        worldTimeTable.dataSource = self
    }
    
    //number of rows in section // тут передаються комірки які додаються чи не додаються на екран. (ця функція створюється автоматично для таблички - ми вже в середині прописуємо код з налаштуваннями.)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //ця функція задає умову для відображення таблички на WorldTimeVC. Чи це буде відображення таблички з містами worldTimeTable, чи якщо місто не додано6 то показуємо табличку noTimeLbl
        if times.count == 0 { //якщо масив порожній - ми ще нічого не додали на екран зі списку міст
            worldTimeTable.isHidden = true
            noTimeLbl.isHidden = false
        } else {
            worldTimeTable.isHidden = false
            noTimeLbl.isHidden = true
        }
        
        
        return times.count //передаємо кількість комірок, які створилися після додавання нових міст.
    }
    
    //cell for row at //створюємо комірку (ця функція створюється автоматично для таблички - ми вже в середині прописуємо код з налаштуваннями.)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //передаємо ідентифікатор комірки - повертаємо відповідну комірку
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorldTimeTableCell.identifier) as? WorldTimeTableCell else { return UITableViewCell()}
        
        let model = times[indexPath.row] //створюємо константу, яка зберігає в собі наш створений масив times, що приймає модель WorldTime як тип - і відображає по індексу дані, які ми хочемо показати на екрані у доданій комірці
        
        //конфігуруємо нашу комірку - у файлі створення комірки WorldTimeTableCell ми створили функцію configure, яка передає дані моделі WorldTime. тут ми передаємо кожен параметр через щойно створену константу model, щоб динамічно отримувати обрані дані з містом і його часом на екран.
        cell.configure(with: WorldTime(difference: model.difference, city: model.city, region: model.region, time: model.time))
        
        return cell //повертаємо створену комірку
    }
    
      
    // delete action //видалення міста з нашої вью
    // це дуже швидкий метод щоб видаляти комірки так чисто для тесту можна зробити
    // в нас є commit в якому ми вказуємо якщо у нас стиль корекції буде = видалити, то нам поперше з таблички з вьюшки треба видалити рядок за індекс пасом який тут є, воно передає той, який ми клікнули. плюс треба не забувати, що треба видалити його ще й з нашого масиву, в який додаються дані для відобреження. Коли виконується цей метод - вин перезапускає табличку.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete { //коли editingStyle = .delete - тобто це автоматична дія яка реагує, коли комірку протягнути вліво, з'являється з правої сторони кнопка delete. Якщо на неї натиснути - спрацює функція і видалить елемент.
            self.times.remove(at: indexPath.row) //видалить дані з масиву
            tableView.deleteRows(at: [indexPath], with: .fade)//та видалить рядок таблиці  (.fade - це анімація, як воно буде зникати)
            
            
        } else {
            return
        }
        
    }
    //Ще є додаткові методи. Їх дуже багато. Для корекції цих кнопок є 4 методи - є leadingSwipeActionsConfigurationForRowAt(буде свайпатись зліва і там можна додати до 3 екшенів) https://developer.apple.com/documentation/uikit/uitableviewdelegate/2902366-tableview Можна створити декілька методів - типу як на пошті - в архів зберегти, відмітити прочитаним, корегувати щось і т.д. Є такий самий але trailingSwipeActionsConfigurationForRowAt (буде свайпатись зправа) на нього можна додавати delete https://developer.apple.com/documentation/uikit/uitableviewdelegate/2902367-tableview
    
}
