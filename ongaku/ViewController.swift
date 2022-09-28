import UIKit
import AVFoundation
class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    var ongakuArray = [Any]()
    var playingSongFileName: Int = 0
    func application (_ application: UIApplication, didFinishLaunchingWithOptionslaunchOption:[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(.playback, mode: .default)
        }catch{
            fatalError("session有効化失敗")
        }
        return true
    }
    //StoryBoardで扱うTableViewを宣言
    @IBOutlet var table: UITableView!
    //一つ次ボタン
    @IBOutlet var nextbutton: UIButton!
    //一つ前ボタン
    @IBOutlet var backbutton: UIButton!
    //ストップボタン
    @IBOutlet var stopbutton: UIButton!
    //ランダム
    @IBOutlet var randombutton: UIButton!
    //再生ボタン宣言
    @IBOutlet var saiseibutton: UIButton!
    //曲名を入れるための配列
    var songNameArray = [String]()
    //曲のファイル名を入れるための配列
    var fileNameArray = [String]()
    //音楽家の画像を入れるための配列
    var imageNameArray = [String]()
    //音楽を再生するための変数
    var audioPlayer : AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //テーブルビューのデータソースメソッドはViewControllerクラスに書くよ、という設定
        table.dataSource = self
        //テーブルビューのデリケートメソッドはViewControllerメソッドに書くよという設定
        table.delegate = self
        //songNameArrayに曲名を入れていく
        songNameArray = ["我は来たれり","Fear Dont Know My Name","Titans","Breaking Point","De-Composed","南海奇皇","OnlyOne","KABUTO EXTENDER","モグラー","決心 (#Kesshin)","なんだかんだと聞かれたら...","NEO RANGA","神 to 汝","Otoya's Etude","ヒロイックノスタルジー","クライマックス10","想い合う兄弟","kanzaki shirou","富士サファリパーク","Flight of Dreams","Shaky Shaky (JOE Shakin' Remix)","来たる春","春うらら","骨伝導","人でなくなったら","あなたに逢えて","アマハレーハ","やがて星が降る","01 僕のこと わかってます","グリーザ"]
        //fillNameArrayにファイル名を入れていく
        fileNameArray = ["我は来たれり","Fear Dont Know My Name","Titans","Breaking Point","De-Composed","南海奇皇","OnlyOne","KABUTO EXTENDER","モグラー","決心 (#Kesshin)","なんだかんだと聞かれたら...","NEO RANGA","神 to 汝","Otoya's Etude","ヒロイックノスタルジー","クライマックス10","想い合う兄弟","kanzaki shirou","富士サファリパーク","Flight of Dreams","Shaky Shaky (JOE Shakin' Remix)","来たる春","春うらら","骨伝導","人でなくなったら","あなたに逢えて","アマハレーハ","やがて星が降る","01 僕のこと わかってます","グリーザ"]
        //imageNameArrayに画像を入れていく
        //imageNameArray = ["Pachelbel.jpg","Beethoven.jpg","Bach.jpg"]
    }
    //１つ次の曲（リスト上の）を流すボタン
    @IBAction func next(){
        print("１つ次の曲が流されました")
        //音楽ファイルの設定
        playingSongFileName += 1
        let audioPath = URL(fileURLWithPath: Bundle.main.path(forResource: fileNameArray[playingSongFileName], ofType:"mp3")!)
        //再生の準備
        audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
        //音楽の再生
        audioPlayer.play()
    }
    //１つ前の曲（リスト上の）を流すボタン
    @IBAction func back(){
        print("１つ前の曲が流されました")
        //音楽ファイルの設定
        playingSongFileName -= 1
        let audioPath = URL(fileURLWithPath: Bundle.main.path(forResource: fileNameArray[playingSongFileName], ofType:"mp3")!)
        //再生の準備
        audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
        //音楽の再生
        audioPlayer.play()
    }
    //一時停止させるボタン。再生中のみ有効
    @IBAction func stop(){
        print("一時停止されました")
        audioPlayer.stop()
    }
    //一時停止した曲、再生し終わった曲に対応。再生ボタン
    @IBAction func saisei(){
        print("再生されました")
        //音楽ファイルの設定
        let audioPath = URL(fileURLWithPath: Bundle.main.path(forResource: fileNameArray[playingSongFileName], ofType:"mp3")!)
        //再生の準備
        audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
        audioPlayer.play()
    }
    //randomに曲が選ばれて曲が流れるbutton
    @IBAction func random(){
        print("ランダムに選ばれました！")
        //random抽出
        playingSongFileName = Int.random(in: 0...fileNameArray.count)
        //音楽ファイルの設定
        let audioPath = URL(fileURLWithPath: Bundle.main.path(forResource: fileNameArray[playingSongFileName], ofType:"mp3")!)
        //fileNameArrayの曲をrandomElement()でランダムに抽出。
        // →audioPlayer.play()でそれを再生。
        //再生の準備
        audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
        //音楽のplay
        audioPlayer.play()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //セルの数を設定
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int)-> Int {
        //セルの数をsongNameArrayの数にする
        return songNameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        //セルにsongNameArrayの曲名を表示する
        cell?.textLabel?.text = songNameArray[indexPath.row]
        return cell!
    }
    //セルが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("\(songNameArray[indexPath.row])が選ばれました！")
        playingSongFileName = indexPath.row
        //音楽ファイルの設定
        let audioPath = URL(fileURLWithPath: Bundle.main.path(forResource: fileNameArray[playingSongFileName], ofType:"mp3")!)
        //再生の準備
        audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
        //音楽の再生
        audioPlayer.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Did finish Playing")
        playingSongFileName += 1
        let audioPath = URL(fileURLWithPath: Bundle.main.path(forResource: fileNameArray[playingSongFileName], ofType:"mp3")!)
        //再生の準備
        audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
        //音楽の再生
        audioPlayer.play()
    }
}
