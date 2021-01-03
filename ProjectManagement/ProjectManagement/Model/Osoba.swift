//
//  Osoba.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 12/25/20.
//

import Foundation

class Osoba
{
    var idOsobe: Int = 0
    var prezimeOsobe: String = ""
    var imeOsobe: String = ""
    var OIB: String = ""
    
    init(idOsobe:Int, imeOsobe:String, prezimeOsobe:String, OIB:String)
    {
        self.idOsobe = idOsobe
        self.prezimeOsobe = prezimeOsobe
        self.imeOsobe = imeOsobe
        self.OIB = OIB
    }
    
    func getIdOsobe() -> Int{
        return self.idOsobe
    }
    func setIdOsobe(idOsobe: Int){
        self.idOsobe = idOsobe
    }
    
    func getPrezimeOsobe() -> String{
        return self.prezimeOsobe
    }
    func setPrezimeOsobe(prezimeOsobe: String){
        self.prezimeOsobe = prezimeOsobe
    }
    
    func getImeOsobe() -> String{
        return self.imeOsobe
    }
    func setImeOsobe(imeOsobe: String){
        self.imeOsobe = imeOsobe
    }
    
    func getOIBOsobe() -> String{
        return self.OIB
    }
    func setOIBOsobe(OIB: String){
        self.OIB = OIB
    }
}
