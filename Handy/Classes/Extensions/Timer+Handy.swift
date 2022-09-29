//
//  Timer+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//



import UIKit


extension Timer: HandyCompatibleValue{}
extension Timer: HandyClassCompatibleValue{}

extension HandyExtension where Base == Timer{

}

extension HandyClassExtension where Base == Timer{
    ///   创建dispatch timer
    ///
    /// - Parameters:
    ///   - interval: float类型不能小于0.001
    ///   - finishCallback: 回调
    public static func createDispatchTimer(_ interval:Float,_ finishCallback:@escaping () -> Void){
        guard interval>=0.001 else {
            //未满足
            return
        }
        let deadlineTime = DispatchTime.now() + .microseconds(Int(interval * 1000.0))
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: finishCallback)
    }
    
    /// 创建timer blcok
    ///
    /// - Parameters:
    ///   - timeInterval: 间隔
    ///   - finishCallback: 回调
    ///   - repeats: 重复
    public static func scheduledTimer(timeInterval: TimeInterval, repeats: Bool, callback:@escaping (Timer) -> Void) -> Timer {
        
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats, block: callback)
        }
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(HandyTimerHandler.blockInvoke(timer:)), userInfo: callback, repeats: repeats)
    }
}

public class HandyTimerHandler: NSObject{
    
    @objc static func blockInvoke(timer:Timer)->Void
    {
        let block:(Timer) -> Void =  timer.userInfo as! (Timer) -> Void
        block(timer)
    }
}
