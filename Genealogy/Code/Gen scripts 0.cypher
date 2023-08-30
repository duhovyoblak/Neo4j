// 0.1 Vytvorenie constraintov

CREATE CONSTRAINT FOR (p:Person) REQUIRE p.id IS UNIQUE;

CREATE INDEX Country_IDX  FOR (n:Country ) ON (n.name);
CREATE INDEX Location_IDX FOR (n:Location) ON (n.name);