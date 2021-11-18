//
//  File.swift
//  
//
//  Created by Bri on 10/22/21.
//

import SwiftUI

public struct DisplaySchwelcomeScreen: ViewModifier {
    
    @Binding public var isPresented: Bool
    public var title: String?
    public var customFontName: String?
    public var continueButtonText: String?
    public var doneButtonText: String?
    @AppStorage("hasLaunchedBefore") fileprivate var hasLaunchedBefore: Bool = false
    public var features: () -> [Feature]
    
    internal init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        customFontName: String? = nil,
        continueButtonText: String? = nil,
        doneButtonText: String? = nil,
        features: @escaping () -> [Feature]
    ) {
        self._isPresented = isPresented
        self.title = title
        self.customFontName = customFontName
        self.continueButtonText = continueButtonText
        self.doneButtonText = doneButtonText
        self.features = features
    }
    
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                SchwelcomeScreen(
                    title: title,
                    customFontName: customFontName,
                    continueButtonText: continueButtonText,
                    doneButtonText: doneButtonText,
                    hasLaunchedBefore: $hasLaunchedBefore,
                    isPresented: $isPresented,
                    features: features()
                )
            }
            .onAppear {
                if !hasLaunchedBefore {
                    isPresented = true
                }
            }
    }
}

public extension View {
    func schwelcomeScreen(
        isPresented: Binding<Bool>,
        title: String? = nil,
        customFontName: String? = nil,
        continueButtonText: String? = nil,
        doneButtonText: String? = nil,
        features: @escaping () -> [Feature]
    ) -> some View {
        modifier(
            DisplaySchwelcomeScreen(
                isPresented: isPresented,
                title: title,
                customFontName: customFontName,
                continueButtonText: continueButtonText,
                doneButtonText: doneButtonText,
                features: features
            )
        )
    }
}
