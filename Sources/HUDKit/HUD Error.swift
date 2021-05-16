//
//  HUD Error.swift
//  HUDKit
//
//  Created by Steffan Andrews on 2021-05-15.
//

extension HUD {
	
	public enum HUDError: Error {
		
		case internalInconsistency(_ verboseError: String)
		
	}
	
}
