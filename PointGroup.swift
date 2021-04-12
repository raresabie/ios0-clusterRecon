//
//  PointGroup.swift
//  clusterRecon
//
//  Created by Rsabie on 13/04/2021.
//

import Foundation


class PointGroup {
    
    
    private var points : [CustomPoint] = []
    var averagePoint : CustomPoint
    
    init(point : CustomPoint) {
        averagePoint = point
        self.addPoint(point: point)
    }
    
    
    func addPoint(point : CustomPoint){
        points.append(point)
        if(points.count != 1){
            averagePoint = CustomPoint(position: getAveragePoint())
        }
        else {
            averagePoint = point
        }
    }
    
    
    private func getAveragePoint () -> SIMD3<Float> {
        let avgX = points.map{$0.position.x}.reduce(0, +) / Float(points.count)
        let avgY = points.map{$0.position.y}.reduce(0, +) / Float(points.count)
        let avgZ = points.map{$0.position.z}.reduce(0, +) / Float(points.count)
        
        return SIMD3<Float>(x: avgX, y: avgY, z: avgZ)
    }
    
    func distance(point : SIMD3<Float>) -> Float? {
        let avgPoint = averagePoint
        
        let xDist = avgPoint.position.x - point.x
        let yDist = avgPoint.position.y - point.y
        let zDist = avgPoint.position.z - point.z
        
        let distance = sqrt(pow(xDist, 2) + pow(yDist, 2) + pow(zDist, 2))
        return distance
    }
    
    func distance(point : CustomPoint) -> Float? {
        return distance(point: point.position)
    }
    
    
}
