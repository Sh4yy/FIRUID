import Foundation
import UIKit

let ASC_CHARS = "-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz".characters.map { $0 }
let DESC_CHARS = ASC_CHARS.reversed().map { $0 }

func generatePushID(ascending: Bool = true) -> String {
    
    let PUSH_CHARS = ascending ? ASC_CHARS : DESC_CHARS
    
    var lastTimePush = 0;
    var lastRandChars = Array<Int>(repeatElement(0, count: 12))
    var timeStampChars = Array<Character>(repeating: " ", count: 8)
    
    var now = Int(Date().timeIntervalSince1970 * 1000)
    let isDuplicate = (lastTimePush == now)
    lastTimePush = now

    for n in (0...7).reversed() {
        timeStampChars[n] = PUSH_CHARS[Int(now % 64)]
        now >>= 6
    }
    
    assert(now == 0, "we should have converted the entire timestamp")
    
    var id = String(timeStampChars)
    
    if (!isDuplicate) {
        for n in 0..<12  {
            lastRandChars[n] = Int((arc4random() % 64))
        }
    } else {
        var i : Int = 11
        while (i >= 0) && (lastRandChars[i] == 63) {
            i -= 1
            lastRandChars[i] = 0
        }
        lastRandChars[i] += 1
    }
    
    for i in 0..<12 { id.append(PUSH_CHARS[lastRandChars[i]]) }
    assert(id.characters.count == 20, "Lenghts should be 20")
    
    return id
    
}

// 0.00448s to generate an id
print(generatePushID())






