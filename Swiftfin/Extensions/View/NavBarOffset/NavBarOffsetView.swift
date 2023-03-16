//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import SwiftUI

struct NavBarOffsetView: UIViewControllerRepresentable {

    @Binding
    private var scrollViewOffset: CGFloat

    private let start: CGFloat
    private let end: CGFloat
    private let content: () -> any View

    init(
        scrollViewOffset: Binding<CGFloat>,
        start: CGFloat,
        end: CGFloat,
        @ViewBuilder content: @escaping () -> any View
    ) {
        self._scrollViewOffset = scrollViewOffset
        self.start = start
        self.end = end
        self.content = content
    }

    init(
        start: CGFloat,
        end: CGFloat,
        @ViewBuilder body: @escaping () -> any View
    ) {
        self._scrollViewOffset = Binding(get: { 0 }, set: { _ in })
        self.start = start
        self.end = end
        self.content = body
    }

    func makeUIViewController(context: Context) -> UINavBarOffsetHostingController {
        let a = UINavBarOffsetHostingController(rootView: content().eraseToAnyView())
        a.additionalSafeAreaInsets = .zero
        return a
    }

    func updateUIViewController(_ uiViewController: UINavBarOffsetHostingController, context: Context) {
        uiViewController.scrollViewDidScroll(scrollViewOffset, start: start, end: end)
    }
}

class UINavBarOffsetHostingController: UIHostingController<AnyView> {

    private var lastScrollViewOffset: CGFloat = 0

    private lazy var navBarBlurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = nil

        view.addSubview(navBarBlurView)
        navBarBlurView.alpha = 0

        NSLayoutConstraint.activate([
            navBarBlurView.topAnchor.constraint(equalTo: view.topAnchor),
            navBarBlurView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBarBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func scrollViewDidScroll(_ offset: CGFloat, start: CGFloat, end: CGFloat) {
        let diff = end - start
        let currentProgress = (offset - start) / diff
        let offset = min(max(currentProgress, 0), 1)

        navigationController?.navigationBar
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(offset)]
        navBarBlurView.alpha = offset
        lastScrollViewOffset = offset
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(lastScrollViewOffset)]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
}
