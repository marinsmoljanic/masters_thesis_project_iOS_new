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
        
        print("")
        print("")
        //createTableOsoba()
        //insertOsoba(osoba: Osoba(idOsobe: 0, imeOsobe: "Karlo", prezimeOsobe: "Krcelic", OIB: "749933829129"))
        //procitaneOsobe = readOsobe()
        //print("")
        //print("PROCITANA OSOBA")
        //let osoba:Osoba = readOsoba(idOsobe: 1)
        //print(osoba.getImeOsobe() + " -- " + osoba.getPrezimeOsobe())
        //deleteOsobaByID(id: 5)
        //deleteTableOsoba()
        
        
        print("")
        print("")
        // createTableProjekt()
        // insertProjekt(projekt: Projekt(SifProjekta: 5, NazProjekta: "Pleternica", OpisProjekta: "Izrada murala", DatPocetka: 2, DatZavrsetka: 10))
        // procitaniProjekti = readProjekte()
        // deleteProjektByID(id: 4)
        // deleteTableProjekt()
        
        
        print("")
        print("")
        // createTableUloga()
        // insertUloga(uloga: Uloga(IdUloge: 0, NazUloge: "Vjezbenik"))
        // insertUloga(uloga: Uloga(IdUloge: 1, NazUloge: "Pripravnik"))
        // procitaneUloge = readUloge()
        // deleteUlogaByID(id: 0)
        // deleteTableUloga()
        
        
        print("")
        print("")
        
        // createTableUlogaOsobe()
        // insertUlogaOsobe(ulogaOsobe: UlogaOsobe(SifProjekta: 5, IdOsobe: 5, IdUloge: 0, DatDodjele: 222))
        // deleteUlogaOsobeBySifProjekta(sifProjekta: 4)
        // ulogeOsoba = readAllUlogaOsoba()
        // deleteTableUlogaOsobe()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    var procitaneOsobe:[Osoba] = []
    var procitaniProjekti:[Projekt] = []
    var procitaneUloge:[Uloga] = []
    var ulogeOsoba:[UlogaOsobe] = []

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
        // print("")
        // print("LISTA OSOBA")
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
                // print("\(IdOsobe) | \(PrezimeOsobe) | \(ImeOsobe) | \(OIB)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
        
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
            sqlite3_bind_int(queryStatement, 3, Int32(projekt.getDatPoceta()))
            sqlite3_bind_int(queryStatement, 4, Int32(projekt.getDatZavrsetka()))

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
                let DatPocetka = sqlite3_column_int(queryStatement, 3)
                let DatZavrsetka = sqlite3_column_int(queryStatement, 4)

                psns.append(Projekt(SifProjekta: Int(SifProjekta), NazProjekta: NazProjekta, OpisProjekta: OpisProjekta, DatPocetka: Int(DatPocetka), DatZavrsetka: Int(DatZavrsetka)))
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
    
    
    func insertUloga(uloga:Uloga)
    {
        let uloge = readUloge()
        for _uloge in uloge
        {
            if _uloge.getNazUloge() == uloga.getNazUloge()
            {
                return
            }
        }
        let queryStatementString = "INSERT INTO uloga (NazUloge) VALUES (?); "
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(queryStatement, 1, (uloga.getNazUloge() as NSString).utf8String, -1, nil)
  
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
        let createTableString = "CREATE TABLE IF NOT EXISTS ulogaosobaa (SifProjekta INTEGER,IdOsobe INTEGER,IdUloge INTEGER,DatDodjele INTEGER,FOREIGN KEY (SifProjekta) REFERENCES projekt(SifProjekta) ON DELETE CASCADE,FOREIGN KEY (IdOsobe) REFERENCES osoba(IdOsobe) ON DELETE CASCADE);"
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
        let queryStatementString = "INSERT INTO ulogaosobaa (SifProjekta, IdOsobe, IdUloge, DatDodjele) VALUES (?, ?, ?, ?);"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(ulogaOsobe.getSifProjekta()))
            sqlite3_bind_int(queryStatement, 2, Int32(ulogaOsobe.getIdOsobe()))
            sqlite3_bind_int(queryStatement, 3, Int32(ulogaOsobe.getIdUloge()))
            sqlite3_bind_int(queryStatement, 4, Int32(ulogaOsobe.getDatDodjele()))

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
    
    // -> [UlogaOsobe]
    func readAllUlogaOsoba() -> [UlogaOsobe] {
        print("")
        print("LISTA ULOGA OSOBA")
        let queryStatementString = "SELECT * FROM ulogaosobaa;"
        var queryStatement: OpaquePointer? = nil
        var psns : [UlogaOsobe] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            // SQLITE 3 STEP ----> WHILE -> IZVEDI TE DOHVATI IZ BAZE
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let _sifProjekta = sqlite3_column_int(queryStatement, 0)
                let _idOsobe = sqlite3_column_int(queryStatement, 1)
                let _idUloge = sqlite3_column_int(queryStatement, 2)
                let _datDodjele = sqlite3_column_int(queryStatement, 3)
               
                psns.append(UlogaOsobe(SifProjekta: Int(_sifProjekta), IdOsobe: Int(_idOsobe), IdUloge: Int(_idUloge), DatDodjele: Int(_datDodjele)))
                print("\(_sifProjekta) | \(_idOsobe) | \(_idUloge) | \(_datDodjele)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
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
        let deleteStatementStirng = "DROP TABLE ulogaosobe;"
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
