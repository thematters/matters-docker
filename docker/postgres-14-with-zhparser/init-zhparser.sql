
CREATE EXTENSION pg_trgm;
CREATE EXTENSION zhparser;
CREATE EXTENSION pg_bigm;

CREATE TEXT SEARCH CONFIGURATION chinese_zh (PARSER = zhparser);

-- add 2 new aliases
-- j     | abbreviation,简称 | 中共   | {simple}     | simple     | {中共}
-- x     | unknown,未知词    | 比特币 | {simple}     | simple     | {比特币}

ALTER TEXT SEARCH CONFIGURATION chinese_zh ADD MAPPING FOR n,v,a,i,e,l,t,j,x WITH simple;

