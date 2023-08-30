// 1.0 Ukaz osoby
MATCH p=(a:Person)-[:IS_CHILD|:MARRIED]->(b:Person)
RETURN p

// 2.0 Deti osoby
MATCH (dieta:Person)-[:IS_CHILD]->(rodic:Person)
WITH rodic.name AS rodic, COLLECT(dieta.name) AS deti, count(dieta.name) AS pocetDeti
RETURN rodic, pocetDeti, deti
ORDER BY rodic

// 2.0 Pradeti osoby
MATCH (dieta:Person)-[:IS_CHILD*2]->(rodic:Person)
WITH rodic.name AS prarodic, COLLECT(dieta.name) AS deti, count(dieta.name) AS pocetDeti
RETURN prarodic, pocetDeti, deti
ORDER BY prarodic

// 2.1 Bratranci/sesternice osoby
MATCH (osoba:Person)-[:IS_CHILD]->(rodic:Person)-[:IS_CHILD]->(prarodic:Person)<-[:IS_CHILD]-(teta:Person)<-[:IS_CHILD]-(bratranec:Person)
WHERE osoba IS NOT null
WITH osoba.name AS dieta, COLLECT( DISTINCT bratranec.name) AS bratranci_sesternice
RETURN dieta, bratranci_sesternice
ORDER BY dieta

// 2.2 Tety/strykovia osoby
MATCH (osoba:Person)-[:IS_CHILD]->(rodic:Person)-[:IS_CHILD]->(prarodic:Person)<-[:IS_CHILD]-(teta:Person)
WITH osoba.name AS Osoba, COLLECT( DISTINCT teta.name) AS Tety_strykovia
RETURN Osoba, Tety_strykovia
ORDER BY Osoba