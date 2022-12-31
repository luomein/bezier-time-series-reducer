//
//  BezierTimeSeriesDrawingOption.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/21.
//

import Foundation
import SwiftUI

public struct BezierTimeSeriesDrawingOption : Codable{
    //var showLastPoint : Bool // = false
    public var showTrace : Bool // = true
    public var showReferenceLine : Bool // = true
    public var traceColor : Color // = Color.black
    public var referenceColor : Color // = Color.black
    public var referenceLineWidth : Double //= 2
    public var traceWidth : Double //= 2
    public var plot : Bool //  = true
    public var traceOption : TraceOption? = .all
    public var referenceLineOption : ReferenceLineOption? = .lastOne
    
    public enum TraceOption : Int, Codable{
        
        case lastOne = 0
        case all = 1
    }
    public enum ReferenceLineOption : Int, Codable{
        
        case lastOne = 0
        case all = 1
    }
    
    public static func initFromState(state: SingleBezierTimeSeriesReducer.State)->BezierTimeSeriesDrawingOption{
        return BezierTimeSeriesDrawingOption(
            //showLastPoint: state.showLastPoint,
            showTrace: state.showTrace,
            showReferenceLine: state.showReferenceLine,
            //lastPointColor: state.lastPointColor,
            traceColor: state.traceColor,
            referenceColor: state.referenceColor,
            //lastPointSize: state.lastPointSize,
            referenceLineWidth: state.referenceLineWidth,
            traceWidth: state.traceWidth,
            plot: state.plot,
            traceOption: state.traceOption,
            referenceLineOption : state.referenceLineOption
        )
    }
    
    public static func encodedFromState(state: SingleBezierTimeSeriesReducer.State)->Data{
            let encoder = JSONEncoder()
            do{
                return try encoder.encode(
                    initFromState(state: state)
                )
            }catch{
                fatalError()
            }
        }
}
