//
//  ContentView.swift
//  SegueSwiftUI
//
//  Created by Amit Gupta on 8/18/22.
//

import SwiftUI

struct View1: View {
    @Binding var tabSelection: Int
    var body: some View {
        VStack(spacing:20) {
        Text("View 1")
            .font(.system(size: 50))
            Button("Go to Tab 2") {
                self.tabSelection=2
                print("Called segue 1->2")
            }
            Button("Go to Tab 3") {
                print("Called segue 1->3")
                self.tabSelection=3
            }
        }
    }
}

struct View2: View {
    @Binding var tabSelection: Int
    var body: some View {
        VStack(spacing:20) {
        Text("View 2")
            .font(.system(size: 50))
            Button("Go to Tab 1") {
                print("Called segue 2->1")
                self.tabSelection=1
            }
            Button("Go to Tab 3") {
                print("Called segue 2->3")
                self.tabSelection=3
            }
        }
    }
}

struct View3: View {
    @Binding var tabSelection: Int
    var body: some View {
        VStack(spacing:20) {
        Text("View 3")
            .font(.system(size: 50))
            Button("Go to Tab 1") {
                print("Called segue 3->1")
                self.tabSelection=1
            }
            Button("Go to Tab 2") {
                print("Called segue 3->2")
                self.tabSelection=2
            }
        }
    }
}

struct MultiTab: View {
    @State private var tabSelection=1
    var body: some View {
        TabView(selection:$tabSelection) {
            View1(tabSelection: $tabSelection)
                .tabItem{
                   Label("View1",systemImage: "list.dash")
                }
                .tag(1)
            View2(tabSelection: $tabSelection)
                .tabItem{
                   Label("View2",systemImage: "list.dash")
                }
                .tag(2)
            View3(tabSelection: $tabSelection)
                .tabItem{
                   Label("View3",systemImage: "list.dash")
                }
                .tag(3)
        }
        .tolerantGesture(leftAction: leftAction, rightAction: rightAction, upAction: upAction, downAction: downAction)
        /*
        .leftGesture {
            print("Saw left gesture")
        }
        .rightGesture {
            print("Saw right gesture")
        }
        .downGesture {
            print("Saw down gesture")
        }
        .upGesture {
            print("Saw up gesture")
        }
         */
    }
    
    func leftAction() {
        print("Left Action")
        self.tabSelection=self.tabSelection+1
        if(self.tabSelection>3){
            self.tabSelection=1
        }
    }
    
    func rightAction() {
        print("Right Action")
        self.tabSelection=self.tabSelection-1
        if(self.tabSelection<1){
            self.tabSelection=3
        }
    }
    func upAction() {
        print("Up Action")
        self.tabSelection=2
    }
    func downAction() {
        print("Down Action")
        self.tabSelection=3
    }
}

struct ContentView: View {
    var body: some View {
        MultiTab()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //MultiTab()
    }
}


/*
 * From https://stackoverflow.com/questions/59109138/how-to-implement-a-left-or-right-draggesture-that-trigger-a-switch-case-in-swi
 */

extension DragGesture.Value {
    
     func detectDirectionOrig(_ tolerance: Double = 24) -> Direction? {
        if startLocation.x < location.x - tolerance { return .left }
        if startLocation.x > location.x + tolerance { return .right }
        if startLocation.y > location.y + tolerance { return .up }
        if startLocation.y < location.y - tolerance { return .down }
        return nil
    }
    
    func detectDirection(_ tolerance: Double = 24) -> Direction? {
        //print("Calling detectDirection with height \(translation.height) and width \(translation.width)")
        if translation.width < 0 - tolerance { return .left }
        if translation.width > tolerance { return .right }
        if translation.height < 0-tolerance { return .up }
        if translation.height > tolerance { return .down }
        return nil
    }
    
    enum Direction {
        case left
        case right
        case up
        case down
    }
}

extension View {
    
    public func tolerantGesture(tolerance: Double = 24, leftAction: @escaping () -> (),
                                rightAction: @escaping () -> (),
                                upAction: @escaping () -> (),
                                downAction: @escaping () -> ()) -> some View {
        gesture(DragGesture()
            .onEnded { value in
                let direction = value.detectDirection(tolerance)
                if direction == .left {
                    leftAction()
                }
                if direction == .right {
                    rightAction()
                }
                if direction == .up {
                    upAction()
                }
                if direction == .down {
                    downAction()
                }
                //print("Ended drag gesture: translation is \(value.translation), with component \(value.translation.height) and \(value.translation.width)")
            }
        )
    }
    
    public func leftGesture(tolerance: Double = 24, action: @escaping () -> ()) -> some View {
        gesture(DragGesture()
            .onEnded { value in
                let direction = value.detectDirection(tolerance)
                if direction == .left {
                    action()
                }
                //print("Ended drag gesture: translation is \(value.translation), with component \(value.translation.height) and \(value.translation.width)")
            }
        )
    }
    
    public func rightGesture(tolerance: Double = 24, action: @escaping () -> ()) -> some View {
        gesture(DragGesture()
            .onEnded { value in
                let direction = value.detectDirection(tolerance)
                if direction == .right {
                    action()
                }
            }
        )
    }
    
    public func downGesture(tolerance: Double = 24, action: @escaping () -> ()) -> some View {
        gesture(DragGesture()
            .onEnded { value in
                let direction = value.detectDirection(tolerance)
                if direction == .down {
                    action()
                }
            }
        )
    }
    
    public func upGesture(tolerance: Double = 24, action: @escaping () -> ()) -> some View {
        gesture(DragGesture()
            .onEnded { value in
                let direction = value.detectDirection(tolerance)
                if direction == .up {
                    action()
                }
            }
        )
    }
}


