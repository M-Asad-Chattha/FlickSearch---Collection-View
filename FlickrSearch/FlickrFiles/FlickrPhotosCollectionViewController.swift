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

class FlickrPhotosCollectionViewController: UICollectionViewController {
  
  // MARK: - Properties
  
  // Cell's Identifier to reuse the cell
  private let reuseIdentifier = "FlickrCell"
  // Inset is like Margin, In this case its section's outside spcaing
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  // Array of all searches, It's every Item contains 'searchTerm: String' & 'searchResults: [FlickrPhoto]'
  // 'FlickrPhoto' is a class which perform url request for ImageURL and retrun a 'UIImage' which will
  // be used to set image to 'UIImageView'.
  private var searches: [FlickrSearchResults] = []
  // Perform Flicker Search with given Search Term
  private var flickr = Flickr()
  // Number of Items you want in every row. It'll be used to divide device's width by this.
  // i.e. deviceWidth = 300, width per item will be 300/3 = 100
  private let itemsPerRow: CGFloat = 3
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // TODO: Remove this line of code, if you're using custom cell Class
    // Register cell classes
    // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
}
// MARK: - Convenience Methods

private extension FlickrPhotosCollectionViewController {
  // A convenience method that returns a specific photo related to
  // an index path in your collection view.
  func photo(for indexPath: IndexPath) -> FlickrPhoto {
    return searches[indexPath.section].searchResults[indexPath.row]
  }
}


// MARK: Text Field Delegate - UITextFieldDelegate
// A set of optional methods to manage the editing and validation of text in a Text Field object.

extension FlickrPhotosCollectionViewController: UITextFieldDelegate {
  
  //Asks the delegate whether to process the pressing of the Return button for the text field.
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text, !text.isEmpty
    else { return true } //Return if TextField is empty
    
    // A view ✹ that shows that a task is in progress.
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    textField.addSubview(activityIndicator)
    activityIndicator.frame = textField.bounds
    activityIndicator.startAnimating()
    
    flickr.searchFlickr(for: text) { searchResults in
      DispatchQueue.main.async {
        activityIndicator.removeFromSuperview()
        
        switch searchResults {
        case .failure(let error) :
          // 2
          print("Error Searching: \(error)")
        case .success(let results):
          // 3
          print("Found \(results.searchResults.count) for Search-Term '\(results.searchTerm)'")
          self.searches.insert(results, at: 0)
          // 4
          self.collectionView?.reloadData()
        }
      }
    }
    
    textField.text = nil
    textField.resignFirstResponder()
    
    return true
  }
  
  // Use for Validating content
  // Asks the delegate whether to stop editing in the specified text field.
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    print("Invalid Password...")
    return true
    
  }
  
  
  /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
   guard let text = textField.text, !text.isEmpty
   else { return true } //Return if TextField is empty - Do Nothing
   
   // A view ✹ that shows that a task is in progress.
   let activityIndicator = UIActivityIndicatorView(style: .medium)
   // Emdeb ActivityIndicator in TextField
   textField.addSubview(activityIndicator)
   activityIndicator.frame = textField.bounds
   activityIndicator.startAnimating()
   
   // Perform any task here
   // ...
   // After completing that task, remove ActivityIndicator from TextField
   //    activityIndicator.removeFromSuperview()
   
   // If above task in Async then this will execute along side.
   // Clear TextField text
   textField.text = nil
   // Hide KeyBoard
   textField.resignFirstResponder()
   
   return true
   }*/
  
}


// MARK: Collection View DataSource - UICollectionViewDataSource
// The methods adopted by the object you use to manage data and provide cells for a collection view.

extension FlickrPhotosCollectionViewController {
  
  // Asks your data source object for the 'number of sections' in the collection view.
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return searches.count
  }
  
  // Asks your data source object for the 'number of items' in the specified section.
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searches[section].searchResults.count
  }
  
  // Asks your data source object for the 'cell' that corresponds to the specified item in the collection view.
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // DownCasting cell to Defined Cell's Custom Cocoa Touch class
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCell", for: indexPath) as! FlickrPhotoCell
    
    // Configure the cell - Get UIImage to load in UIImageView
    let flickrPhoto = photo(for: indexPath)
    cell.imageView.image = flickrPhoto.thumbnail
    return cell
  }
  
}

// MARK: - Flow Layout Delegate - UICollectionViewDelegateFlowLayout
// The methods that let you coordinate with a flow layout object to implement a grid-based layout.

extension FlickrPhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  // Asks the delegate for the size of the specified item’s cell.
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
