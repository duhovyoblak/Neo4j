// 3.0 Rodova linia
MATCH p=(a:Person)-[:IS_CHILD]->(b:Person)
RETURN p

// 3.1 Otcovska linia
MATCH p=(a:Person)-[:IS_CHILD*1..]->(b:Person)
WHERE ALL (x IN tail(nodes(p)) WHERE x.sex = 'M')
WITH nodes(p) AS linia, length(p)+1 AS generacii
RETURN linia, generacii
ORDER BY generacii DESC

// 3.2 Otcovska linia TABLE
MATCH p=(a:Person)-[:IS_CHILD*1..]->(b:Person)
WHERE ALL (x IN tail(nodes(p)) WHERE x.sex = 'M')
WITH head(nodes(p)).name AS dieta,  [n IN tail(nodes(p)) | n.name] AS linia, length(p)+1 AS generacii
RETURN DISTINCT dieta, generacii, linia
ORDER BY generacii DESC, dieta

// 3.3 Materska linia
MATCH p=(a:Person)-[:IS_CHILD*1..]->(b:Person)
WHERE ALL (x IN tail(nodes(p)) WHERE x.sex = 'F')
WITH nodes(p) AS linia, length(p)+1 AS generacii
RETURN linia, generacii
ORDER BY generacii DESC

// 3.4 Materska linia TABLE
MATCH p=(a:Person)-[:IS_CHILD*1..]->(b:Person)
WHERE ALL (x IN tail(nodes(p)) WHERE x.sex = 'F')
WITH head(nodes(p)).name AS dieta,  [n IN tail(nodes(p)) | n.name] AS linia, length(p)+1 AS generacii
RETURN DISTINCT dieta, generacii, linia
ORDER BY generacii DESC, dieta