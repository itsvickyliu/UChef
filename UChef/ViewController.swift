//
//  ViewController.swift
//  UChef
//
//  Created by Vicky Liu on 7/17/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import Vision
import VisionKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    
    
    let db = Firestore.firestore()
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    var ingredArray: Array<String> = []
    var inventArray: Array<String> = []
    var recipeArray: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupVision()
        setupUI()
        retrieveIngredientDict()
    }
    
    func setupUI() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 0.9775516391, blue: 0.9434913993, alpha: 1)
        generateButton.applyGradient(colors: [#colorLiteral(red: 1, green: 0.862745098, blue: 0.6352941176, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.5607843137, blue: 0.3215686275, alpha: 1)])
    }

    @IBAction func touchButton(_ sender: Any) {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
        //self.performSegue(withIdentifier: "scanToNewIngredients", sender: self)

    }
    
    
    private func setupVision() {
        textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            for observation in observations {
                autoreleasepool {
                    guard let topCandidate = observation.topCandidates(1).first else { return }
                    print("text \(topCandidate.string) has confidence \(topCandidate.confidence)")
                    if self.ingredArray.contains(topCandidate.string.lowercased()){
                        let userIngredRef = self.db.collection("inventory").document("user_name")
                        userIngredRef.updateData([
                            "ingredient": FieldValue.arrayUnion([topCandidate.string.lowercased()])
                        ])
                    }
                }
            }
        }

        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.recognitionLanguages = ["en_US"]
        
    }
    
    private func processImage(_ image: UIImage) {
        recognizeTextInImage(image)
    }
    
    private func recognizeTextInImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        textRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.textRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        let originalImage = scan.imageOfPage(at: 0)
        let newImage = compressedImage(originalImage)
        controller.dismiss(animated: true)
        
        processImage(newImage)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }

    func compressedImage(_ originalImage: UIImage) -> UIImage {
        guard let imageData = originalImage.jpegData(compressionQuality: 1),
            let reloadedImage = UIImage(data: imageData) else {
                return originalImage
        }
        return reloadedImage
    }
    
    func retrieveIngredientDict(){
        let ingredRef = db.collection("ingredients").document("ingredients")
        
        ingredRef.getDocument { (document, error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                if let document = document, document.exists {
                    self.ingredArray = (document.get("Ingredient") as? Array)!
                }
            }
        }
    }
    
    func displayRecipe(){
        db.collection("recipes").getDocuments(){ (querySnapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    autoreleasepool {
                        var returnRecipe = true
                        var recipeIngredArray: Array<String> = []
                        recipeIngredArray = (document.get("ingredients") as? Array)!
                        for ingred in recipeIngredArray {
                            if !self.inventArray.contains (ingred) {
                                returnRecipe = false
                            }
                        }
                        if returnRecipe {
                            let dishName = (document.documentID)
                            self.recipeArray.append(dishName)
                        }
                    }
                }
            }
        }
    }
    
    func updateInventory() {
        let inventRef = db.collection("inventory").document("user_name")
        
        inventRef.getDocument { (document, error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                if let document = document, document.exists {
                    self.inventArray = (document.get("ingredient") as? Array)!
                    self.displayRecipe()
                }
            }
        }
    }

}

extension UIButton
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

