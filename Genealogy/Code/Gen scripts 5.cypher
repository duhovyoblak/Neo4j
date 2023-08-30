// 1.1 Narodeni v krajine
MATCH (p:Person)-[r:BORN_IN]->(c:Country) 
WITH c.name AS Krajina, p.bornY AS Rok, COLLECT( p.name ) AS Narodeni
RETURN Rok, Krajina, Narodeni
ORDER BY Rok, Krajina

// 1.2 Zomreli v krajine
MATCH (p:Person)-[r:DIED_IN]->(c:Country) 
WITH c.name AS Krajina, p.diedY AS Rok, COLLECT( p.name ) AS Zomreli
RETURN Rok, Krajina, Zomreli
ORDER BY Rok, Krajina

// 4.0 Ukaz mesta
MATCH p=(a:Person)--(l:Location)
RETURN p

// 4.1 Ukaz krajiny
MATCH p=(a:Person)--(c:Country)
RETURN p