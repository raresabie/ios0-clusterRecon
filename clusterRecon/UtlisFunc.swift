//
//  UtlisFunc.swift
//  clusterRecon
//
//  Created by Rsabie on 13/04/2021.
//

import Foundation

func calculateDistance(start : SIMD3<Float>, end : SIMD3<Float>) -> Float{
    
    let xDist = start.x - end.x
    let yDist = start.y - end.y
    let zDist = start.z - end.z
    
    let distance = sqrt(pow(xDist, 2) + pow(yDist, 2) + pow(zDist, 2))
    return distance
}



