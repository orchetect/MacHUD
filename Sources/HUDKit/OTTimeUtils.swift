//
//  OTTimeUtils.swift
//  HUDKit
//
//  Created by AntScript on 15/8/26.
//

import Foundation

class OTTimeUtils {
	
	public typealias Task = (_: Bool) -> ()
	
	static public func delay(_ time: TimeInterval,
							 task: @escaping (() -> Void)) -> Task? {
		
		func dispatch_later(_ block: @escaping (() -> Void)) {
			
			// prevents time values less than 0.01 seconds as failsafe
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(max(time, 0.01) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
										  execute: block)
			
		}
		
		var closure: (() -> Void)? = task
		var result: Task?
		
		let delayedClosure: Task = { cancel in
			if let internalClosure = closure {
				if (cancel == false) {
					internalClosure()
				}
			}
			closure = nil
			result = nil
		}
		
		result = delayedClosure
		
		dispatch_later {
			if let delayedClosure = result {
				delayedClosure(_: false)
			}
		}
		
		return result
		
	}
	
	static public func cancel(_ task: Task?) {
		
		task?(_: true)
		
	}
}
