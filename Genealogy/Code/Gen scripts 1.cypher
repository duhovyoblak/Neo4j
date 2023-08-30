// 0.0 Vycistenie DB
MATCH(n)
DETACH DELETE n;

// 0.1 Nacitanie entity Person

LOAD CSV WITH HEADERS FROM "file:///D:/GitHub/Neo4j/Genealogy/GEN_person.csv" AS row
CREATE  (p:Person {id:        toInteger(row.ID),
                 name:        COALESCE(row.GIVENNAME + ' ' + row.SURNAME, 
                                       row.GIVENNAME + ' ' + row.BIRTHNAME,
                                       row.SURNAME,
                                       row.BIRTHNAME,
                                       row.GIVENNAME
                                       ),
                 givName:   row.GIVENNAME,
                 birthName: row.BIRTHNAME,
                 surName:   row.SURNAME,
                 sex:       row.SEX,
                 title:     row.TITLE,
                 bornY:     toInteger(row.BORN_Y),
                 bornM:     toInteger(row.BORN_M),
                 bornD:     toInteger(row.BORN_D),
                 bornLoc:   row.BORN_LOC,
                 bornCtry:  row.BORN_CTRY,
                 diedY:     toInteger(row.DIED_Y),
                 diedM:     toInteger(row.DIED_M),
                 diedD:     toInteger(row.DIED_D),
                 diedLoc:   row.DIED_LOC,
                 diedCtry:  row.DIED_CTRY,
                 notes:     row.NOTES
               });

// 0.2 Nacitanie deti a manzelstiev
LOAD CSV WITH HEADERS FROM "file:///D:/GitHub/Neo4j/Genealogy/GEN_child.csv" AS row
MATCH (c:Person {id: toInteger(row.CHILD_ID)}), (p:Person {id: toInteger(row.PARENT_ID)})
MERGE (c)-[:IS_CHILD]->(p);

// Nacitanie manzelstiev
LOAD CSV WITH HEADERS FROM "file:///D:/GitHub/Neo4j/Genealogy/GEN_couple.csv" AS row
MATCH (a:Person {id: toInteger(row.PERA_ID)}), (b:Person {id: toInteger(row.PERB_ID)})
MERGE (a)-[:MARRIED {marY: toInteger(row.MAR_Y),
                     marM: toInteger(row.MAR_M),
                     marD: toInteger(row.MAR_D),
                     div:  row.DIV,
                     divY: toInteger(row.DIV_Y),
                     divM: toInteger(row.DIV_M),
                     divD: toInteger(row.DIV_D) }]->(b);


// 0.3 Nacitanie krajin

// Krajina narodenia a umrtia
LOAD CSV WITH HEADERS FROM "file:///D:/GitHub/Neo4j/Genealogy/GEN_person.csv" AS row
MERGE (b:Country {name: row.BORN_CTRY})
MERGE (d:Country {name: row.DIED_CTRY});

// Vytvorenie vazby BORN_IN pre krajiny
MATCH (p:Person), (c:Country {name: p.bornCtry})
WHERE p.bornCtry <> '_unknown_'
MERGE (p)-[:BORN_IN]->(c);

// Vytvorenie vazby DIED_IN pre krajiny
MATCH (p:Person), (c:Country {name: p.diedCtry})
WHERE p.diedCtry <> '_unknown_'
MERGE (p)-[:DIED_IN]->(c);

// 0.4 Nacitanie miest

// Mesto narodenia a umrtia
MATCH (p:Person)
WHERE p.bornLoc is not null
MERGE (b:Location {name: p.bornLoc});

MATCH (p:Person) 
WHERE p.diedLoc is not null
MERGE (d:Location {name: p.diedLoc});

// Vytvorenie vazby BORN_IN pre mesta
MATCH (p:Person), (l:Location {name: p.bornLoc})
WHERE p.bornLoc <> '_unknown_'
MERGE (p)-[:BORN_IN]->(l);

// Vytvorenie vazby DIED_IN pre mesta
MATCH (p:Person), (l:Location {name: p.diedLoc})
WHERE p.diedLoc <> '_unknown_'
MERGE (p)-[:DIED_IN]->(l);

// 0.5 Otcovska linia - SET praotec
MATCH (a:Person)-[:IS_CHILD*2..]->(b:Person)
WHERE (b.sex = 'M') AND NOT( (b)-[:IS_CHILD]->(:Person) )
WITH a, b
SET b:Praotec
RETURN DISTINCT b.name, COLLECT(a.name)

// 0.6 Materska linia - SET pramama
MATCH (a:Person)-[:IS_CHILD*2..]->(b:Person)
WHERE (b.sex = 'F') AND NOT( (b)-[:IS_CHILD]->(:Person) )
WITH a, b
SET b:Pramama
RETURN DISTINCT b.name, COLLECT(a.name)