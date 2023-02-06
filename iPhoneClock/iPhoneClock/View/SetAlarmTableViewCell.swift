//
//  SmartAlarmTableViewCell.swift
//  Iphone Clock
//
//  Created by Oleksandr Smakhtin on 02.02.2023.
//

import UIKit

class SetAlarmTableViewCell: UITableViewCell {
    
    static let shared = SetAlarmTableViewCell()

    //MARK: - Identifier
    static let identifier = "SetAlarmTableViewCell"
    
    //MARK: - UI objects
    private let lableAlarmName: UILabel = {
        let label = UILabel()
        label.text = "Назва"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fieldAlarmName: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(
            string: "Сигнал",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        field.textAlignment = .right
        field.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        field.tintColor = .orange
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .darkGray
        //add subviews
        addSubviews()
        //apply constraints
        applyConstraints()
    }
    
    //MARK: - Required Init
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    //MARK: - add subviews
    private func addSubviews() {
        contentView.addSubview(lableAlarmName)
        contentView.addSubview(fieldAlarmName)
    }
    
    
    //MARK: - apply constraints
    private func applyConstraints() {
        
        let lableAlarmNameConstraints = [
            lableAlarmName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lableAlarmName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ]
        
        let fieldAlarmNameConstraints = [
            fieldAlarmName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            fieldAlarmName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            fieldAlarmName.heightAnchor.constraint(equalToConstant: 20),
            fieldAlarmName.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        
        NSLayoutConstraint.activate(lableAlarmNameConstraints)
        NSLayoutConstraint.activate(fieldAlarmNameConstraints)
    }
    
    
    func alarmName() -> String? {
        return fieldAlarmName.text
    }

}
