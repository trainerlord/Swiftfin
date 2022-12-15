//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import SwiftUI
import UIKit

// MARK: PreferenceUIHostingController

class PreferenceUIHostingController: UIHostingController<AnyView> {

    init<V: View>(@ViewBuilder wrappedView: @escaping () -> V) {
        let box = Box()
        super.init(rootView: AnyView(
            wrappedView()
                .onPreferenceChange(ViewPreferenceKey.self) {
                    box.value?._viewPreference = $0
                }
                .onPreferenceChange(DidPressMenuPreferenceKey.self) {
                    box.value?.didPressMenuAction = $0
                }
        ))
        box.value = self

        addButtonPressRecognizer(pressType: .menu, action: #selector(didPressMenuSelector))
    }

    @objc
    dynamic required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.modalPresentationStyle = .fullScreen
    }

    private class Box {
        weak var value: PreferenceUIHostingController?
        init() {}
    }

    public var _viewPreference: UIUserInterfaceStyle = .unspecified {
        didSet {
            overrideUserInterfaceStyle = _viewPreference
        }
    }

    var didPressMenuAction: ActionHolder = .init(action: {})

//    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
//        guard let pressType = presses.first?.type else { return }
//
//        print("Press: \(pressType)")
//
//        switch pressType {
//        case .menu:
//            didPressMenuAction.action()
//        default: ()
//        }
//    }

    private func addButtonPressRecognizer(pressType: UIPress.PressType, action: Selector) {
        let pressRecognizer = UITapGestureRecognizer()
        pressRecognizer.addTarget(self, action: action)
        pressRecognizer.allowedPressTypes = [NSNumber(value: pressType.rawValue)]
        view.addGestureRecognizer(pressRecognizer)
    }

    @objc
    private func didPressMenuSelector() {
        didPressMenuAction.action()
    }
}

struct ActionHolder: Equatable {

    static func == (lhs: ActionHolder, rhs: ActionHolder) -> Bool {
        lhs.uuid == rhs.uuid
    }

    var action: () -> Void
    let uuid = UUID().uuidString
}

// MARK: Preference Keys

struct ViewPreferenceKey: PreferenceKey {
    typealias Value = UIUserInterfaceStyle

    static var defaultValue: UIUserInterfaceStyle = .unspecified

    static func reduce(value: inout UIUserInterfaceStyle, nextValue: () -> UIUserInterfaceStyle) {
        value = nextValue()
    }
}

struct DidPressMenuPreferenceKey: PreferenceKey {

    static var defaultValue: ActionHolder = .init(action: {})

    static func reduce(value: inout ActionHolder, nextValue: () -> ActionHolder) {
        value = nextValue()
    }
}

// MARK: Preference Key View Extension

extension View {

    func overrideViewPreference(_ viewPreference: UIUserInterfaceStyle) -> some View {
        preference(key: ViewPreferenceKey.self, value: viewPreference)
    }

    func onMenuPressed(_ action: @escaping () -> Void) -> some View {
        preference(key: DidPressMenuPreferenceKey.self, value: ActionHolder(action: action))
    }
}