//
//  ViewController.swift
//  CollectionViewsDemo
//
//  Created by Ayemere  Odia  on 2022/10/22.
//

import UIKit

class ViewController: UIViewController {

    private var layout: CustomLayout!
    private var collectionView: UICollectionView!
    var feedViewContoller: FeedViewController!
    
    private lazy var profileCircle: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.backgroundColor = .purple
        view.layer.cornerRadius = view.bounds.height / 2
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = CustomLayout()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .darkGray
        view.addSubview(collectionView)
        
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: PersonCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "pencil.circle"), style: .plain, target: self, action: .actionName)
        rightBarButton.tintColor = .purple
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileCircle)
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.title = "Friends"

    }
    
    @objc static func goSlow() {
        
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCell.identifier, for: indexPath) as! PersonCell
        cell.configureCell(with: people[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if feedViewContoller == nil {
            feedViewContoller = FeedViewController(collectionViewLayout: MosaicLayout())
            feedViewContoller?.person = people[indexPath.row]
            navigationController?.pushViewController(feedViewContoller, animated: true)
        }
    }
}

class CustomLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let cv = collectionView else { return }
        let availableCellwidth = cv.bounds.inset(by: cv.layoutMargins).size.width
        let minColumnWidth = CGFloat(300.0)
        let maxNumberColums = Int(availableCellwidth / minColumnWidth)
        let cellWidth = (availableCellwidth / CGFloat(maxNumberColums)).rounded(.down)
        
        self.itemSize = CGSize(width: cellWidth, height: 70)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea
    }
}

