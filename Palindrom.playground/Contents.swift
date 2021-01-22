import UIKit

func polindrom (a: String) -> Bool {
    var b: String = ""
    var c: String = ""
    
    for i in a.reversed() {
        if i != " " {
            b += String(i).lowercased()
        }
    }
    
    for i in a {
        if i != " " {
            c += String(i).lowercased()
        }
    }
    if b == c {return true}
    else {return false}
}

polindrom(a: "А роза упала на лапу Азора")

polindrom(a: "Казак")


//

let testStr = "казАк"

let characters = Array(testStr.lowercased())

let maxIndex = characters.count - 1

var newStr = ""

for i in 0...maxIndex {
    newStr = newStr + String(characters[maxIndex-i])
}

print((testStr.lowercased() == newStr) ? "palindrom" : "not palindrom")
