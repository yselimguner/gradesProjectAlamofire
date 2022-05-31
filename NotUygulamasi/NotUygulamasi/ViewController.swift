//
//  NotlarKarsi.swift
//  NotUygulamasi
//
//  Created by Yavuz Güner on 31.05.2022.
//  Copyright © 2022 info. All rights reserved.
//
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var notTableView: UITableView!
    
    var notlarListe = [Notlar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            
        notTableView.delegate = self
        notTableView.dataSource = self
        

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tumNotlariAl()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNotDetay" {
            let indeks = sender as? Int
            
            let gidilecekVC = segue.destination as! NotDetayViewController
            
            gidilecekVC.not = notlarListe[indeks!]
        }
    }
    
    func tumNotlariAl(){
        AF.request("http://kasimadalan.pe.hu/notlar/tum_notlar.php",method: .get).response{
            response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(NotlarKarsi.self, from: data)
                    
                    if let gelenNotListesi = cevap.notlar {
                        self.notlarListe = gelenNotListesi
                    } else {
                        self.notlarListe = [Notlar]()
                    }
                    DispatchQueue.main.async {
                        
                        var toplam = 0
                        for n in self.notlarListe {
                            if let n1 = Int(n.not1!), let n2 = Int(n.not2!) {
                                toplam = toplam + (n1+n2)/2
                            }
                        }
                        
                        if self.notlarListe.count != 0 {
                            self.navigationItem.prompt = "Ortalama: \(toplam/self.notlarListe.count)"
                        }else {
                            self.navigationItem.prompt = "Ortalama: YOK"
                        }
                        
                        self.notTableView.reloadData()
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    


}

extension ViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notlarListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let not = notlarListe[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notHucre", for: indexPath) as! NotHucreTableViewCell
        
        cell.labelDersAdi.text = not.ders_adi
        cell.labelNot1.text = String(not.not1!)
        cell.labelNot2.text = String(not.not2!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toNotDetay", sender: indexPath.row)
    }
}
