//
//  ongakupart2ViewController.swift
//  ongaku
//
//  Created by clark on R 4/10/26.
//
import UIKit
import MediaPlayer
class ongakupart2ViewController:UIViewController, MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {
    
       var audioPlayer: AVAudioPlayer!
       
       override func viewDidLoad() {
           super.viewDidLoad()
       }

       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
       }
       
       // Touch Up Inside で UIButton に関連付ける
       @IBAction func pick(sender: UIButton) {
           let picker = MPMediaPickerController(coder: MPMediaType.music)
           picker.delegate = self
           // 複数曲選択
           picker.allowsPickingMultipleItems = false
           picker.showsItemsWithProtectedAssets = false
           picker.showsCloudItems = false
           present(picker ?? <#default value#>, animated: true, completion: nil)
       }
//
       // 曲を選んだ時
    private func mediaPicker(_ mediaPicker: MPMediaPickerController,
                        didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
           defer {
               dismiss(animated: true, completion: nil)
           }
           
           let items = mediaItemCollection.items
           if items.isEmpty {
               return
           }
           
           let item = items.first
           if let url = item?.assetURL {
               audioPlayer = try! AVAudioPlayer(contentsOf: url)
               audioPlayer.delegate = self
               audioPlayer.isMeteringEnabled = true
               audioPlayer.play()
               
           } else {
               
           }
       }
       
       // キャンセルを押した時
    private func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
           dismiss(animated: true, completion: nil)
       }
       
       // 曲が終了した時に呼ばれる
       func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
           
       }
   }
