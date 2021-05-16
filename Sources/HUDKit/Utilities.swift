//
//  Utilities.swift
//  HUDKit
//
//  Created by Steffan Andrews on 2016-06-26.
//  Copyright © 2016 Steffan Andrews. All rights reserved.
//

import Foundation

// MARK: - DispatchQueue CancellableTask

extension DispatchQueue {
	
	internal func asyncAfterDelta(
		_ deltaDeadline: TimeInterval,
		task: @escaping (() -> Void)
	) {
		
		// prevents time values less than 0.01 seconds as failsafe
		
		let deadline = DispatchTime.now()
			+ (max(deltaDeadline, 0.01) * NSEC_PER_SEC.double)
			/ NSEC_PER_SEC.double
		
		DispatchQueue.main.asyncAfter(
			deadline: deadline,
			execute: task
		)
		
	}
	
}
