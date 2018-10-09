//
//  main.swift
//  unitCo
//
//  Created by Elena on 09/10/2018.
//  Copyright © 2018 elena. All rights reserved.
//

import Foundation

struct Units {
    static let lengthUnit: [String : Double] = ["cm": 100, "m": 100, "inch": 2.54, "yard": 91.44]
    static let weightUnit: [String : Double] = ["kg": 1000, "g": 1000, "lb": 2.205, "oz": 35.274]
}

// MARK: 출력
func printUnit(state : Double,unit:String) {
    
    switch state {
    case 0 :
        print("---단위 변환기---\n")
        for unit in Units.lengthUnit.keys {
            print("\(unit) ", terminator:"")
        }
        print("")
        for unit in Units.weightUnit.keys {
            print("\(unit) ", terminator:"")
        }
        print("\n")
        print(" 길이와 단위를 입력해주세요 : 예) 123cm m  , q 입력시 종료")
    case 9:
        print("잘못 입력했음. 다시 확인하세요.")
    default:
        print("\(state)\(unit)")
    }
}

// MARK: 사용자데이터 숫자 문자 분리
func splitUserData(_ userData: String) -> (number: String, userUnit :String) {
    let userUnit = userData.components(separatedBy:CharacterSet.init(charactersIn: "1234567890.")).joined()
    let number = userData.components(separatedBy: CharacterSet.init(charactersIn: userUnit)).joined()
    return (number, userUnit)
}

// MARK: 바꿀 단위가 여러개인 경우
func splitConversionUnit(_ conversionData: String) -> Array<String> {
    var unitArray = [""]
    for unit in conversionData.split(separator: ",") {
        unitArray.append(String(unit))
    }
    unitArray.remove(at: 0)
    return unitArray
}

// MARK: 사용자 입력한것 자르기
func splitUserInputLine(_ userLine: String ) ->(number : String ,userUnit : String, conversionUnit : String) {
    
    var userValue = userLine.split(separator:" ").map{ String($0) }
    
    let userData = splitUserData(userValue[0])
    
    if userValue.count == 1 {
        return (userData.number,userData.userUnit,userData.userUnit)
    }
    return (userData.number,userData.userUnit,userValue[1])
}

