-- #1.
-- How many stops are in the database.
SELECT COUNT(id) AS stops FROM stops

-- #2.
-- Find the id value for the stop 'Craiglockhart'
SELECT id FROM stops WHERE name='Craiglockhart'

-- #3.
-- Give the id and the name for the stops on the '4' 'LRT' service.
SELECT id, name
   FROM stops JOIN route ON id=stop
WHERE num='4' AND company='LRT'

-- #4.
-- The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53).
-- Run the query and notice the two services that link these stops have a count of 2.
-- Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*)=2

-- #5.
-- Execute the self join shown and observe that b.stop gives all the places you can get to from
-- Craiglockhart, without changing routes. Change the query so that it shows the services from
-- Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop=149

-- #6.
-- The query shown is similar to the previous one, however by joining two copies of the stops
-- table we can refer to stops by name rather than by number. Change the query so that the
-- services between 'Craiglockhart' and 'London Road' are shown.
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='London Road'

-- #7.
-- Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT(R1.company), R1.num FROM route R1, route R2
  WHERE R1.num=R2.num AND R1.company=R2.company
    AND (R1.stop=115 AND R2.stop=137)

-- #8.
-- Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT DISTINCT(R1.company), R1.num FROM route R1, route R2
  WHERE R1.num=R2.num AND R1.company=R2.company
    AND ( R1.stop = (SELECT id FROM stops WHERE name='Craiglockhart')
              AND R2.stop= (SELECT id FROM stops WHERE name='Tollcross') )

-- #9.
-- Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking
-- one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the
-- company and bus no. of the relevant services.
SELECT S.name, R1.company, R1.num FROM route R1, route R2, stops S
  WHERE R1.num=R2.num AND R1.company=R2.company AND R2.stop=S.id
    AND R1.stop = (SELECT id FROM stops WHERE name='Craiglockhart')


-- #10.
-- Find the routes involving two buses that can go from Craiglockhart to Sighthill.
-- Show the bus no. and company for the first bus, the name of the stop for the transfer,
-- and the bus no. and company for the second bus.
SELECT DISTINCT(R1a.num), R1a.company, S.name, R2b.num, R2b.company
    FROM route R1a, route R1b, route R2a, route R2b, stops S
  WHERE R1a.stop = (SELECT id FROM stops WHERE name='Craiglockhart')
  AND R1a.num=R1b.num AND R1a.company=R1b.company
  AND R1b.stop=R2a.stop
  AND R2a.num=R2b.num AND R2a.company=R2b.company
  AND R2a.stop=S.id
  AND R2b.stop = (SELECT id FROM stops WHERE name='Sighthill')
