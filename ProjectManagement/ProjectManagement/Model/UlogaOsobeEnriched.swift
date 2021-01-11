//
//  UlogaOsobe.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 12/25/20.
//

import Foundation

class UlogaOsobeEnriched
{
    var SifProjekta: Int = 0
    var IdOsobe: Int = 0
    var IdUloge: Int = 0
    var DatDodjele: Int = 0
    var NazProjekta: String = ""
    var ImeOsobe: String = ""
    var PrezimeOsobe: String = ""
    var NazUloge: String = ""

    init(SifProjekta:Int, IdOsobe:Int, IdUloge:Int, DatDodjele:Int, NazProjekta:String, ImeOsobe:String, PrezimeOsobe:String, NazUloge:String)
    {
        self.SifProjekta = SifProjekta
        self.IdOsobe = IdOsobe
        self.IdUloge = IdUloge
        self.DatDodjele = DatDodjele
        self.NazProjekta = NazProjekta
        self.ImeOsobe = ImeOsobe
        self.PrezimeOsobe = PrezimeOsobe
        self.NazUloge = NazUloge
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
    
    func getDatDodjele() -> Int{
        return self.DatDodjele
    }
    func setDatDodjele(DatDodjele: Int){
        self.DatDodjele = DatDodjele
    }
    
    func getNazProjekta() -> String{
        return self.NazProjekta
    }
    func setNazProjekta(NazProjekta: String){
        self.NazProjekta = NazProjekta
    }
    
    func getImeOsobe() -> String{
        return self.ImeOsobe
    }
    func setImeOsobe(ImeOsobe: String){
        self.ImeOsobe = ImeOsobe
    }
    
    func getPrezimeOsobe() -> String{
        return self.PrezimeOsobe
    }
    func setPrezimeOsobe(PrezimeOsobe: String){
        self.PrezimeOsobe = PrezimeOsobe
    }
    
    func getNazUloge() -> String{
        return self.NazUloge
    }
    func setNazUloge(NazUloge: String){
        self.NazUloge = NazUloge
    }
}
