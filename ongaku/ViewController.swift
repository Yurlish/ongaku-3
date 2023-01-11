import UIKit
import MediaPlayer
import AVFoundation
import MobileCoreServices
//class MPMediaPickerController : UIViewController{
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,MPMediaPickerControllerDelegate,AVAudioPlayerDelegate {
    var player : MPMusicPlayerController!
    var ongakuArray = [Any]()
        
        var playingSongFileName: Int = 0
        
        //↓次に再生するか一時停止するかを判断↓
        var playorpause = 0
        
        //↓曲が再生される前かされた後かを判定↓
        var flag = 0
        
            //↓曲の現在位置を一次的に保持↓
        var currenttime = 0.0

    func application (_ application: UIApplication, didFinishLaunchingWithOptionslaunchOption:[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          let session = AVAudioSession.sharedInstance()
          do{
              try session.setCategory(.playback, mode: .default)
          }catch{
              fatalError("session有効化失敗")
          }
          return true
      }
      //↓StoryBoardで扱うTableViewを宣言↓
      @IBOutlet var table: UITableView!
      //↓次ボタン↓
      @IBOutlet var nextbutton: UIButton!
      //↓前ボタン↓
      @IBOutlet var backbutton: UIButton!
      //↓ストップボタン↓
      @IBOutlet var stopbutton: UIButton!
      //↓ランダム↓
      @IBOutlet var randombutton: UIButton!
      //↓再生ボタン宣言↓
      @IBOutlet var saiseibutton: UIButton!

//      ↓ 再開
        @IBOutlet var saikaibutton: UIButton!
        //↓曲名を入れるための配列↓
        var songNameArray = [String]()
        //↓曲のファイル名を入れるための配列↓
        var fileNameArray = [String]()
        //↓音楽家の画像を入れるための配列↓
        var imageNameArray = [String]()
        //↓音楽を再生するための変数↓
        var audioPlayer : AVAudioPlayer!
        
        //↓曲のファイル名を入れるための配列↓
        var fileURLArray = [URL]()
     
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //↓テーブルビューのデータソースメソッドはViewControllerクラスに書くよ、という設定↓
            table.dataSource = self
            //↓テーブルビューのデリケートメソッドはViewControllerメソッドに書くよという設定↓
            table.delegate = self
            player = MPMusicPlayerController.applicationMusicPlayer
    }
    //↓１つ前の曲（リスト上の）を流すボタン↓
       @IBAction func back(){
           
           print("１つ前の曲が流されました")
           
           //↓音楽ファイルの設定↓
           playingSongFileName -= 1
           let audioPath = fileURLArray[playingSongFileName]
           
           //↓再生の準備↓
           audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
           audioPlayer.delegate = self
           //↓音楽の再生↓
           audioPlayer.play()
       }
       //↓一時停止させるボタン。再生中のみ有効↓
       @IBAction func stop(){
         
           print("一時停止")
         
           audioPlayer.stop()
       }
   //    ↓再開
       @IBAction func saikai(){
          
           print("再開されてしまいました")
          
           audioPlayer.play()
       }
       //↓一時停止した曲、再生し終わった曲に対応。再生ボタン↓
       @IBAction func saisei(){
           print("はじめから再生されました")
           //↓音楽ファイルの設定↓
           let audioPath = fileURLArray[playingSongFileName]
           //↓再生の準備↓
           audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
           audioPlayer.delegate = self
           audioPlayer.play()
       }
       //↓randomに曲が選ばれて曲が流れるbutton↓
       @IBAction func random(){
           print("無作為に選ばれました！")
           //↓random抽出↓
           playingSongFileName = Int.random(in: 0...fileNameArray.count)
           //↓音楽ファイルの設定↓
           let audioPath = fileURLArray[playingSongFileName]
           //fileNameArrayの曲をrandomElement()でランダムに抽出。
           // →audioPlayer.play()でそれを再生。
           //↓再生の準備↓
           audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
           audioPlayer.delegate = self
           //↓音楽のplay↓
           audioPlayer.play()
       }
      

    @IBAction func pick(_ sender: UIButton){
          print("pick呼ばれたよ")
        
        let picker = MPMediaPickerController()
        picker.delegate = self
//          let picker = MPMediaPickerController(mediaTypes: .mp3)
//          picker.popoverPresentationController?.sourceView = sender
          
          picker.allowsPickingMultipleItems = true
        picker.showsItemsWithProtectedAssets = false
   
          present(picker, animated: true, completion: nil)
      }
      
      func mediaPicker(_ mediaPicker: MPMediaPickerController,
                       didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
          print("media選択")
   
          //playerはMediaPlayerのもの
  //        player.setQueue(with: mediaItemCollection)
  //        player.play()
          
          for music in mediaItemCollection.items {
              print("music")
              songNameArray.append(music.title!)
              fileNameArray.append(music.assetURL!.absoluteString)
              fileURLArray.append(music.assetURL!)
  //            String(music.assetURL!)
              
          }
          
          table.reloadData()
          
          mediaPicker.dismiss(animated: true)
          
          
          dismiss(animated: true, completion: nil)
      }
      func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
          print("media選択キャンセル")
          mediaPicker.dismiss(animated: true, completion: nil)
      }
      
      
      override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }
      //↓セルの数を設定↓
      func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int)-> Int {
          //↓セルの数をsongNameArrayの数にする↓
          return songNameArray.count
      }
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
          //↓セルにsongNameArrayの曲名を表示する↓
          cell?.textLabel?.text = songNameArray[indexPath.row]
          return cell!
      }
      //↓セルが押された時に呼ばれるメソッド↓
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
          print("\(songNameArray[indexPath.row])が選ばれました！")
          print("\(fileURLArray[indexPath.row])")
   
          playingSongFileName = indexPath.row
   
          //↓音楽ファイルの設定↓
  //        let audioPath = fileURLArray[playingSongFileName]
          let audioPath = fileURLArray[playingSongFileName]
          
          //↓再生の準備↓
          audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
          audioPlayer.delegate = self
          //↓音楽の再生↓
          audioPlayer.play()
      }
  //↓一曲終わってから↓
       func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
          print("Did finish Playing")
          playingSongFileName += 1
          let audioPath = fileURLArray[playingSongFileName]
   
          //↓再生の準備↓
          audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
           audioPlayer.delegate = self
          //↓音楽の再生↓
          audioPlayer.play()
      }
      
      
      @IBAction func tapFileReadButton(_ sender: Any) {
              // フォルダのみ選択できるドキュメントピッカーを作成
              if #available(iOS 14.0, *) {
                  let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
                  documentPicker.delegate = self
                  present(documentPicker, animated: true, completion: nil)
              } else {
                  let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeFolder)], in: .open)
                  documentPicker.delegate = self
                  present(documentPicker, animated: true, completion: nil)
              }
          }
      }
   
      /// UIDocumentPickerDelegate
      extension ViewController: UIDocumentPickerDelegate {
          /// ファイル選択後に呼ばれる
          func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
              print("UIDocumentPickerDelegate")
              // URLを取得
              guard let url = urls.first else { return }
              // USBメモリなど外部記憶装置内のファイルにアクセスするにはセキュリティで保護されたリソースへのアクセス許可が必要
              guard url.startAccessingSecurityScopedResource() else {
                  // ここで選択したURLでファイルを処理する
                  return
              }
              // ファイルの処理が終わったら、セキュリティで保護されたリソースを解放
              do { url.stopAccessingSecurityScopedResource() }
          }
      
  }
