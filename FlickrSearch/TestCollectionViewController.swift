/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

// Cell's Identifier to reuse the cell
private let reuseIdentifier = "FlickrCell"

class TestCollectionViewController: UICollectionViewController {
  
  // MARK: - Properties
  
  // Inset is like Margin, In this case its section's outside spcaing
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  // Number of Items you want in every row. It'll be used to divide device's width by this.
  // i.e. deviceWidth = 300, width per item will be 300/3 = 100
  private let itemsPerRow: CGFloat = 3
  // Instance of 'PhotoLibrary' - which provides image from Assets to display.
  private let library = PhotoLibrary()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // TODO: Remove this line of code, if you're using custom cell Class
    // Register cell classes
    // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  
  // MARK: Collection View DataSource - UICollectionViewDataSource
  // The methods adopted by the object you use to manage data and provide cells for a collection view.
  
  // Asks your data source object for the 'number of sections' in the collection view.
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // For demonstration, we're using hard-coded value
    return 1
  }
  
  // Asks your data source object for the 'number of items' in the specified section.
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return library.numberOfPhotos()
  }
  
  // Asks your data source object for the 'cell' that corresponds to the specified item in the collection view.
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // DownCasting cell to Defined Cell's Custom Cocoa Touch class
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCell
    
    // Configure the cell - Get UIImage to load in UIImageView
    cell.imageView.image = library.loadPhoto(of: indexPath)
    return cell
  }
  
}

// MARK: - Flow Layout Delegate - UICollectionViewDelegateFlowLayout
// The methods that let you coordinate with a flow layout object to implement a grid-based layout.

extension TestCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  // Asks the delegate for the size of the specified item’s cell.
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    // Calculates space between cells, +1 coz if there're 3 cells, 4 spaces will be.
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    // Width after deducting spaces
    let availableWidth = view.frame.width - paddingSpace
    // Width per item i.e. 300/3 = 100 per cell
    let widthPerItem = availableWidth / itemsPerRow
    // Every cell is suare - equal height & width
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  // Asks the delegate for the margins to apply to outside content in the specified section.
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    // Section Insets is defined above - Left & Right 20, top & bottom 50
    return sectionInsets
  }
  
  // Asks the delegate for the spacing between/inside successive rows or columns of a section.
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    // Space between rows - 20 in this case
    return sectionInsets.left
  }
  
}
