//
//  main.swift
//  newCal
//
//  Created by Elena on 08/10/2018.
//  Copyright © 2018 elena. All rights reserved.
//

import Foundation

let unit:[String : Double] = ["cm" : 100 , "m" : 100 , "inch" : 2.54 , "yard" : 91.44 ]

func cutValue(_ userLine: String ) ->(number : String ,userUnit : String, conversionUnit : String) {
    
    var userValue = userLine.split(separator:" ").map{ String($0) }

    let userData = userValue[0]
    var numberOfCount = 0
    var number : String = ""
    var userUnit : String = ""
    
    for index in userData.utf16 {
        if index >= 48 , index <= 57 {
            numberOfCount += 1
        }else if index == 46 {
            numberOfCount += 1
        }
    }
    
    for i in userData.indices {
        if numberOfCount > 0 {
            number.append(userData[i])
            numberOfCount -= 1
        }else {
            userUnit.append(userData[i])
        }
    }
    if userValue.count == 1 {
        return (number, userUnit, userUnit)
    }

    return (number,userUnit,userValue[1])
}

func changeUnit(_ number : String , _ userUnit : String , _ conversionUnit : String ) -> (number : Double, unit: String) {
    print(number,userUnit,conversionUnit)
    if userUnit == "cm" {
        switch conversionUnit {
        case "cm":
            return (checkSumValue(Double(number)! , unit[conversionUnit]! , 2),"m")
        case "m":
            return (checkSumValue(Double(number)! , unit[conversionUnit]! , 2),conversionUnit)
        case "inch":
            return (checkSumValue(Double(number)! , unit[conversionUnit]! , 2),conversionUnit)
        case "yard":
            return (checkSumValue(Double(number)!, unit[conversionUnit]!, 2),conversionUnit)
        default:
            return (9,"null")
        }
    }else if userUnit == "m" {
        switch conversionUnit {
        case "cm":
            return (checkSumValue(Double(number)! , unit[conversionUnit]! , 1),conversionUnit)
        case "m":
            return (checkSumValue(Double(number)! , unit[conversionUnit]! , 1),"cm")
        case "yard":
            let cmOfValue = changeUnit(number, "m" , "cm")
            print(cmOfValue.number,cmOfValue.unit)
            let result = changeUnit(String(cmOfValue.number), "cm", "yard")
            return (result.number,result.unit)
            
        default:
            return (9,"null")
        }
    }else if userUnit == "inch" {
        switch conversionUnit {
        case "cm" :
            return (checkSumValue(Double(number)! , unit["inch"]! , 1),conversionUnit)
        case "m":
            let cmOfValue = changeUnit(number , "inch" , "cm" )
            let result = changeUnit(String(cmOfValue.number), "cm" , "m" )
            return (result.number,result.unit)
        case "inch":
            return (9,"null")
        default:
            return (9,"null")
        }
    }else if userUnit == "yard" {
        switch conversionUnit {
        case "cm" :
            return (9,"null")
        case "m":
            return (9,"null")
        case "inch" :
            return (9,"null")
        case "yard":
            return (checkSumValue(Double(number)!, 1.094, 2),"m")
        default:
            return (9,"null")
        }
    }else {
        return (9,"null")
    }
    
}

func checkSumValue(_ number : Double , _ conversionUnit : Double ,_ calculateFlag : Int) -> Double{
    if calculateFlag == 1 {
        return number * conversionUnit
    }else if calculateFlag == 2 {
        return number / conversionUnit
    }else {
        return 9
    }
    
}

func printUnit(_ state : Double,_ unit:String) {
    
    switch state {
    case 0 :
        print("---단위 변환기---\n")
        print(" 길이와 단위를 입력해주세요 : 예) 123cm m  , q 입력시 종료 \n ")
    case 9:
        print("잘못 입력했음. 다시 확인하세요.")
    default:
        print("\(state)\(unit)")
    }
}

while true {
    printUnit(0,"start")
    let userLine = readLine()!
    if userLine == "q" {
        break
    }
    
    let result = cutValue(userLine)
    let value = changeUnit(result.number, result.userUnit, result.conversionUnit)
    printUnit(value.number,value.unit)
    
}
