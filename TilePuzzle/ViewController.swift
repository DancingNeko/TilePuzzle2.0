//
//  ViewController.swift
//  TilePuzzle
//
//  Created by Zhenyang Feng on 9/17/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var finished = true
    var imagePicker = UIImagePickerController()
    var image1:UIImage = UIImage()
    var image2:UIImage = UIImage()
    var image3:UIImage = UIImage()
    var image4:UIImage = UIImage()
    var image5:UIImage = UIImage()
    var image6:UIImage = UIImage()
    var image7:UIImage = UIImage()
    var image8:UIImage = UIImage()
    var image9:UIImage = UIImage()
    var originalImage = UIImage()
    @IBOutlet weak var view1: UIImageView!
    @IBOutlet weak var view2: UIImageView!
    @IBOutlet weak var view3: UIImageView!
    @IBOutlet weak var view4: UIImageView!
    @IBOutlet weak var view5: UIImageView!
    @IBOutlet weak var view6: UIImageView!
    @IBOutlet weak var view7: UIImageView!
    @IBOutlet weak var view8: UIImageView!
    @IBOutlet weak var view9: UIImageView!
    @IBAction func button1(_ sender: Any) {
        buttonTriggered(number: 0)
    }
    @IBAction func button2(_ sender: Any) {
        buttonTriggered(number: 1)
    }
    @IBAction func button3(_ sender: Any) {
        buttonTriggered(number: 2)
    }
    @IBAction func button4(_ sender: Any) {
        buttonTriggered(number: 3)
    }
    @IBAction func button5(_ sender: Any) {
        buttonTriggered(number: 4)
    }
    @IBAction func button6(_ sender: Any) {
        buttonTriggered(number: 5)
    }
    @IBAction func button7(_ sender: Any) {
        buttonTriggered(number: 6)
    }
    @IBAction func button8(_ sender: Any) {
        buttonTriggered(number: 7)
    }
    @IBAction func button9(_ sender: Any) {
        buttonTriggered(number: 8)
    }
    var images = [UIImage()]
    var puzzle = [1,2,3,4,5,6,7,8,0]
    var views = [UIImageView()]
    
    func buttonTriggered(number:Int){
        if(finished){
            return
        }
        let zeroID = puzzle.firstIndex(of: 0)!
        if(zeroID + 1 == number){
            move(dir: 2)
        }
        else if(zeroID - 1 == number){
            move(dir: 4)
        }
        else if(zeroID + 3 == number){
            move(dir: 3)
        }
        else if(zeroID - 3 == number){
            move(dir: 1)
        }
        updatePuzzle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        loadImage(image: UIImage(named: "sample")!)
    }
    
    @IBAction func restart(_ sender: Any) {
        finished = false
        wholeImage.image = nil
        wholeImage.stopAnimating()
        wholeImage.center.x = 207
        loadImage(image: originalImage)
    }
    
    func loadImage(image: UIImage){
        originalImage = image
        loadImageBlocks()
        views = [view1,view2,view3,view4,view5,view6,view7,view8,view9]
        randomizePuzzle()
        updatePuzzle()
        self.finished = false
    }
    
    func updatePuzzle(){
        for i in 0..<9{
            if(puzzle[i] == 0){
                views[i].image = images[8]
            }
            else{
            views[i].image = images[puzzle[i]-1]
            }
        }
        if(checkComplete()){
            finish()
        }
    }
    
    @IBOutlet weak var wholeImage: UIImageView!
    
    func finish(){
        for view in views{
            view.image = nil
        }
        wholeImage.image = originalImage
        UIView.animate(withDuration: 1) {
            self.wholeImage.center.x -= 50
        }
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.wholeImage.center.x += 100
        }, completion: nil)
    }
    
    @IBAction func pickPhoto(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func checkComplete() -> Bool{
        for i in 0..<8{
            if(i+1 != puzzle[i]){
                return false
            }
        }
        return true
    }
    
    func move(dir: Int){
        let zeroPos = puzzle.firstIndex(of: 0)!
        if(dir == 1) //up
        {
            if(zeroPos/3 != 0){
                puzzle[zeroPos] = puzzle[zeroPos-3]
                puzzle[zeroPos-3] = 0
            }
        }
        if(dir == 3) //down
        {
            if(zeroPos/3 != 2){
                puzzle[zeroPos] = puzzle[zeroPos+3]
                puzzle[zeroPos+3] = 0
            }
        }
        if(dir == 4) //left
        {
            if(zeroPos%3 != 0){
                puzzle[zeroPos] = puzzle[zeroPos-1]
                puzzle[zeroPos-1] = 0
            }
        }
        if(dir == 2) //right
        {
            if(zeroPos%3 != 2){
                puzzle[zeroPos] = puzzle[zeroPos+1]
                puzzle[zeroPos+1] = 0
            }
        }
    }
    
    func randomizePuzzle(){
        for _ in 1...10000{
            move(dir:Int.random(in: 1...4))
        }
    }
    
    func loadImageBlocks(){
        var height = originalImage.size.height
        var width = originalImage.size.width
        if(height != width){
            if(height > width){
                originalImage = cropImage1(image: originalImage, rect: CGRect(x:0,y:(height-width)/2,width:width,height:width))
            }
            else{
                originalImage = cropImage1(image: originalImage, rect: CGRect(x:(width-height)/2,y:0,width:height,height:height))
            }
        }
        height = originalImage.size.height
        width = originalImage.size.width
        let bHeight = Int(height/3)
        let bWidth = Int(width/3)
        image1 = cropImage1(image: originalImage, rect: CGRect(x:0,y:0,width:bWidth,height:bHeight))
        image2 = cropImage1(image: originalImage, rect: CGRect(x:bWidth,y:0,width:bWidth,height:bHeight))
        image3 = cropImage1(image: originalImage, rect: CGRect(x:bWidth*2,y:0,width:bWidth,height:bHeight))
        image4 = cropImage1(image: originalImage, rect: CGRect(x:0,y:bHeight,width:bWidth,height:bHeight))
        image5 = cropImage1(image: originalImage, rect: CGRect(x:bWidth,y:bHeight,width:bWidth,height:bHeight))
        image6 = cropImage1(image: originalImage, rect: CGRect(x:bWidth*2,y:bHeight,width:bWidth,height:bHeight))
        image7 = cropImage1(image: originalImage, rect: CGRect(x:0,y:bHeight*2,width:bWidth,height:bHeight))
        image8 = cropImage1(image: originalImage, rect: CGRect(x:bWidth,y:bHeight*2,width:bWidth,height:bHeight))
        image9 = cropImage1(image: originalImage, rect: CGRect(x:bWidth*2,y:bHeight*2,width:bWidth,height:bHeight))
        image9 = adjustBrightness(image: image9, brightness: 0.7)
        images = [image1,image2,image3,image4,image5,image6,image7,image8,image9]
    }
    
    func adjustBrightness(image:UIImage,brightness:Float) -> UIImage{
        let filter = CIFilter(name: "CIColorControls");
        filter!.setValue(NSNumber(value: brightness), forKey: "inputBrightness")
        let rawimgData = CIImage(image: image)
        filter!.setValue(rawimgData, forKey: "inputImage")
        let outpuImage = filter!.value(forKey: "outputImage")
        return UIImage(ciImage: outpuImage as! CIImage)
    }
    
    func cropImage1(image: UIImage, rect: CGRect) -> UIImage {
        let cgImage = image.cgImage!
        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!)
    } 



}

extension ViewController{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            originalImage = image
            finished = false
            wholeImage.image = nil
            wholeImage.stopAnimating()
            wholeImage.center.x = 207
            loadImage(image: originalImage)
        }
        dismiss(animated: true)
    }
}
