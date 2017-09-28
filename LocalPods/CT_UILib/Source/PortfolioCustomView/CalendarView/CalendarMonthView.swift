//
//  CalendarView.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 3/9/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

public enum CalendarViewOption {
    case shouldHideDaysOfPreviousMonth(Bool)
}

// Need to move it out because we cannot declare struct inside generic class
private struct CalendarMonthView_Constants {
    static let NumberOfDaysInWeek: CGFloat = 7
    static let MaxNumberOfWeeksInMonth: CGFloat = 6
    static let PaddingBetweenCells: CGFloat = 8
    
    static let WeekDaySymbols = Date.veryShortWeekDaySymbols()
}

public protocol CalendarMonthViewDelegate: class {
    func calendarMonthView<dataType>(_ calendarMonthView: CalendarMonthView<dataType>, didLongPressItemWithData data: dataType?)
    func calendarMonthView<dataType>(_ calendarMonthView: CalendarMonthView<dataType>, didReleaseLongPressItemWithData data: dataType?)
}

open class CalendarMonthView <dataType : AnyObject>: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate var dayItems: [dataType]? // Expected: its size is the same as the number of days in corresponding month
    fileprivate var month: Month = Month.currentMonth()
    fileprivate var shouldAnimateAppearing: Bool = false
    
    open var headerLabelStyle: LabelStyleInfo? {
        didSet {
            headerView.labelStyle = headerLabelStyle
        }
    }
    
    // Need to setup both of them at once
    // - "dayItems" is optional
    // - "month" is a must
    open func setup(_ month: Month, dayItems: [dataType]?) {
        self.month = month
        self.dayItems = dayItems
        
        commit()
    }
    
    open func setShouldAnimate(_ shouldAnimateAppearing: Bool) {
        self.shouldAnimateAppearing = shouldAnimateAppearing
    }
    
    fileprivate let CellId = "CalendarDayCell"
    fileprivate var indexOfStartDate: Int = 0
    
    /* Header view to present: Monday, Tuesday, ... */
    open fileprivate(set) var headerView: CalendarHeaderView = {
        let view = CalendarHeaderView()
        view.symbols = CalendarMonthView_Constants.WeekDaySymbols
        return view
    }()
    
    /* Calendar content view */
    fileprivate let calendarContentView: UICollectionView = {
        let layout = CalendarViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = CalendarMonthView_Constants.PaddingBetweenCells
        layout.minimumLineSpacing = CalendarMonthView_Constants.PaddingBetweenCells
        layout.footerReferenceSize = CGSize(width: 0, height: 8)
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        
        return view
    }()
    
    // MARK: - Options for appearance
    fileprivate var shouldHideDaysOfPreviousMonth: Bool = true
    fileprivate var savedLongPressIndexPath: IndexPath?
    open weak var delegate: CalendarMonthViewDelegate?
    
    // MARK: DayCell
    fileprivate var prototypeCalendarDayCell: BaseCalendarDayCell? = CalendarDayCell()
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
    }
    
    public convenience init(options: [CalendarViewOption], prototypeCalendarDayCell: BaseCalendarDayCell? = CalendarDayCell()) {
        self.init(frame: CGRect.zero)
        
        self.prototypeCalendarDayCell = prototypeCalendarDayCell
        // Configure parameters for calendar appearance
        options.forEach { option in
            switch option {
            case let .shouldHideDaysOfPreviousMonth(value):
                shouldHideDaysOfPreviousMonth = value
            }
        }
        
        setupView()
        setupLayout()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        headerView.labelStyle = headerLabelStyle
        
        addSubview(headerView)
        addSubview(calendarContentView)
        
        calendarContentView.backgroundColor = UIColor.clear
        calendarContentView.dataSource = self
        calendarContentView.register(type(of: prototypeCalendarDayCell!), forCellWithReuseIdentifier: CellId)
        
        // Long press gesture
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        calendarContentView.addGestureRecognizer(longPressGesture)
    }
    
    fileprivate func setupLayout() {
        headerView.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(44)
        }
        
        calendarContentView.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    open func commit() {
        let startDateOfMonth = month.getStartDate()
        indexOfStartDate = startDateOfMonth.weekday() - 1
        
        layoutIfNeeded()
        
        reloadData()
    }
    
    fileprivate func reloadData() {
        // tnthuyen: sometimes the number of items per a row are less than expected b/c of the double-division
        // Use floor() to make sure this bug does not happen
        // The difference (regards the width) is not significant. The UI still looks the same
        
        let numWeeksInMonth: CGFloat = CalendarMonthView_Constants.MaxNumberOfWeeksInMonth// ceil(CGFloat(indexOfStartDate + month.numberOfDays()) / CalendarMonthView_Constants.NumberOfDaysInWeek)//nvuy: calulate num of week
        
        let layout = calendarContentView.collectionViewLayout as! CalendarViewFlowLayout
        let itemWidth = Double(calendarContentView.frame.size.width / CalendarMonthView_Constants.NumberOfDaysInWeek).roundDown(toNearest: 0.0001)
        let itemHeight = Double((calendarContentView.frame.size.height - layout.headerReferenceSize.height - layout.footerReferenceSize.height) / numWeeksInMonth).roundDown(toNearest: 0.0001)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        calendarContentView.collectionViewLayout = layout
        
        calendarContentView.reloadData()
    }

    // MARK: - Data to show dates
    fileprivate func dateAtIndexPath(_ indexPath: IndexPath) -> Date {
        let startDateOfMonth = month.getStartDate()
        return startDateOfMonth.dateByAddingDays(indexPath.row - indexOfStartDate)
    }
    
    // dayIndex:
    fileprivate func dayIndexInMonth(_ indexPath: IndexPath) -> Int {
        return indexPath.row - indexOfStartDate
    }

    // MARK: - UICollectionViewDataSource
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexOfStartDate + month.numberOfDays()
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! BaseCalendarDayCell
        
        let dayIndex = dayIndexInMonth(indexPath)
        let date = month.getStartDate().dateByAddingDays(dayIndex)
        
        let data: AnyObject? = (dayItems != nil && dayIndex >= 0 && dayIndex < dayItems!.count) ? dayItems![dayIndex] : nil
        
        // Hide days of previous month (appearing before day 1)
        if shouldHideDaysOfPreviousMonth {
            cell.isHidden = date.month() != month.getStartDate().month()
        }
        
        // Configure cell to show date
        cell.configureCell(date, optionalData: data)
        cell.prepareForAnimateAppearing(self.shouldAnimateAppearing)
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.layoutIfNeeded()
        
        return cell
    }
    
    // MARK: - Long press gesture
    func handleGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: calendarContentView)
        switch gesture.state {
        case .began:
            if let indexPath = calendarContentView.indexPathForItem(at: point), let cell = calendarContentView.cellForItem(at: indexPath) as? BaseCalendarDayCell {
                savedLongPressIndexPath = indexPath
                cell.configureLongPressState(true)
                
                // Call delegate
                let dayIndex = dayIndexInMonth(indexPath)
                let data: dataType? = (dayItems != nil && dayIndex >= 0 && dayIndex < dayItems!.count) ? dayItems![dayIndex] : nil
                delegate?.calendarMonthView(self, didLongPressItemWithData: data)
            }
            
        case .ended, .cancelled, .failed:
            if let indexPath = savedLongPressIndexPath, let cell = calendarContentView.cellForItem(at: indexPath) as? BaseCalendarDayCell {
                cell.configureLongPressState(false)
                delegate?.calendarMonthView(self, didLongPressItemWithData: nil)
                
                // Call delegate
                let dayIndex = dayIndexInMonth(indexPath)
                let data: dataType? = (dayItems != nil && dayIndex >= 0 && dayIndex < dayItems!.count) ? dayItems![dayIndex] : nil
                delegate?.calendarMonthView(self, didReleaseLongPressItemWithData: data)
            }
            
        case _:
            break
        }
    }
    
    // MARK: - Animation
    // tnthuyen: This function is used to animate cells corresponding to specific cells
    fileprivate func animateVisibleCells(_ animateCellClosure: @escaping (UICollectionViewCell, IndexPath) -> ()) {
        DispatchQueue.main.async { 
            let visibleCells = self.calendarContentView.visibleCells
            let visibleCellsWithIndexPaths = visibleCells.map { cell -> (UICollectionViewCell, IndexPath) in
                let indexPath = self.calendarContentView.indexPath(for: cell) ?? IndexPath(row: 0, section: 0)
                return (cell, indexPath)
            }
            
            visibleCellsWithIndexPaths.forEach(animateCellClosure)
        }
    }

    open func animateAppearing() {
        // Calculate delay of each cell
        let calculateDelayFromIndexPath: (IndexPath) -> TimeInterval = { indexPath in
            return Double(indexPath.row) * 0.03
        }
        
        // tnthuyen: Need indexPath to calculate delay
        let cellAnimation: (UICollectionViewCell, IndexPath) -> () = { cell, indexPath in
            guard let cell = cell as? BaseCalendarDayCell else { return }
            cell.animateAppearing(calculateDelayFromIndexPath(indexPath))
        }
        
        animateVisibleCells(cellAnimation)
        
        // Finish animating, set shouldAnimateAppearing = false (as default)
        self.shouldAnimateAppearing = false
    }
}
