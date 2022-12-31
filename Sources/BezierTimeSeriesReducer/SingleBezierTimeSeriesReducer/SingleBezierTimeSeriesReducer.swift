//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2022/12/31.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import MultipleTimeSeriesReducer
import LuomeinSwiftBasicTools

public struct SingleBezierTimeSeriesReducer: ReducerProtocol{
    @Dependency(\.uuid) var uuid
    public init(){
        
    }
    public struct State: Equatable {
        public var trace : MultipleTimeSeriesReducer.State
        public var showTrace = true
        public var showReferenceLine = true
        public var traceColor = Color.black
        public var referenceColor = Color.black
        public var referenceLineWidth : Double = 2
        public var traceWidth : Double = 2
        public var plot = true
        public var popoverEditingState: PopoverEditingState?
        public var traceOption : BezierTimeSeriesDrawingOption.TraceOption = .all
        public var referenceLineOption : BezierTimeSeriesDrawingOption.ReferenceLineOption = .lastOne
        
        public init(drawingOption: BezierTimeSeriesDrawingOption){
            self.plot = drawingOption.plot
            //self.showLastPoint = drawingOption.showLastPoint
            self.showTrace = drawingOption.showTrace
            self.showReferenceLine = drawingOption.showReferenceLine
            //self.lastPointColor = drawingOption.lastPointColor
            self.traceColor = drawingOption.traceColor
            self.referenceColor = drawingOption.referenceColor
            //self.lastPointSize = drawingOption.lastPointSize
            self.referenceLineWidth = drawingOption.referenceLineWidth
            self.traceWidth = drawingOption.traceWidth
            self.referenceLineOption = drawingOption.referenceLineOption ?? .lastOne
            self.traceOption = drawingOption.traceOption ?? .all
            
            trace = .initFromOrigin(richPoints: [])
        }
        
        public struct PopoverEditingState: Equatable{
            public var plot = true
            public var showLastPoint = false
            public var showTrace = true
            public var showReferenceLine = true
            public var lastPointColor = Color.black
            public var traceColor = Color.black
            public var referenceColor = Color.black
            public var lastPointSize : Double = 5
            public var referenceLineWidth : Double = 2
            public var traceWidth : Double = 2
            public var traceOption : BezierTimeSeriesDrawingOption.TraceOption = .all
            public var referenceLineOption : BezierTimeSeriesDrawingOption.ReferenceLineOption = .lastOne
            
            func updateState( state: inout State){
                state.plot = self.plot
                //                state.showLastPoint = self.showLastPoint
                state.showTrace = self.showTrace
                state.showReferenceLine = self.showReferenceLine
                //state.lastPointColor = self.lastPointColor
                state.traceColor = self.traceColor
                state.referenceColor = self.referenceColor
                //state.lastPointSize = self.lastPointSize
                state.referenceLineWidth = self.referenceLineWidth
                state.traceWidth = self.traceWidth
                state.referenceLineOption = self.referenceLineOption
                state.traceOption = self.traceOption
                
                
                
            }
            public init(){
                
            }
            public init(from state: State){
                self.plot = state.plot
                //self.showLastPoint = state.showLastPoint
                self.showTrace = state.showTrace
                self.showReferenceLine = state.showReferenceLine
                //self.lastPointColor = state.lastPointColor
                self.traceColor = state.traceColor
                self.referenceColor = state.referenceColor
                //self.lastPointSize = state.lastPointSize
                self.referenceLineWidth = state.referenceLineWidth
                self.traceWidth = state.traceWidth
                self.referenceLineOption = state.referenceLineOption
                self.traceOption = state.traceOption
            }
            
        }
        
    }
    public enum Action : Equatable{
        //        case calculateNewPoint(referencePoints: MultipleTimeSeriesPointsReducer.State, t: Double)
        //        case recalculateTrace(referencePoints: MultipleTimeSeriesPointsReducer.State, tick: Double, totalTicks: Double)
        case startPopoverEdit
        case popoverEditing(State.PopoverEditingState?)
        case plot(Bool)
    }
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action{
        case .plot(let value):
            state.plot = value
            return .none
        case .startPopoverEdit:
            state.popoverEditingState = State.PopoverEditingState(from: state)
            return .none
        case .popoverEditing(let value):
            state.popoverEditingState = value
            if let value = value{
                let beforeUpdate = State.PopoverEditingState(from: state)
                value.updateState(state: &state)
                if beforeUpdate != value{
                    if beforeUpdate.plot && !value.plot{
                        return .none
                    }
                    else{
                        state.popoverEditingState!.plot = true
                        return EffectTask(value: .plot(true))
                    }
                }
                
            }
            return .none
        }
    }
}
