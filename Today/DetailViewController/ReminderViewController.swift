//
//  ReminderViewController.swift
//  Today
//
//  Created by Tom Choi on 2/19/26.
//

import UIKit

final class ReminderViewController: UICollectionViewController {
    /// Main actor-isolated conformance of 'ReminderViewController.Row' to 'Hashable' cannot satisfy conformance requirement for a 'Sendable' type parameter 'ItemIdentifierType'
    /// Requirement specified as 'ItemIdentifierType' : 'Hashable' [with ItemIdentifierType = ReminderViewController.Row]
    /// 위의 오류가 무었인지 모르겠음.

    /// UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
    /// - SectionIdentifierType: 컬렉션 뷰의 섹션을 식별하는 타입입니다. (여기서는 Int 사용)
    /// - ItemIdentifierType: 각 항목(셀)을 식별하는 타입입니다. (여기서는 Row 사용, Hashable 준수 필수)
    /// 데이터 소스는 이 식별자들을 사용해 데이터의 변경 사항(Diff)을 계산하고 UI를 자동으로 업데이트합니다.

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Row>

    var reminder: Reminder
    var workingReminder: Reminder
    private var dataSource: DataSource?

    init(reminder: Reminder) {
        self.reminder = reminder
        self.workingReminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellRegistration = UICollectionView.CellRegistration.init(
            handler: cellRegistrationHandler
        )
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        navigationItem.style = .navigator
        navigationItem.title = NSLocalizedString(
            "Reminder",
            comment: "Reminder view controller title"
        )
        navigationItem.rightBarButtonItem = editButtonItem

        updateSnapshotForViewing()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            prepareForEditing()
        } else {
            prepareForViewing()
        }
    }

    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case (_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case (.title, .editableText(let text)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: text)
        case (.date, .editableDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        case (.notes, .editableText(let notes)):
            cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
        default:
            fatalError()
        }
        cell.tintColor = .todayPrimaryTint
    }

    @objc func didCancelEdit() {
        workingReminder = reminder
        setEditing(false, animated: true)
    }

    private func prepareForEditing() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didCancelEdit)
        )
        updateSnapshotForEditing()
    }

    private func updateSnapshotForEditing() {
        var snapshot = SnapShot()
        snapshot.appendSections([.title, .date, .notes])
        snapshot
            .appendItems(
                [.header(Section.title.name), .editableText(reminder.title)],
                toSection: .title
            )
        snapshot.appendItems(
            [.header(Section.date.name), .editableDate(reminder.dueDate)],
            toSection: .date
        )
        snapshot.appendItems(
            [.header(Section.notes.name), .editableText(reminder.notes)],
            toSection: .notes
        )

        dataSource?.apply(snapshot)
    }

    private func prepareForViewing() {
        navigationItem.leftBarButtonItem = nil
        if workingReminder != reminder {
            reminder = workingReminder
        }
        updateSnapshotForViewing()
    }

    private func updateSnapshotForViewing() {
        var snapshot = SnapShot()
        snapshot.appendSections([.view])
        snapshot.appendItems([.header(""), .title, .date, .time, .note], toSection: .view)
        dataSource?.apply(snapshot)
    }

    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError()
        }
        return section
    }
}

/*
 ReminderViewController는 @MainActor입니다.
 UICollectionViewController를 상속받기 때문에, 이 클래스와 그 안에 포함된 모든 타입(Row 열거형 포함)은 기본적으로 **메인 스레드(Main Thread)**에서만 동작하도록 격리됩니다.
 DataSource는 Sendable을 요구합니다.
 UICollectionViewDiffableDataSource는 데이터를 백그라운드 스레드에서 비교(Diffing)할 수도 있기 때문에, 데이터 타입(Row)이 스레드 간에 안전하게 전달될 수 있는 Sendable 타입이어야 한다고 요구합니다.
 충돌 발생!
 Row는 @MainActor에 묶여 있어 다른 스레드로 보내질 수 없는데(Not Sendable), DataSource는 그것을 요구하니 오류가 발생한 것입니다.
 */

#Preview {
    UINavigationController(
        rootViewController: ReminderViewController(reminder: Reminder.sampleData[0])
    )
}
