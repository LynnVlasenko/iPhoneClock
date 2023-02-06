//
//  AlarmData.swift
//  Iphone Clock
//
//  Created by Oleksandr Smakhtin on 02.02.2023.
//

import Foundation


class AlarmData {
    
    static let shared = AlarmData() //це сінгелтон він допомагає передати зразок в одному місці і потім викликати одразу метод для певної змінної. Через AlarmData.shared. далі -> властивості чи медоди будуть доступні для передачі у змінну чи ще кудить, куди треба передати певні дані з класу чи структури. Це для того щоб кожного разу не створювати об'єкт для сласу, щоб передати з нього дані.
    
    //Масив даних який передає дані для кожної константи яка сворена у структурі (в моделі) Alarm.
    //це для тесту було зроблено. Воно не функціонує
//    private let alarmArray = [
//        Alarm(hours: "06", minutes: "00", isOn: false),
//        Alarm(hours: "06", minutes: "30", isOn: false),
//        Alarm(hours: "07", minutes: "10", isOn: false),
//        Alarm(hours: "07", minutes: "45", isOn: false),
//        Alarm(hours: "08", minutes: "15", isOn: false),
//        Alarm(hours: "09", minutes: "10", isOn: false),
//    ]
    
    //масив з годинами
    private let allHours = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    //масив з хвилинами
    private let allMinutes = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    
    
    //метод, що повертає масив з годинами
    func hours() -> [String] {
        return allHours
    }
    //метод, що повертає масив з годинами
    func minutes() -> [String] {
        return allMinutes
    }
    
//    func alarms() -> [Alarm] {
//        return alarmArray
//    }
    
}
