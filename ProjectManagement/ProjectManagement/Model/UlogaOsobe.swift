//
//  UlogaOsobe.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 12/25/20.
//

import Foundation

class UlogaOsobe
{
    var SifProjekta: Int = 0
    var IdOsobe: Int = 0
    var IdUloge: Int = 0
    var DatDodjele: String = ""

    init(SifProjekta:Int, IdOsobe:Int, IdUloge:Int, DatDodjele:String)
    {
        self.SifProjekta = SifProjekta
        self.IdOsobe = IdOsobe
        self.IdUloge = IdUloge
        self.DatDodjele = DatDodjele
    }
    
    func getSifProjekta() -> Int{
        return self.SifProjekta
    }
    func setSifProjekta(SifProjekta: Int){
        self.SifProjekta = SifProjekta
    }
    
    func getIdOsobe() -> Int{
        return self.IdOsobe
    }
    func setIdOsobe(IdOsobe: Int){
        self.IdOsobe = IdOsobe
    }
    
    func getIdUloge() -> Int{
        return self.IdUloge
    }
    func setIdUloge(IdUloge: Int){
        self.IdUloge = IdUloge
    }
    
    func getDatDodjele() -> String{
        return self.DatDodjele
    }
    func setDatDodjele(DatDodjele: String){
        self.DatDodjele = DatDodjele
    }
}
