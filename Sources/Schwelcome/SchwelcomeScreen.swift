//
//  WelcomeScreen.swift
//  Taro
//
//  Created by Brianna Zamora on 9/21/21.
//

import SwiftUI

public struct SchwelcomeScreen: View {
    
    public var title: String?
    public var customFontName: String?
    public var continueButtonText: String?
    public var doneButtonText: String?
    
    @Binding public var hasLaunchedBefore: Bool
    @Binding public var isPresented: Bool
    
    public var features: [Feature]
    
    #if os(iOS) || os(macOS)
    @State private var height = CGFloat.zero
    #endif
    
    public init(
        title: String? = nil,
        customFontName: String? = nil,
        continueButtonText: String? = nil,
        doneButtonText: String? = nil,
        hasLaunchedBefore: Binding<Bool>,
        isPresented: Binding<Bool>,
        features: [Feature]
    ) {
        self.title = title
        self.customFontName = customFontName
        self.continueButtonText = continueButtonText
        self.doneButtonText = doneButtonText
        self._hasLaunchedBefore = hasLaunchedBefore
        self._isPresented = isPresented
        self.features = features
    }
    
    public var body: some View {
        
        #if os(watchOS)
        let titleView = Text(title ?? "Welcome")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        #else
        let titleView = Group {
            Spacer()
            Text(title ?? "Welcome")
                .font(customFontName == nil ? .largeTitle : .custom(customFontName!, size: 34, relativeTo: .largeTitle))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
            Spacer()
        }
        #endif
        
        let featureViews = Group {
            ForEach(features) { feature in
                FeatureCell(feature: feature)
            }
        }
        .lineLimit(nil)
        
        let button = Button {
            isPresented = false
            hasLaunchedBefore = true
        } label: {
            HStack {
                Spacer()
                Text(continueButtonText ?? "Continue")
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .background(Color("AccentColor"))
        .cornerRadius(10)
        
        #if os(watchOS)
        let views = Group {
            titleView
            featureViews
            button
        }
        #elseif os(iOS)
        let views = Group {
            titleView
            
            VStack(alignment: .leading, spacing: 24) {
                featureViews
            }
            .padding(.leading)
            
            Spacer()
            Spacer()
            
            button
                .frame(height: 50)
        }
        .padding()
        .frame(height: height)
        #elseif os(macOS)
        let views = VStack {
            titleView
            
            VStack(alignment: .leading, spacing: 24) {
                features
            }
            .padding(.leading)
            
            Spacer()
            
            button
                .frame(height: 50)
                .layoutPriority(1000)
        }
        .padding()
        #endif
        
        #if os(iOS)
        ScrollView(.vertical, showsIndicators: false) {
            views
        }
        .background(
            GeometryReader { geometry in
                Color.clear.onAppear {
                    height = geometry.size.height
                }
            }
        )
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    hasLaunchedBefore = true
                    isPresented = false
                } label: {
                    Text(continueButtonText ?? "Continue")
                }
            }
        }
        #elseif os(watchOS)
        List {
            views
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    hasLaunchedBefore = true
                    showingOnboarding = false
                } label: {
                    Text(doneButtonText ?? "Done")
                }
            }
        }
        #elseif os(macOS)
        VStack {
            views
        }
        #endif
    }
}

struct SchwelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        SchwelcomeScreen(
            title: nil,
            customFontName: nil,
            continueButtonText: nil,
            doneButtonText: nil,
            hasLaunchedBefore: .constant(false),
            isPresented: .constant(true),
            features: [
                Feature(
                    image: "circle.fill",
                    title: "Feature",
                    subtitle: "This is a preview of a feature preview 🤯",
                    color: .orange
                )
            ]
        )
    }
}
