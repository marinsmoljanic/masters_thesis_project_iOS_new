//
//  DBHelper.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 12/25/20.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        
        print("IZ DbHELPERA")
        //createTableOsoba()
        //insertOsoba(osoba: Osoba(idOsobe: 0, imeOsobe: "Karlo", prezimeOsobe: "Krcelic", OIB: "749933829129"))
        //procitaneOsobe = readOsobe()
        //print("")
        //print("PROCITANA OSOBA")
        //let osoba:Osoba = readOsoba(idOsobe: 1)
        //print(osoba.getImeOsobe() + " -- " + osoba.getPrezimeOsobe())
        //deleteOsobaByID(id: 5)
        //deleteTableOsoba()
        
        // deleteTableProjekt()
        // createTableProjekt()
        // insertProjekt(projekt: Projekt(SifProjekta: 5, NazProjekta: "Pleternica", OpisProjekta: "Izrada murala", DatPocetka: 2, DatZavrsetka: 10))
        // procitaniProjekti = readProjekte()
        // deleteProjektByID(id: 4)
        
        // createTableUloga()
        // insertUloga(nazUloge: "Vjezbenik")
        // insertUloga(nazUloge: "Pripravnik")
        // procitaneUloge = readUloge()
        // deleteUlogaByID(id: 0)
        // deleteTableUloga()
        
        // deleteTableUlogaOsobe()
        // createTableUlogaOsobe()
        // insertUlogaOsobe(ulogaOsobe: UlogaOsobe(SifProjekta: 1, IdOsobe: 1, IdUloge: 1, DatDodjele: 222))
        // insertUlogaOsobe(ulogaOsobe: UlogaOsobe(SifProjekta: 2, IdOsobe: 1, IdUloge: 2, DatDodjele: 222))
        // deleteUlogaOsobeBySifProjekta(sifProjekta: 4)
        // ulogeOsoba = readAllUlogaOsoba()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    var procitaneOsobe:[Osoba] = []
    var procitaniProjekti:[Projekt] = []
    var procitaneUloge:[Uloga] = []
    var ulogeOsoba:[UlogaOsobeEnriched] = []

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            
            // PRAGMA foreign_keys = ON;
            sqlite3_exec(db, "PRAGMA foreign_keys = on", nil, nil, nil)
            return db
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Osoba: DBHandler
    //___________________________________________________________________________________________________________ //
    
    func createTableOsoba() {
        print("TABLICA OSOBA")
        print("________________________________________________")
        let createTableString = "CREATE TABLE IF NOT EXISTS osoba(IdOsobe INTEGER PRIMARY KEY AUTOINCREMENT,PrezimeOsobe TEXT,ImeOsobe TEXT,OIB TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Tablica OSOBA je stvorena (osim ako prethodno vec ne postoji).")
            } else {
                print("Osoba table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insertOsoba(osoba:Osoba)
    {
        let queryStatementString = "INSERT INTO osoba (PrezimeOsobe, ImeOsobe, OIB) VALUES (?, ?, ?);"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(queryStatement, 1, (osoba.getPrezimeOsobe() as NSString).utf8String, -1, nil)
            sqlite3_bind_text(queryStatement, 2, (osoba.getImeOsobe() as NSString).utf8String, -1, nil)
            sqlite3_bind_text(queryStatement, 3, (osoba.getOIBOsobe() as NSString).utf8String, -1, nil)

            // SQLITE 3 STEP ----> IF -> SAMO GA IZVEDI I NE VADI NISTA IZ BAZE
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("Successfully inserted row in table Osoba.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(queryStatement)

    }
    
    func readOsoba(idOsobe: Int) -> Osoba {
        var osoba:Osoba = Osoba(idOsobe: 0,imeOsobe: "", prezimeOsobe: "", OIB: "")
        // queryStatementString - populirati string
        let queryStatementString = "SELECT * FROM osoba WHERE IdOsobe=?;"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(idOsobe))

            // SQLITE 3 STEP ----> WHILE -> IZVEDI TE DOHVATI IZ BAZE
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let IdOsobe = sqlite3_column_int(queryStatement, 0)
                let PrezimeOsobe = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let ImeOsobe = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let OIB = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                
                osoba.setIdOsobe(idOsobe: Int(IdOsobe))
                osoba.setPrezimeOsobe(prezimeOsobe: PrezimeOsobe)
                osoba.setImeOsobe(imeOsobe: ImeOsobe)
                osoba.setOIBOsobe(OIB: OIB)
            }

        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return osoba
    }
    
    func readOsobe() -> [Osoba] {
        print("")
        print("LISTA OSOBA")
        let queryStatementString = "SELECT * FROM osoba;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Osoba] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            // SQLITE 3 STEP ----> WHILE -> IZVEDI TE DOHVATI IZ BAZE
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let IdOsobe = sqlite3_column_int(queryStatement, 0)
                let PrezimeOsobe = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let ImeOsobe = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let OIB = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))

                psns.append(Osoba(idOsobe: Int(IdOsobe),imeOsobe: ImeOsobe, prezimeOsobe: PrezimeOsobe, OIB: OIB))
                print("\(IdOsobe) | \(PrezimeOsobe) | \(ImeOsobe) | \(OIB)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func updatePersonByID(person: Osoba) {
        
        let updateStatementStirng = "UPDATE osoba SET ImeOsobe='\(person.getImeOsobe())', PrezimeOsobe='\(person.getPrezimeOsobe())' WHERE IdOsobe=(?);"
       
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(person.getIdOsobe()))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updater row in table OSOBA.")
            } else {
                print("Could not update row in table OSOBA.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteOsobaByID(id:Int) {
        print("")
        let deleteStatementStirng = "DELETE FROM osoba WHERE IdOsobe = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row in table Osoba.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Projekt: DBHandler
    //___________________________________________________________________________________________________________ //
    
    func createTableProjekt() {
        print("TABLICA PROJEKT")
        print("________________________________________________")
        let createTableString = "CREATE TABLE IF NOT EXISTS projekt(SifProjekta INTEGER PRIMARY KEY AUTOINCREMENT,NazProjekta TEXT,OpisProjekta TEXT,DatPocetka INTEGER, DatZavrsetka INTEGER); "
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Tablica PROJEKT je stvorena (osim ako prethodno vec ne postoji).")
            } else {
                print("Osoba table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insertProjekt(projekt:Projekt)
    {
        let projekti = readProjekte()
        for _projekt in projekti
        {
            if _projekt.getNazivProjekta() == projekt.getNazivProjekta()
            {
                return
            }
        }
        let queryStatementString = "INSERT INTO projekt(NazProjekta, OpisProjekta, DatPocetka, DatZavrsetka) VALUES (?, ?, ?, ?); "
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(queryStatement, 1, (projekt.getNazivProjekta() as NSString).utf8String, -1, nil)
            sqlite3_bind_text(queryStatement, 2, (projekt.getOpisProjekta() as NSString).utf8String, -1, nil)
            sqlite3_bind_text(queryStatement, 3, (projekt.getDatPoceta() as NSString).utf8String, -1, nil)
            sqlite3_bind_text(queryStatement, 4, (projekt.getDatZavrsetka() as NSString).utf8String, -1, nil)

            // SQLITE 3 STEP ----> IF -> SAMO GA IZVEDI I NE VADI NISTA IZ BAZE
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("Uspjesno dodan novi projekt imena: " + projekt.getNazivProjekta())
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(queryStatement)

    }

    func readProjekte() -> [Projekt] {
        print("")
        print("LISTA PROJEKATA")
        let queryStatementString = "SELECT * FROM projekt;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Projekt] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            // SQLITE 3 STEP ----> WHILE -> IZVEDI TE DOHVATI IZ BAZE
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let SifProjekta = sqlite3_column_int(queryStatement, 0)
                let NazProjekta = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let OpisProjekta = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let DatPocetka = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let DatZavrsetka = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))

                psns.append(Projekt(SifProjekta: Int(SifProjekta), NazProjekta: NazProjekta, OpisProjekta: OpisProjekta, DatPocetka: DatPocetka, DatZavrsetka: DatZavrsetka))
                print("\(SifProjekta) | \(NazProjekta) | \(OpisProjekta) | \(DatPocetka) | \(DatZavrsetka)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns    }
    
    // -> [Projekt]
    func readProjekt() -> [Int] {
        return [1]
    }
    
    
    
    func deleteProjektByID(id:Int) {
        print("")
        let deleteStatementStirng = "DELETE FROM projekt WHERE SifProjekta = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row in table PROJEKT.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Uloga: DBHandler
    //___________________________________________________________________________________________________________ //

    
    func createTableUloga() {
        print("TABLICA ULOGA")
        print("________________________________________________")
        let createTableString = "CREATE TABLE IF NOT EXISTS uloga(IdUloge INTEGER PRIMARY KEY AUTOINCREMENT,NazUloge TEXT); "
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Tablica ULOGA je stvorena (osim ako prethodno vec ne postoji).")
            } else {
                print("Tablica ULOGA ne moze biti kreirana.")
            }
        } else {
            print("CREATE TABLE (ULOGA) statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)

    }
    
    
    func insertUloga(nazUloge: String)
    {
        let uloge = readUloge()
        for _uloge in uloge
        {
            if _uloge.getNazUloge() == nazUloge
            {
                return
            }
        }
        let queryStatementString = "INSERT INTO uloga (NazUloge) VALUES (?); "
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(queryStatement, 1, (nazUloge as NSString).utf8String, -1, nil)
  
            // SQLITE 3 STEP ----> IF -> SAMO GA IZVEDI I NE VADI NISTA IZ BAZE
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("Successfully inserted row in table Uloga.")
            } else {
                print("Could not insert row in table Uloga.")
            }
        } else {
            print("INSERT statement on table ULOGA could not be prepared.")
        }
        sqlite3_finalize(queryStatement)

    }
    
    // -> [Uloga]
    func readUloge() -> [Uloga] {
        print("")
        print("LISTA ULOGA")
        let queryStatementString = "SELECT * FROM uloga;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Uloga] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            // SQLITE 3 STEP ----> WHILE -> IZVEDI TE DOHVATI IZ BAZE
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let _idUloge = sqlite3_column_int(queryStatement, 0)
                let NazUloge = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
               
                psns.append(Uloga(IdUloge: Int(_idUloge), NazUloge: NazUloge))
                print("\(_idUloge) | \(NazUloge)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func updateUlogaByID(id:Int, naziv: String) {
        print("")
        
        // UPDATE Customers
        // SET ContactName='Juan'
        // WHERE Country='Mexico';

        let updateStatementStirng = "UPDATE uloga SET NazUloge='Testna uloga' WHERE IdUloge=(?);"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updater row in table ULOGA.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteUlogaByID(id:Int) {
        print("")
        let deleteStatementStirng = "DELETE FROM uloga WHERE IdUloge = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row in table ULOGA.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // UlogaOsobe: DBHandler
    //___________________________________________________________________________________________________________ //
    
    func createTableUlogaOsobe() {
        print("TABLICA ULOGA_OSOBE")
        print("________________________________________________")
        let createTableString = "CREATE TABLE IF NOT EXISTS ulogaosobaa (SifProjekta INTEGER,IdOsobe INTEGER,IdUloge INTEGER,DatDodjele TEXT,FOREIGN KEY (SifProjekta) REFERENCES projekt(SifProjekta) ON DELETE CASCADE,FOREIGN KEY (IdOsobe) REFERENCES osoba(IdOsobe) ON DELETE CASCADE);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Tablica ULOGA_OSOBE je stvorena (osim ako prethodno vec ne postoji).")
            } else {
                print("Osoba table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)

    }
    
    
    func insertUlogaOsobe(ulogaOsobe:UlogaOsobe){
        //let uloge = readUloge()
        //for _uloge in uloge
        //{
        //    if _uloge.getIdUloge() == uloga.getIdUloge()
        //    {
        //        return
        //    }
        //}
        print("PRIJE INSERTA-----------------------------------------------------------")
        print(ulogaOsobe.getDatDodjele())
        print("-----------------------------------------------------------")

        let queryStatementString = "INSERT INTO ulogaosobaa (SifProjekta, IdOsobe, IdUloge, DatDodjele) VALUES (?, ?, ?, '\(ulogaOsobe.getDatDodjele())');"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(ulogaOsobe.getSifProjekta()))
            sqlite3_bind_int(queryStatement, 2, Int32(ulogaOsobe.getIdOsobe()))
            sqlite3_bind_int(queryStatement, 3, Int32(ulogaOsobe.getIdUloge()))
            // sqlite3_bind_int(queryStatement, 4, Int32(ulogaOsobe.getDatDodjele()))
            sqlite3_bind_text(queryStatement, 4, (ulogaOsobe.getDatDodjele() as NSString).utf8String, -1, nil)


            // SQLITE 3 STEP ----> IF -> SAMO GA IZVEDI I NE VADI NISTA IZ BAZE
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("Successfully inserted row in table UlogaOsobe.")
            } else {
                print("Could not insert row in table UlogaOsobe.")
            }
        } else {
            print("INSERT statement on table ULOGA_OSOBE could not be prepared.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func updateUlogaOsobeByPerson(ulogaOsobe:UlogaOsobe){
        //let uloge = readUloge()
        //for _uloge in uloge
        //{
        //    if _uloge.getIdUloge() == uloga.getIdUloge()
        //    {
        //        return
        //    }
        //}
        
        
        
        
        // UPDATE Customers
        // SET ContactName='Juan'
        // WHERE Country='Mexico';

        /*
        let updateStatementStirng = "UPDATE uloga SET NazUloge='Testna uloga' WHERE IdUloge=(?);"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updater row in table ULOGA.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
        
         
         CREATE TABLE IF NOT EXISTS ulogaosobaa
         
         SifProjekta INTEGER,
         IdOsobe INTEGER,
         IdUloge INTEGER,
         DatDodjele TEXT,
         
         FOREIGN KEY (SifProjekta) REFERENCES projekt(SifProjekta) ON DELETE CASCADE,FOREIGN KEY (IdOsobe) REFERENCES osoba(IdOsobe) ON DELETE CASCADE);
         
         
        */
        
        // let updateStatementStirngEXAMPLE = "UPDATE osoba SET ImeOsobe='\(person.getImeOsobe())', PrezimeOsobe='\(person.getPrezimeOsobe())' WHERE IdOsobe=(?);"

        
        let updateStatementString = "UPDATE ulogaosobaa SET SifProjekta='\(ulogaOsobe.getSifProjekta())', IdUloge='\(ulogaOsobe.getIdUloge())', DatDodjele='\(ulogaOsobe.getDatDodjele())' WHERE IdOsobe=(?);"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(ulogaOsobe.getIdOsobe()))
         

            // SQLITE 3 STEP ----> IF -> SAMO GA IZVEDI I NE VADI NISTA IZ BAZE
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("Successfully updated row in table UlogaOsobe.")
            } else {
                print("Could not update row in table UlogaOsobe.")
            }
        } else {
            print("UPDATE statement on table ULOGA_OSOBE could not be prepared.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    // -> [UlogaOsobe]
    func readAllUlogaOsoba() -> [UlogaOsobeEnriched] {
        print("")
        print("LISTA ULOGA OSOBA")
        let queryStatementString = String("SELECT ulogaosobaa.SifProjekta, ulogaosobaa.IdOsobe, ulogaosobaa.IdUloge, " +
                                          "ulogaosobaa.DatDodjele, projekt.NazProjekta, osoba.ImeOsobe, osoba.PrezimeOsobe, uloga.NazUloge " +
                                          "FROM (((ulogaosobaa " +
                                          "INNER JOIN projekt ON ulogaosobaa.SifProjekta = projekt.SifProjekta) " +
                                          "INNER JOIN osoba ON ulogaosobaa.IdOsobe = osoba.IdOsobe) " +
                                          "INNER JOIN uloga ON ulogaosobaa.IdUloge = uloga.IdUloge);")
        
        var queryStatement: OpaquePointer? = nil
        var psns : [UlogaOsobeEnriched] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            // SQLITE 3 STEP ----> WHILE -> IZVEDI TE DOHVATI IZ BAZE
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let sifProjekta = sqlite3_column_int(queryStatement, 0)
                let idOsobe = sqlite3_column_int(queryStatement, 1)
                let idUloge = sqlite3_column_int(queryStatement, 2)
                let datDodjele = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let NazProjekta = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let ImeOsobe = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let PrezimeOsobe = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let NazUloge = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                
                psns.append(UlogaOsobeEnriched(SifProjekta: Int(sifProjekta),
                                               IdOsobe: Int(idOsobe),
                                               IdUloge: Int(idUloge),
                                               DatDodjele: datDodjele,
                                               NazProjekta: NazProjekta,
                                               ImeOsobe: ImeOsobe,
                                               PrezimeOsobe: PrezimeOsobe,
                                               NazUloge: NazUloge))
                print("\(sifProjekta) | \(idOsobe) | \(idUloge) | \(datDodjele)  | \(NazProjekta)  | \(ImeOsobe)  | \(PrezimeOsobe) | \(NazUloge)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteUlogaOsobeByPerson(personId:Int) {
        print("")
        let deleteStatementStirng = "DELETE FROM ulogaosobaa WHERE IdOsobe = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(personId))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row in table ULOGA_OSOBE.")
            } else {
                print("Could not delete row in table ULOGA_OSOBE.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteUlogaOsobeBySifProjekta(sifProjekta:Int) {
        print("")
        let deleteStatementStirng = "DELETE FROM ulogaosobaa WHERE SifProjekta = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(sifProjekta))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row in table ULOGA_OSOBE.")
            } else {
                print("Could not delete row in table ULOGA_OSOBE.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Project: DBHandler
    //___________________________________________________________________________________________________________ //

    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY,name TEXT,age INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
              print("Testna tablica PERSON je stvorena (osim ako prethodno vec ne postoji).")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id:Int, name:String, age:Int)
    {
        let persons = read()
        for p in persons
        {
            if p.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO person (Id, name, age) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(age))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Person] {
        let queryStatementString = "SELECT * FROM person;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Person] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let year = sqlite3_column_int(queryStatement, 2)
                psns.append(Person(id: Int(id), name: name, age: Int(year)))
                print("Query Result:")
                print("\(id) | \(name) | \(year)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   // TABLES DELETING
   //___________________________________________________________________________________________________________ //
    
    func deleteTableOsoba() {
        let deleteStatementStirng = "DROP TABLE osoba;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully dropped table.")
            } else {
                print("Could not drop table.")
            }
        } else {
            print("DROP statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteTableProjekt() {
        let deleteStatementStirng = "DROP TABLE projekt;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully dropped table.")
            } else {
                print("Could not drop table.")
            }
        } else {
            print("DROP statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    func deleteTableUloga() {
        let deleteStatementStirng = "DROP TABLE uloga;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully dropped table.")
            } else {
                print("Could not drop table.")
            }
        } else {
            print("DROP statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    func deleteTableUlogaOsobe() {
        let deleteStatementStirng = "DROP TABLE ulogaosobaa;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully dropped table.")
            } else {
                print("Could not drop table.")
            }
        } else {
            print("DROP statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    
}