class PersonCell: UICollectionViewCell {
    static let identifier = String(describing: ImageCell.self)
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.tintColor = .purple
        return imageView
    }()
    
    private let profileHeader: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let lastUpdatedMessage: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let innerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileHeader.translatesAutoresizingMaskIntoConstraints = false
        lastUpdatedMessage.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(outerStackView)
        
        innerStackView.addArrangedSubview(profileHeader)
        innerStackView.addArrangedSubview(lastUpdatedMessage)
        
        outerStackView.addArrangedSubview(profileImage)
        outerStackView.addArrangedSubview(innerStackView)
        
        setupLayout()
        backgroundColor = .lightGray
        layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with model: Person) {
        profileImage.image = model.image
        profileHeader.text = "\(model.name)'s Feed"
        lastUpdatedMessage.text = "Updated \(model.profileDate)"
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

struct Person {
    let image: UIImage?
    let profileDate: String
    let name: String
    let feedImages = [
        UIImage(named: "beach1")!,
        UIImage(named: "beach2")!,
        UIImage(named: "beach3")!,
        UIImage(named: "beach4")!,
        UIImage(named: "beach5")!,
        UIImage(named: "beach6")!,
        UIImage(named: "beach7")!,
        UIImage(named: "beach8")!,
        UIImage(named: "beach9")!,
        UIImage(named: "beach10")!,
        UIImage(named: "beach11")!,
        UIImage(named: "beach12")!,
        UIImage(named: "beach13")!,
        UIImage(named: "beach14")!,
        UIImage(named: "beach15")!,
    ]
}

extension Selector {
    static let actionName = #selector(ViewController.goSlow)
}

let people = [
    Person(image: "👳🏻‍♂️".emojiToImage(), profileDate: "Updated May 20, 2018", name: "Saleh"),
    Person(image: "👱🏼‍♀️".emojiToImage(), profileDate: "Updated April 10, 2018", name: "Angela"),
    Person(image: "🧔🏼‍♂️".emojiToImage(), profileDate: "Updated June 11, 2018", name: "Joy"),
    Person(image: "🧑🏽‍🦰".emojiToImage(), profileDate: "Updated Feb 28, 2018", name: "Daniel")
]


extension String {
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 30, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(rect)
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class ImageCell: UICollectionViewCell {
    static let identifier = String(describing: ImageCell.self)
    private let imageView: UIImageView
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with image: UIImage?){
        guard let image = image else {
            return
        }

        imageView.image = image
    }
    
    override var reuseIdentifier: String? {
        return ImageCell.identifier
    }
}

class FeedViewController: UICollectionViewController {
    
    var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(person.name)'s Feed"
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        person.feedImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        cell.configureCell(with: person.feedImages[indexPath.item])
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

class MosaicLayout: UICollectionViewLayout {
    var contentBound = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
        
        // clear or reset cached info
        cachedAttributes.removeAll()
        contentBound = CGRect(origin: .zero, size: cv.bounds.size)
        
        // - for every item in collection,
        // - prepare attribute and store in cachedAttribute Array
        // - union contentBounds with Attribute.frame
        
        createAttributes(for: cv)
    }
    
    override var collectionViewContentSize: CGSize {
        contentBound.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cv = collectionView else { return false }
        
        return !newBounds.size.equalTo(cv.bounds.size)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedAttributes[indexPath.item]
    }
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        cachedAttributes.filter { attribute in
//            return rect.intersects(attribute.frame)
//        }
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        let firstMatchIndex = cachedAttributes.binarySearch { rect.intersects($0.frame) }
        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }
        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }
        return attributesArray
    }
    
    private func createAttributes(for cv: UICollectionView) {
        let maxImagesPerRow = 5
        let rowHeight: CGFloat = 250
        let contentWidth = cv.bounds.width
        let itemsCount = cv.numberOfItems(inSection: 0)
        
        var itemsCountOnCurrentRow = maxImagesPerRow
        var rowIndex: CGFloat = 0
        var firstItemIndexOnCurrentRow = 0
        
        while firstItemIndexOnCurrentRow < itemsCount {
            let remainingItems = itemsCount - firstItemIndexOnCurrentRow
            
            itemsCountOnCurrentRow = determineItemsCountOnCurrentRow2(remainingItems, itemsCountOnCurrentRow, maxImagesPerRow)
           // print("row: \(rowIndex) - items: \(itemsCountOnCurrentRow)")
            for itemIndexOnCurrentRow in 0 ..< itemsCountOnCurrentRow {
                let indexPath = IndexPath(item: firstItemIndexOnCurrentRow + itemIndexOnCurrentRow, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let y = determinY2(itemIndexOnCurrentRow, rowHeight, rowIndex)
                let x = determinX2(itemIndexOnCurrentRow, itemsCountOnCurrentRow, contentWidth)
                let width = determineWidth2(itemsCountOnCurrentRow, itemIndexOnCurrentRow, contentWidth)
                let height = determineHeight2(itemsCountOnCurrentRow, itemIndexOnCurrentRow, maxImagesPerRow, rowHeight)
                attributes.frame = CGRect(x: x, y: y, width: width, height: height)
                
                print("rowIndex:\(rowIndex) x:\(x) y:\(y) width:\(width) height:\(height)")
                
                cachedAttributes.append(attributes)
            }
            
            rowIndex += 1
            firstItemIndexOnCurrentRow += itemsCountOnCurrentRow
        }
        
        if let lastAttribute = cachedAttributes.last {
            contentBound.size.height = max(cv.bounds.height, lastAttribute.frame.maxY)
            print(contentBound)
        }
    }
    
    private func determineItemsCountOnCurrentRow2(_ remainingItems: Int, _ itemsCountOnPreviousRow: Int, _ maxImagesPerRow: Int) -> Int {
        
        let itemsCountOnCurrentRow: Int
        
        if remainingItems < maxImagesPerRow {
            itemsCountOnCurrentRow = remainingItems
        } else {
            itemsCountOnCurrentRow = 5 + remainingItems % 5
        }
        
        return itemsCountOnCurrentRow
    }
    
    private func determineItemsCountOnCurrentRow(_ remainingItems: Int, _ itemsCountOnPreviousRow: Int, _ maxImagesPerRow: Int) -> Int {
        
        let itemsCountOnCurrentRow: Int
        
        if remainingItems < maxImagesPerRow {
            itemsCountOnCurrentRow = remainingItems
        } else {
            itemsCountOnCurrentRow = 1 + itemsCountOnPreviousRow % maxImagesPerRow
        }
        
        return itemsCountOnCurrentRow
    }
    
    private func determinY(_ itemIndexOnCurrentRow: Int, _ rowHeight: CGFloat, _ rowIndex: CGFloat) -> CGFloat {
        let y: CGFloat
        if itemIndexOnCurrentRow < 2 {
            y = rowHeight * rowIndex
        } else {
            y = rowHeight * rowIndex + rowHeight / 2
        }
        return y
    }
    
    private func determinY2(_ itemIndexOnCurrentRow: Int, _ rowHeight: CGFloat, _ rowIndex: CGFloat) -> CGFloat {
        let y: CGFloat
        
        //if Int(rowIndex) %  2 == 0 {
            if rowIndex == 0 && itemIndexOnCurrentRow < 2  {
                y = 0
            } else if rowIndex == 0 && itemIndexOnCurrentRow >= 3 {
                y = rowHeight / 2
            } else {
                if itemIndexOnCurrentRow < 3 {
                    y = rowHeight * rowIndex
                } else {
                    y = (rowHeight * rowIndex) + (rowHeight / 2)
                }
                
            }
        //} else {
//            if itemIndexOnCurrentRow < 3 {
//                y = rowIndex / 2
//            } else {
//                y = 0
//            }
        //}
        return y
    }
    
    private func determinX2(_ itemIndexOnCurrentRow: Int, _ itemsCountOnCurrentRow: Int, _ contentWidth: CGFloat) -> CGFloat {
        let x: CGFloat
        if itemIndexOnCurrentRow == 0 {
            x = 0
        } else if itemIndexOnCurrentRow == 2 || itemIndexOnCurrentRow == 3 || itemIndexOnCurrentRow == 1 {
            x = contentWidth / 3
        } else {
            x = contentWidth * 2 / 3
        }
        
        return x
    }
    
    private func determinX(_ itemIndexOnCurrentRow: Int, _ itemsCountOnCurrentRow: Int, _ contentWidth: CGFloat) -> CGFloat {
        let x: CGFloat
        if itemIndexOnCurrentRow == 0 {
            x = 0
        } else if itemsCountOnCurrentRow == 2 {
            x = contentWidth / 2
        } else {
            x = contentWidth * 2 / 3
        }
        return x
    }
    
    private func determineWidth(_ itemsCountOnCurrentRow: Int, _ itemIndexOnCurrentRow: Int, _ contentWidth: CGFloat) -> CGFloat {
        let width: CGFloat
        if itemsCountOnCurrentRow == 1 {
            width = contentWidth
        } else if itemsCountOnCurrentRow == 2 {
            width = contentWidth / 2
        } else if itemIndexOnCurrentRow == 0 {
            width = contentWidth * 2 / 3
        } else {
            width = contentWidth / 3
        }
        return width
    }
    
    private func determineWidth2(_ itemsCountOnCurrentRow: Int, _ itemIndexOnCurrentRow: Int, _ contentWidth: CGFloat) -> CGFloat {
        let width: CGFloat
        width = contentWidth * 2 / 3
        return width
    }
    
    private func determineHeight2(_ itemsCountOnCurrentRow: Int, _ itemIndexOnCurrentRow: Int, _ maxImagesPerRow: Int, _ rowHeight: CGFloat) -> CGFloat {
        let height: CGFloat
        if itemIndexOnCurrentRow < 4 {
            height = rowHeight / 2
        } else {
            height = rowHeight
        }
        return height
    }
    
    private func determineHeight(_ itemsCountOnCurrentRow: Int, _ itemIndexOnCurrentRow: Int, _ maxImagesPerRow: Int, _ rowHeight: CGFloat) -> CGFloat {
        let height: CGFloat
        if itemsCountOnCurrentRow == maxImagesPerRow, itemIndexOnCurrentRow > 0 {
            height = rowHeight / 2
        } else {
            height = rowHeight
        }
        return height
    }
}

extension Collection {
    
    func binarySearch(predicate: (Iterator.Element) -> Bool) -> Index {
        var low = startIndex
        var high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high)/2)
            if predicate(self[mid]) {
                low = index(after: mid)
            } else {
                high = mid
            }
        }
        return low
    }
}
