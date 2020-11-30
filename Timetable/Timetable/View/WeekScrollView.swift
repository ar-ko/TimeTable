//
//  WeekScrollView.swift
//  TimeTable
//
//  Created by ar_ko on 26/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

protocol WeekSkrollViewDelegate {
    func indexOfSelectedDay(_ dayIndex: Int)
}

class WeekScrollView: UIView {
    private var daysButtons = [UIButton]()
    private let weeks = 2
    
    var selectedDay: Int? {
        didSet {
            guard let selectedDay = selectedDay else { return }
            selectDay(index: selectedDay)
            self.delegate?.indexOfSelectedDay(selectedDay)
        }
    }
    var delegate: WeekSkrollViewDelegate?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .none
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    var weekTitlelabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .none
        scrollView.delegate = self
        
        setupSubviews()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        let subviews = scrollView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        setupLabel()
        setupButtons()
    }
    
    private func setupSubviews() {        
        scrollView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: (bounds.width),
                                  height: bounds.height - 25)
        self.addSubview(scrollView)
        
        weekTitlelabel = UILabel(frame: CGRect(x: 0, y: scrollView.frame.height, width: bounds.width, height: 25))
        self.addSubview(weekTitlelabel)
    }
    
    private func setupLabel() {
        weekTitlelabel.textColor = .black
        weekTitlelabel.textAlignment = .center
        weekTitlelabel.font = weekTitlelabel.font.withSize(13)
    }
    
    private func setupButtons() {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(weeks + 2), height: scrollView.frame.size.height)
        
        var buttonSize = scrollView.frame.size.width / 11
        var distanceSize = buttonSize / 2
        if buttonSize > scrollView.frame.size.height {
            buttonSize = scrollView.frame.size.height
            distanceSize = (scrollView.frame.size.width - buttonSize * 7) / 8
        }
        
        for weekIndex in 1 ... 4 {
            for dayIndex in 0 ... 6 {
                let index = dayIndex + 7 * (weekIndex % 2)
                
                let x = CGFloat(weekIndex - 1) * scrollView.frame.size.width + distanceSize + (buttonSize + distanceSize) * CGFloat(dayIndex)
                
                let button = UIButton(frame: CGRect(x: x, y: (scrollView.frame.size.height - buttonSize) / 2, width: buttonSize, height: buttonSize))
                button.backgroundColor = .none
                
                button.layer.cornerRadius = button.frame.size.height / 2
                
                let title = indexToDay(index)
                
                button.setTitle("\(title ?? "")", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
                button.setTitleColor(.black, for: .normal)
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button.tag = index
                
                scrollView.addSubview(button)
                daysButtons.append(button)
            }
        }
    }
    
    @objc private func buttonAction(sender: UIButton!) {
        selectedDay = sender.tag
        selectDay(index: sender.tag)
    }
    
    func selectDay(index: Int) {
        scrollView.contentOffset = CGPoint(x: (scrollView.frame.width * CGFloat(1 + (index / 7))), y: 0)

        for button in daysButtons {
            if button.tag == index {
                button.backgroundColor = #colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1)
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .none
                button.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    private func indexToDay(_ index: Int) -> String? {
        switch index {
        case 0, 7: return "Пн"
        case 1, 8: return "Вт"
        case 2, 9: return "Ср"
        case 3, 10: return "Чт"
        case 4, 11: return "Пт"
        case 5, 12: return "Сб"
        case 6, 13: return "Вс"
        default: return nil
        }
    }
}

extension WeekScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xCoordinate = scrollView.contentOffset.x
        
        let currentPage = Int(xCoordinate / scrollView.frame.size.width)
        
        if currentPage % 2 == 0 {
            weekTitlelabel.text = "Синяя неделя"
        } else {
            weekTitlelabel.text = "Белая неделя"
        }
        
        if currentPage == weeks + 1 {
            scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width , y: 0)
        } else if xCoordinate == 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(weeks), y: 0)
        }
    }
}
