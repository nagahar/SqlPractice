-- 5-1
CREATE VIEW ViewRenshu5_1 AS
SELECT
  shohin_mei,
  hanbai_tanka,
  torokubi
FROM
  SHOHIN
WHERE
  hanbai_tanka >= 1000
  AND torokubi = '2009-09-20';

SELECT * FROM ViewRenshu5_1;

-- 5-2
INSERT INTO ViewRenshu5_1 VALUES ('ナイフ', 300, '2009-11-02');

-- 5-3
SELECT
  shohin_id,
  shohin_mei,
  shohin_bunrui,
  hanbai_tanka,
  (SELECT
    AVG(hanbai_tanka)
   FROM
    SHOHIN
  ) AS hanbai_tanka_all
FROM
  SHOHIN;

-- 5-4
CREATE VIEW AvgTankaByBunrui AS
SELECT
  shohin_id,
  shohin_mei,
  shohin_bunrui,
  hanbai_tanka,
  (
    SELECT
      AVG(hanbai_tanka)
    FROM
      SHOHIN S2
    WHERE
      S1.shohin_bunrui = S2.shohin_bunrui
    GROUP BY
      shohin_bunrui
  ) AS avg_hanbai_tanka
FROM
  SHOHIN S1;

SELECT * FROM AvgTankaByBunrui;

-- 6-1
SELECT
  shohin_mei,
  shiire_tanka
FROM
  SHOHIN
WHERE shiire_tanka NOT IN (500, 2800, 5000);

SELECT
  shohin_mei,
  shiire_tanka
FROM
  SHOHIN
WHERE shiire_tanka NOT IN (500, 2800, 5000, NULL);

-- 6-2
SELECT
  SUM(CASE
    WHEN hanbai_tanka <= 1000
    THEN 1
    ELSE 0
    END) AS low_price,
  SUM(CASE
    WHEN 1001 <= hanbai_tanka AND hanbai_tanka <= 3000
    THEN 1
    ELSE 0
    END) AS mid_price,
  SUM(CASE
    WHEN 3001 <= hanbai_tanka
    THEN 1
    ELSE 0
    END) AS high_price
FROM
  SHOHIN;

-- 7-1
SELECT
  *
FROM
  SHOHIN
UNION
SELECT
  *
FROM
  SHOHIN
INTERSECT
SELECT
  *
FROM
  SHOHIN
ORDER BY shohin_id

-- DDL：テーブル作成
CREATE TABLE TenpoShohin
(tenpo_id  CHAR(4)       NOT NULL,
 tenpo_mei  VARCHAR(200) NOT NULL,
 shohin_id CHAR(4)       NOT NULL,
 suryo     INTEGER       NOT NULL,
 PRIMARY KEY (tenpo_id, shohin_id));

-- DML：データ登録
BEGIN TRANSACTION;

INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000A',	'東京',		'0001',	30);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000A',	'東京',		'0002',	50);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000A',	'東京',		'0003',	15);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000B',	'名古屋',	'0002',	30);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000B',	'名古屋',	'0003',	120);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000B',	'名古屋',	'0004',	20);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000B',	'名古屋',	'0006',	10);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000B',	'名古屋',	'0007',	40);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000C',	'大阪',		'0003',	20);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000C',	'大阪',		'0004',	50);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000C',	'大阪',		'0006',	90);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000C',	'大阪',		'0007',	70);
INSERT INTO TenpoShohin (tenpo_id, tenpo_mei, shohin_id, suryo) VALUES ('000D',	'福岡',		'0001',	100);

COMMIT;

SELECT
  COALESCE(TS.tenpo_id, '不明') AS tempo_id,
  COALESCE(TS.tenpo_mei, '不明') AS tempo_mei,
  S.shohin_id,
  S.shohin_mei,
  S.hanbai_tanka
FROM
  TenpoShohin AS TS
  RIGHT OUTER JOIN Shohin AS S
ON TS.shohin_id = S.shohin_id
ORDER BY TS.tenpo_id;

-- 8-1
SELECT
  shohin_id,
  shohin_mei,
  hanbai_tanka,
  MAX (hanbai_tanka) OVER (ORDER BY shohin_id) AS current_max_tanka
FROM
  Shohin;
-- 8-2
SELECT
  shohin_id,
  shohin_mei,
  hanbai_tanka,
  torokubi,
  SUM (hanbai_tanka) OVER (ORDER BY COALESCE (torokubi, CAST('0001-01-01' AS DATE))) AS current_sum_tanka
FROM
  Shohin
ORDER BY
  COALESCE (torokubi, CAST('0001-01-01' AS DATE));

SELECT
  shohin_id,
  shohin_mei,
  hanbai_tanka,
  torokubi,
  SUM (hanbai_tanka) OVER (ORDER BY torokubi NULLS FIRST) AS current_sum_tanka
FROM
  Shohin
ORDER BY
  torokubi NULLS FIRST;

