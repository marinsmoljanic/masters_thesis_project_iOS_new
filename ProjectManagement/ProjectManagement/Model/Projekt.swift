//
//  Projekt.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 12/25/20.
//

import Foundation

class Projekt
{
    var SifProjekta: Int = 0
    var NazProjekta: String = ""
    var OpisProjekta: String = ""
    var DatPocetka: Int = 0
    var DatZavrsetka: Int = 0

    init(SifProjekta:Int, NazProjekta:String, OpisProjekta:String, DatPocetka:Int, DatZavrsetka:Int)
    {
        self.SifProjekta = SifProjekta
        self.NazProjekta = NazProjekta
        self.OpisProjekta = OpisProjekta
        self.DatPocetka = DatPocetka
        self.DatZavrsetka = DatZavrsetka
    }
    
    func getSifProjekta() -> Int{
        return self.SifProjekta
    }
    func getNazivProjekta() -> String{
        return self.NazProjekta
    }
    func getOpisProjekta() -> String{
        return self.OpisProjekta
    }
    func getDatPoceta() -> Int{
        return self.DatPocetka
    }
    func getDatZavrsetka() -> Int{
        return self.DatZavrsetka
    }
    
}
