USE Lahman;

SELECT CONCAT(m.nameFirst, ' ', m.nameLast) AS [Player]
	, b.yearID AS [Season]
	, b.PA
	, CAST(p.IPOuts/3.0 AS DECIMAL(18,1)) AS [IP]
	, a.*
FROM (
	SELECT playerID
		, yearID
		, SUM(AB+BB+IBB+HBP+SH+SF) AS PA
	FROM dbo.Batting
	GROUP BY playerID, yearID
	HAVING SUM(AB+BB+IBB+HBP+SH+SF) >= 50
) b
INNER JOIN (
	SELECT playerID
		, yearID
		, SUM(IPOuts) AS IPOuts
	FROM dbo.Pitching
	GROUP BY playerID, yearID
	HAVING SUM(IPOuts) >= 30
) p ON b.playerID = p.playerID AND b.yearID = p.yearID
INNER JOIN (
	SELECT playerID
		, yearID
		, SUM(G_all) AS G_all
		, SUM(G_p) AS G_p
		, SUM(G_c) AS G_c
		, SUM(G_1b) AS G_1b
		, SUM(G_2b) AS G_2b
		, SUM(G_3b) AS G_3b
		, SUM(G_ss) AS G_ss
		, SUM(G_lf) AS G_lf
		, SUM(G_cf) AS G_cf
		, SUM(G_rf) AS G_rf
		, SUM(G_dh) AS G_dh
	FROM dbo.Appearances
	GROUP BY playerID, yearID
	HAVING SUM(G_p) <= (SUM(G_all)*.5)
) a ON a.playerID = b.playerID AND a.yearID = b.yearID
INNER JOIN dbo.Master m ON b.playerID = m.playerID
WHERE b.yearID >= 1950
ORDER BY b.yearID DESC;