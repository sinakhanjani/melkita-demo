//
//  Timer.swift
//
//  Created by Sina khanjani on 2/28/1400 AP.
//

import UIKit

class TimerHelper {
    
    private var timer: Timer!
    private var secend: Int = 0
    
    public private(set) var elapsedTimeInSecond: Int = 0

    internal init(elapsedTimeInSecond: Int) {
        self.elapsedTimeInSecond = elapsedTimeInSecond
        self.secend = elapsedTimeInSecond
    }
    
    public func start(completion: @escaping (_ time: (minute: String, secend: String)) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.elapsedTimeInSecond -= 1

            completion(self.time())
            
            if self.elapsedTimeInSecond == 0 {
                self.pauseTimer()
            }
        })
    }
    
    public func resetTimer() {
        timer?.invalidate()
        elapsedTimeInSecond = secend
    }

    public func pauseTimer() {
        timer?.invalidate()
    }
    
    func time() -> (minute: String, secend: String) {
        let seconds = elapsedTimeInSecond % 60
        let minutes = (elapsedTimeInSecond / 60) % 60
        
        let secendText = String(format: "%02d", seconds)
        let minuteText = String(format: "%02d", minutes)

        return (minute: minuteText, secend: secendText)
    }
}

/*
 let timer = TimerHelper(elapsedTimeInSecond: 4*60)
 timer.start { [unowned self] (time) in
     print("\(time.minute):\(time.secend)")
 }
 */
