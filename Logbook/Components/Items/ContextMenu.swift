//
//  ContextMenu.swift
//  Logbook
//
//  Created by Thomas on 05.08.22.
//

import Foundation
import UIKit
import SwiftUI

extension View {
    func contextMenuWithPreview<Content: View>(
        actions: [UIAction],
        @ViewBuilder preview: @escaping () -> Content
    ) -> some View {
        self.overlay(
            InteractionView(
                preview: preview,
                menu: UIMenu(title: "", children: actions),
                didTapPreview: {}
            )
        )
    }
}

private struct InteractionView<Content: View>: UIViewRepresentable {
    @ViewBuilder let preview: () -> Content
    let menu: UIMenu
    let didTapPreview: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let menuInteraction = UIContextMenuInteraction(delegate: context.coordinator)
        view.addInteraction(menuInteraction)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            preview: preview(),
            menu: menu,
            didTapPreview: didTapPreview
        )
    }
    
    class Coordinator: NSObject, UIContextMenuInteractionDelegate {
        let preview: Content
        let menu: UIMenu
        let didTapPreview: () -> Void
        
        init(preview: Content, menu: UIMenu, didTapPreview: @escaping () -> Void) {
            self.preview = preview
            self.menu = menu
            self.didTapPreview = didTapPreview
        }
        
        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            configurationForMenuAtLocation location: CGPoint
        ) -> UIContextMenuConfiguration? {
            UIContextMenuConfiguration(
                identifier: nil,
                previewProvider: { [weak self] () -> UIViewController? in
//                    guard let self = self else { return nil }
                    return UIHostingController(rootView: self!.preview)
                },
                actionProvider: { [weak self] _ in
                    guard let self = self else { return nil }
                    return self.menu
                }
            )
        }
        
        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
            animator: UIContextMenuInteractionCommitAnimating
        ) {
            animator.addCompletion(self.didTapPreview)
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView()
    let tasks = [
        TaskStruckt(id: "S_1001", name: "Laundry", description: "Wash all the clothes.", tagColor: .blue),
        TaskStruckt(id: "S_1002", name: "Pick up kids", description: "Pick up the kids from the school.", tagColor: .red),
        TaskStruckt(id: "S_1003", name: "Walk the dog", description: "Walk the dog in the morning", tagColor: .green),
        TaskStruckt(id: "S_1004", name: "Yoga class", description: "The yoga class begins at 5 pm.", tagColor: .purple)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = UIScreen.main.bounds
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = task.tagColor
        cell.textLabel?.text = task.name
        return cell
    }
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let task = tasks[indexPath.row]
        return UIContextMenuConfiguration(identifier: task.id as NSString, previewProvider: nil) { _ in
            let shareAction = UIAction(
              title: "Share",
              image: UIImage(systemName: "square.and.arrow.up")) { _ in
                // share the task
            }
            let copyAction = UIAction(
              title: "Copy",
              image: UIImage(systemName: "doc.on.doc")) { _ in
                // copy the task content
            }
            let deleteAction = UIAction(
              title: "Delete",
              image: UIImage(systemName: "trash"),
              attributes: .destructive) { _ in
                // delete the task
            }
            return UIMenu(title: "", children: [shareAction, copyAction, deleteAction])
        }
    }
    // Show actual view when pressed on preview
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let identifier = (configuration.identifier as? NSString) as String? else { return }
        let task = tasks.first { $0.id == identifier }
        if task != nil {
            animator.addCompletion {
                let previewController = TaskPreviewController()
                previewController.task = task!
                self.show(previewController, sender: self)
            }
        }
    }
}
class TaskPreviewController: UIViewController {
    let label = UILabel()
    var task: TaskStruckt = TaskStruckt(id: "", name: "TEST", description: "DESC", tagColor: .blue)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100).isActive = true
        label.text = task.description
    }
}
struct TaskStruckt {
    let id: String
    let name: String
    let description: String
    var tagColor: UIColor
}

struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [controllers[currentPage]], direction: .forward, animated: true)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        
        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return parent.controllers.last
            }
            return parent.controllers[index - 1]
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.controllers.count {
                return parent.controllers.first
            }
            return parent.controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = parent.controllers.firstIndex(of: visibleViewController)
            {
                parent.currentPage = index
            }
        }
    }
}