//MARK : 단위변환 중 무게 변환
func checkWeightUnit(_ number: Double , _ userUnit: String , _ conversionUnit: String) -> (number: Double, unit: String) {
    if userUnit == "g" {
        switch conversionUnit {
        case "kg":
            return (checkSumValue(number,Units.weightUnit[conversionUnit]! , 2),conversionUnit)
        default:
            return (9,"null")
        }
    }else if userUnit == "kg" {
        switch conversionUnit {
        case "g", "oz":
            return (checkSumValue(number,Units.weightUnit[conversionUnit]! , 1),conversionUnit)
        default:
            return (9,"null")
        }
        
    }else if userUnit == "lb" {
        switch conversionUnit {
        case "kg":
            return (checkSumValue(number,Units.weightUnit["lb"]! , 2),conversionUnit)
        default:
            return (9,"null")
        }
        
    }else if userUnit == "oz" {
        switch conversionUnit {
        case "kg":
            return (checkSumValue(number,Units.weightUnit["oz"]! , 2),conversionUnit)
        default:
            return (9,"null")
        }
        
    }else {
        return (9,"null")
    }
}
//MARK : 단위변환 중 길이 변환
func checkLengthUnit(_ number : Double , _ userUnit : String , _ conversionUnit : String)-> (number : Double, unit: String){
    if userUnit == "cm" {
        switch conversionUnit {
        case "cm":
            var allPrint = checkLengthUnit(number, "cm", "yard")
            printUnit(state : allPrint.number,unit: allPrint.unit)
            allPrint = checkLengthUnit(number, "cm", "inch")
            printUnit(state : allPrint.number,unit: allPrint.unit)
            return (checkSumValue(number , Units.lengthUnit[conversionUnit]! , 2),"m")
        case "m" , "inch" , "yard":
            return (checkSumValue(number , Units.lengthUnit[conversionUnit]! , 2),conversionUnit)
        default:
            return (9,"null")
        }
    }else if userUnit == "m" {
        switch conversionUnit {
        case "cm":
            return (checkSumValue(number , Units.lengthUnit[conversionUnit]! , 1),conversionUnit)
        case "m":
            var allPrint = checkLengthUnit(number, "m", "yard")
            printUnit(state : allPrint.number,unit: allPrint.unit)
            allPrint = checkLengthUnit(number, "m", "inch")
            printUnit(state : allPrint.number,unit: allPrint.unit)
            return (checkSumValue(number , Units.lengthUnit[conversionUnit]! , 1),"cm")
        case "inch":
            let cmOfValue = checkLengthUnit(number, "m" , "cm")
            let result = checkLengthUnit(cmOfValue.number, "cm", "inch")
            return (result.number,result.unit)
        case "yard":
            let cmOfValue = checkLengthUnit(number, "m" , "cm")
            let result = checkLengthUnit(cmOfValue.number, "cm", "yard")
            return (result.number,result.unit)
        default:
            return (9,"null")
        }
    }else if userUnit == "inch" {
        switch conversionUnit {
        case "cm" :
            return (checkSumValue(number , Units.lengthUnit["inch"]! , 1),conversionUnit)
        case "m":
            let cmOfValue = checkLengthUnit(number, "inch" , "cm" )
            let result = checkLengthUnit(cmOfValue.number, "cm" , "m" )
            return (result.number,result.unit)
        case "inch":
            return (number,conversionUnit)
        default:
            return (9,"null")
        }
    }else if userUnit == "yard" {
        switch conversionUnit {
        case "cm" :
            return (checkSumValue(number, 91.44, 1),conversionUnit)
        case "inch" :
            return (checkSumValue(number, 36, 1),conversionUnit)
        case "yard","m":
            return (checkSumValue(number, 1.094, 2),"m")
        default:
            return (9,"null")
        }
    }else {
        return (9,"null")
    }
}
//MARK : 단위 확인
func checkUnit(_ number : Double , _ userUnit : String , _ conversionUnit : String ) -> (number : Double, unit: String) {
    for key in Units.lengthUnit.keys {
        if userUnit.hasSuffix(key) {
            return checkLengthUnit(number,userUnit,conversionUnit)
        }
    }
    for key in Units.weightUnit.keys {
        if userUnit.hasSuffix(key) {
            return checkWeightUnit(number,userUnit,conversionUnit)
        }
    }
    return(9, "err")
}

// MARK: 단위 변환
func changeUnit(_ number : String , _ userUnit : String , _ conversionUnit : String ) -> (number : Double, unit: String) {
    
    let units = splitConversionUnit(conversionUnit)
    
    switch units.count {
    case 2:
        let checkedUnit = checkUnit(Double(number)!,userUnit,units[0])
        printUnit(state: checkedUnit.number,unit: checkedUnit.unit)
        return checkUnit(Double(number)!,userUnit,units[1])
        
    case 1:
        return checkUnit(Double(number)!,userUnit,conversionUnit)
        
    default:
        return (9,"null")
    }
}

// MARK: 계산
func checkSumValue(_ number : Double , _ conversionUnit : Double ,_ calculateFlag : Int) -> Double{
    if calculateFlag == 1 {
        return number * conversionUnit
    }else if calculateFlag == 2 {
        return number / conversionUnit
    }else {
        return 9
    }
    
}

// MARK: 공백검사
func blankUnit(_ unit: String?) -> Bool {
    return  unit == nil ? false : true
}
// MARK: 입력
func readUserLine() -> (userData : String,flagNull :Bool) {
    printUnit(state : 0, unit: "start")
    let userData = readLine()
    let flagNull = blankUnit(userData)
    return (userData!,flagNull)
}


//MARK : Main
while true {
    let startflag = readUserLine()
    
    if startflag.userData == "q" || startflag.flagNull == false {
        break
    }
    
    let result = splitUserInputLine(startflag.userData)
    let value = changeUnit(result.number, result.userUnit, result.conversionUnit)
    printUnit(state: value.number,unit: value.unit)
    
}
