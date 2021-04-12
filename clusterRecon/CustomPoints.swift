//
//  CustomPoints.swift
//  clusterRecon
//
//  Created by Rsabie on 13/04/2021.
//

import Foundation


class CustomPoint {
    
    
    //var occurances = 1
    var position : SIMD3<Float>

    
    init(position : SIMD3<Float>) {
        self.position = position
//        occurances = 1
    }
    
//    func incrementOccurances(){
//        occurances = occurances + 1
//    }
    
    
    func calculate(distance end : SIMD3<Float>) -> Float {
        let xDist = self.position.x - end.x
        let yDist = self.position.y - end.y
        let zDist = self.position.z - end.z
        
        let distance = sqrt(pow(xDist, 2) + pow(yDist, 2) + pow(zDist, 2))
        return distance
    }
    
    func calculate(distance end : CustomPoint) -> Float {
        return calculate(distance: end.position)
    }
    
    func isInRange( other : SIMD3<Float>, rangeDim range : Float) -> Bool {
        return self.calculate(distance: other).isLessThanOrEqualTo(range)
    }
    
    func isInRange(other : CustomPoint, rangeDim range : Float) -> Bool {
        return isInRange(other: other.position, rangeDim: range)
    }
    
    
}
