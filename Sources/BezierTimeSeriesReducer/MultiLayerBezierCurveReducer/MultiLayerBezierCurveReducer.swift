//
//  MultiLayerBezierCurveReducer.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/19.
//

import Foundation
import ComposableArchitecture
import IdentifiedCollections
import MultipleTimeSeriesReducer
import LuomeinSwiftBasicTools


public struct MultiLayerBezierCurveReducer{
    @Dependency(\.environmentVariables) var environmentVariables
    @Dependency(\.uuid) var uuid
    
//    func initBezier1stDefaultParameter()->BezierTimeSeriesPointsReducer.State{
//        return .init(trace: .initFromOrigin(points: []))
//    }
    public init(){}
    public enum Action : Equatable{
        case recalculateTrace(tick: Double, totalTicks: Double)
        case calculateNewPoint(t:Double)
        case notificationPosizitionChanged
        case jointControlPointsReducer(MultipleTimeSeriesReducer.Action)
        case jointBezier1stReducer(SingleBezierTimeSeriesReducer.Action)
        case jointBezier2ndReducer(SingleBezierTimeSeriesReducer.Action)
        case jointBezier3rdReducer(SingleBezierTimeSeriesReducer.Action)
        case jointBezier4thReducer(SingleBezierTimeSeriesReducer.Action)
        case jointBezier5thReducer(SingleBezierTimeSeriesReducer.Action)
        case saveState(Data, String)
        case addSnapshot
    }
    public struct DebounceID : Hashable{
        public init(){}
    }
    
    

    public func calculateLocation(start:CGPoint, end:CGPoint, t: Double)->CGPoint{
            return CGPoint(x: (1.0-t) * start.x + t * end.x , y:  (1.0-t) * start.y + t * end.y )
        }
    
    public func calculateNewPoint(referencePoints: MultipleTimeSeriesReducer.State, t: Double, state: inout MultipleTimeSeriesReducer.State){
        //assert(referencePoints.multipleSeries.count>=2)
        guard referencePoints.multipleSeries.count >= 2 else{return}
        var referencePointsCopy = referencePoints
        var tempPt = referencePointsCopy.multipleSeries.removeFirst().timeSeries.last!
        let result = referencePointsCopy.multipleSeries.reduce([CGPoint]()) { partialResult, element in
            
            let combined = partialResult + [calculateLocation(start: tempPt.point, end: element.timeSeries.last!.point, t: t)]
            tempPt = element.timeSeries.last!
            return combined
        }
        if state.multipleSeries.count > 0 {
            let combined = Array(zip(state.multipleSeries, result))
            state.multipleSeries = IdentifiedArray(uniqueElements:
                                                    combined.map({
                SingleTimeSeriesReducer.State(id: $0.0.id, timeSeries: $0.0.timeSeries +
                                              SingleTimeSeriesReducer.State.initFromOrigin(point: $0.1,
                                                                                           stateId: uuid(), pointID: uuid()                                          ).timeSeries
                )
            })
            )
            
        }else{
            state.multipleSeries = IdentifiedArray(uniqueElements: result.map({ //IdentifiedCGPointArray(id: uuid(), ptArray:  [$0] )
                SingleTimeSeriesReducer.State.initFromOrigin(point: $0,
                                                             stateId: uuid(), pointID: uuid()
                )
                
            }) )
        }
    }
}
