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
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Row>

    var reminder: Reminder
    private var dataSource: DataSource?

    init(reminder: Reminder) {
        self.reminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
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
    }

    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        cell.contentConfiguration = contentConfiguration
        cell.tintColor = .todayPrimaryTint
    }

    func text(for row: Row) -> String? {
        switch row {
        case .date: return reminder.dueDate.dayText
        case .note: return reminder.notes
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title: return reminder.title
        }
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
