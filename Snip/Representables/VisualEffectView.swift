//
//  VisualEffectView.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct VisualEffectMaterialKey: EnvironmentKey {
    typealias Value = NSVisualEffectView.Material?
    static var defaultValue: Value = nil
}

struct VisualEffectBlendingKey: EnvironmentKey {
    typealias Value = NSVisualEffectView.BlendingMode?
    static var defaultValue: Value = nil
}

struct VisualEffectEmphasizedKey: EnvironmentKey {
    typealias Value = Bool?
    static var defaultValue: Bool? = nil
}

extension EnvironmentValues {
    var visualEffectMaterial: NSVisualEffectView.Material? {
        get { self[VisualEffectMaterialKey.self] }
        set { self[VisualEffectMaterialKey.self] = newValue }
    }
    
    var visualEffectBlending: NSVisualEffectView.BlendingMode? {
        get { self[VisualEffectBlendingKey.self] }
        set { self[VisualEffectBlendingKey.self] = newValue }
    }
    
    var visualEffectEmphasized: Bool? {
        get { self[VisualEffectEmphasizedKey.self] }
        set { self[VisualEffectEmphasizedKey.self] = newValue }
    }
}

struct VisualEffectView<Content: View>: NSViewRepresentable {
    private let material: NSVisualEffectView.Material
    private let blendingMode: NSVisualEffectView.BlendingMode
    private let isEmphasized: Bool
    private let content: Content
    
    fileprivate init(
        content: Content,
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode,
        emphasized: Bool) {
        self.content = content
        self.material = material
        self.blendingMode = blendingMode
        self.isEmphasized = emphasized
    }
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        let wrapper = NSHostingView(rootView: content)
        
        // Not certain how necessary this is
        view.autoresizingMask = [.width, .height]
        wrapper.autoresizingMask = [.width, .height]
        wrapper.frame = view.bounds
        wrapper.layer?.backgroundColor = NSColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.6).cgColor
      
        view.addSubview(wrapper)
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = context.environment.visualEffectMaterial ?? material
        nsView.blendingMode = context.environment.visualEffectBlending ?? blendingMode
        nsView.isEmphasized = context.environment.visualEffectEmphasized ?? isEmphasized
    }
}

extension View {
    func visualEffect(
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        emphasized: Bool = false
    ) -> some View {
        VisualEffectView(
            content: self,
            material: material,
            blendingMode: blendingMode,
            emphasized: emphasized
        )
    }
}

