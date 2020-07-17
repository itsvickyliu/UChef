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

class ViewController: UIViewController, VNDocumentCameraViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    var ingredients: Set = ["rice","curry","apple","pineapple","honey","lettuce"]
    var scannedIngredients = Set<String>()
    var recipes = [
        "Rice and curry": ["rice","curry"],
        "Fruit salad": ["apple", "pineapple", "honey"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        setupVision()
    }

    @IBAction func touchButton(_ sender: Any) {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
    }
    
    private func setupVision() {
        textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var detectedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                print("text \(topCandidate.string) has confidence \(topCandidate.confidence)")
    
                if self.ingredients.contains(topCandidate.string.lowercased()){
                    self.scannedIngredients.insert(topCandidate.string.lowercased())
                    detectedText += topCandidate.string.lowercased()
                }
                print (self.scannedIngredients)
                detectedText += "\n"
                
            }
            
            DispatchQueue.main.async {
                self.textView.text = detectedText
                self.textView.flashScrollIndicators()
            }
        }

        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.recognitionLanguages = ["en_US"]
    }
    
    private func processImage(_ image: UIImage) {
        imageView.image = image
        recognizeTextInImage(image)
    }
    
    private func recognizeTextInImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        textView.text = ""
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
    
    @IBAction func generateRecipe(_ sender: Any) {
        for (recipe,ingredients) in recipes {
            var returnRecipe = true
            for ingredient in ingredients {
                print ("ingredient: \(ingredient)")
                if !scannedIngredients.contains(ingredient){
                    returnRecipe = false
                }
            }
            if returnRecipe {
                self.textView.text += recipe
                self.textView.text += "\n"
            }
        }
    }
}

