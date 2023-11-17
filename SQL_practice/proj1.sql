-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;

-- Question 0
CREATE VIEW q0(era)
AS
  SELECT MAX(era)
  FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  SELECT p.namefirst, p.namelast,p.birthyear
  FROM people p
  WHERE p.weight > 300
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  SELECT p.namefirst, p.namelast,p.birthyear
  FROM people p
  WHERE p.namefirst like '% %'
  ORDER BY p.namefirst ASC, p.namelast ASC
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  SELECT p.birthyear,AVG(p.height), COUNT(*)
  FROM people p
  GROUP BY p.birthyear
  ORDER BY p.birthyear

;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  SELECT p.birthyear,AVG(p.height), COUNT(*)
  FROM people p
  GROUP BY p.birthyear
  HAVING AVG(p.height) > 70
  ORDER BY p.birthyear ASC
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  SELECT p.namefirst, p.namelast, p.playerid, hof.yearid
  FROM people AS p, HallofFame AS hof
  WHERE p.playerid = hof.playerid AND hof.inducted = 'Y'
  ORDER BY hof.yearid DESC, p.playerid ASC

;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  SELECT q.namefirst, q.namelast, q.playerid, s.schoolid,q.yearid
  FROM q2i q, collegeplaying col, schools s
  WHERE col.schoolid = s.schoolid AND s.schoolState = 'CA' AND q.playerid = col.playerid
  ORDER BY q.yearid DESC, s.schoolid, q.playerid


;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  SELECT q.playerid, q.namefirst, q.namelast,col.schoolid
  FROM q2i q LEFT OUTER JOIN collegeplaying col 
  ON q.playerid = col.playerid
  ORDER BY q.playerid DESC, col.schoolid

;
-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  SELECT b.playerID, p.namefirst, p.namelast, b.yearid, (b.H + b.H2B + 2*b.H3B + 3*b.HR + 0.0)/(b.AB+0.0) AS slg
  FROM batting b, people p
  WHERE b.AB > 50 AND p.playerid = b.playerid
  ORDER BY slg DESC, b.yearid, b.playerid
  LIMIT 10
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  SELECT b.playerid, p.namefirst,p.namelast, (SUM(b.H) + SUM(b.H2B) + 2*SUM(b.H3B) + 3*SUM(b.HR) + 0.0)/(SUM(b.AB)+0.0) AS lslg
  FROM batting b, people p
  WHERE p.playerid = b.playerid
  GROUP BY b.playerid
  HAVING SUM(b.AB) > 50
  ORDER BY lslg DESC, b.playerid
  LIMIT 10

;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
  SELECT p.namefirst, p.namelast, (SUM(b.H) + SUM(b.H2B) + 2*SUM(b.H3B) + 3*SUM(b.HR) + 0.0)/(SUM(b.AB)+0.0) AS lslg
  FROM batting b, people p
  WHERE p.playerid = b.playerid
  GROUP BY b.playerid
  HAVING (SUM(b.H) + SUM(b.H2B) + 2*SUM(b.H3B) + 3*SUM(b.HR) + 0.0)/(SUM(b.AB)+0.0) >
    (
      SELECT (SUM(b.H) + SUM(b.H2B) + 2*SUM(b.H3B) + 3*SUM(b.HR) + 0.0)/(SUM(b.AB)+0.0)
      FROM batting b
      WHERE b.playerid = 'mayswi01'
    ) AND SUM(b.AB) > 50
  ORDER BY lslg DESC, b.playerid


;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg)
AS
  SELECT s.yearid, min(s.salary),max(s.salary),avg(s.salary)
  FROM Salaries s
  GROUP BY s.yearid

;


-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS

  WITH helper1(low,high,width) AS(
    SELECT MIN(salary),MAX(salary), CAST((MAX(salary)-MIN(salary))/10.0 AS INT)
    FROM salaries 
    WHERE yearid = '2016' 
  ),
    helper2 (binid,low,high,width) AS(
      SELECT binid ,binid *h.width + h.low, (binid+1)*h.width + h.low, h.width
      FROM binids, helper1 AS h
  )

  SELECT h2.binid,h2.low,h2.high,COUNT(*)
  FROM helper2 h2 LEFT OUTER JOIN Salaries s
  ON ((s.salary < h2.high and s.salary >= h2.low and h2.binid <9) 
        OR 
        (s.salary <= h2.high and s.salary >= h2.low and h2.binid =9) 
      )
        and s.yearid='2016'
  
  GROUP BY h2.binid
  ORDER BY h2.binid
;


-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
  WITH year_salary AS(
    SELECT yearid AS yid, MIN(salary) AS mins, MAX(salary) AS maxs, AVG(salary) AS average
    FROM salaries
    GROUP BY yearid
  )
  SELECT ys1.yid, ys1.mins - ys2.mins, ys1.maxs - ys2.maxs, ys1.average - ys2.average
  FROM year_salary ys1
  INNER JOIN year_salary ys2
  ON ys1.yid = ys2.yid +1
  ORDER BY ys1.yid
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
  WITH salary_table AS(
    SELECT playerid, salary, yearid
    FROM salaries 
    WHERE (yearid = 2000 AND salary = 
          (SELECT MAX(salary)
          FROM salaries s1
          WHERE s1.yearid = 2000)
          )
          OR 
          (yearid = 2001 AND salary =
          (SELECT MAX(salary)
          FROM salaries s2
          WHERE s2.yearid = 2001)
          )
  )
  SELECT p.playerid, p.namefirst, p.namelast, st.salary, st.yearid
  FROM people p INNER JOIN salary_table st
  ON p.playerid = st.playerid
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
  SELECT a.teamid, MAX(s.salary)-MIN(s.salary)
  FROM allstarfull a, Salaries s
  WHERE a.playerid = s.playerid AND s.yearid = '2016' AND a.yearid = s.yearid
  GROUP BY a.teamid
;

