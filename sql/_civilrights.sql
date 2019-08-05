/* Data and analysis for law enforcement civil rights case */

CREATE TABLE lions.investigating_agency_grp
  SELECT caseid,
    district,
	GROUP_CONCAT(agency) AS agencies
  FROM lions.investigating_agency
  GROUP BY caseid, district
;

ALTER TABLE lions.investigating_agency_grp
  ADD KEY caseid_district_idx(caseid,district)
;

ALTER TABLE lions.court_history
  ADD KEY id_caseid_district_idx(id, caseid, district),
  ADD KEY id_caseid_district_court_idx(id, caseid, district, court),
  ADD KEY caseid_district_idx(caseid,district)
;

CREATE TEMPORARY TABLE lions.maxcrthisid
  SELECT d.caseid,
    d.district,
	d.partid AS partid,
	MAX(d.crthsid) AS maxcrthisid
  FROM lions.participant_court d INNER JOIN lions.court_history ch
    ON d.crthsid = ch.id
	AND d.caseid = ch.caseid
	AND d.district = ch.district
  WHERE ch.court IN('NC', 'DC', 'MJ', 'MM', 'MD','ST','MG')
  GROUP BY caseid,
    district,
	partid
;

ALTER TABLE lions.maxcrthisid
  ADD KEY caseid_district_partid_idx(caseid,district,partid),
  ADD KEY caseid_district_partid_crthisid_idx(caseid,district,partid,maxcrthisid)
;

DROP TABLE IF EXISTS lions.participant_court_dispo
;
CREATE TABLE lions.participant_court_dispo
  SELECT p.district,
    p.caseid,
	p.partid,
	p.crthsid,
	p.disposition,
	p.disposition_reason,
	p.disposition_date
  FROM lions.participant_court p INNER JOIN lions.maxcrthisid m
    ON p.caseid = m.caseid
	  AND p.district = m.district
	  AND p.partid = m.partid
	  AND p.crthsid = m.maxcrthisid
;

ALTER TABLE lions.participant_court_dispo
  ADD KEY caseid_district_idx(caseid,district),
  ADD KEY caseid_district_partid_idx(caseid,district,partid),
  ADD KEY district_idx(district),
  ADD KEY disposition_idx(disposition),
  ADD KEY disposition_reason_idx(disposition_reason)
;  

DROP TABLE IF EXISTS lions.case_prog_cat_cr_cops
;
CREATE TABLE lions.case_prog_cat_cr_cops
  LIKE lions.case_prog_cat
;

INSERT INTO lions.case_prog_cat_cr_cops
  SELECT *
  FROM lions.case_prog_cat
  WHERE prog_cat = '05D'
;

ALTER TABLE lions.case_prog_cat_cr_cops
  ADD KEY caseid_district_idx(caseid, district)
;

DROP TABLE IF EXISTS lions.participant_court_dispo_cr_cops
;
CREATE TABLE IF NOT EXISTS lions.participant_court_dispo_cr_cops
  LIKE lions.participant_court_dispo
;

INSERT INTO lions.participant_court_dispo_cr_cops
  SELECT p.*
  FROM lions.participant_court_dispo p INNER JOIN lions.case_prog_cat_cr_cops
	USING(caseid, district)
;

DROP TABLE IF EXISTS lions.defendants_cr_cops
;
CREATE TABLE lions.defendants_cr_cops
  LIKE lions.defendants
;

INSERT INTO lions.defendants_cr_cops
  SELECT d.*
  FROM lions.defendants d INNER JOIN lions.case_prog_cat_cr_cops
    USING(caseid, district)
;

ALTER TABLE lions.defendants_cr_cops
  ADD disposition_date VARCHAR(25),
  ADD disposition VARCHAR(5),
  ADD disposition_reason VARCHAR(10),
  ADD KEY disposition_idx(disposition),
  ADD KEY disposition_reason_idx(disposition_reason)
;

UPDATE lions.defendants_cr_cops d, lions.participant_court_dispo_cr_cops p
  SET d.disposition_date = p.disposition_date,
    d.disposition = p.disposition,
	d.disposition_reason = p.disposition_reason
  WHERE d.caseid = p.caseid
    AND d.district = p.district
	AND d.id = p.partid
;


SELECT c.*, 
  cs.lead_charge,
  cs.status,
  cs.defendants,
  cs.prison_sentence,
  cs.first_prog_cat_desc,
  cs.first_yr,
  cs.filing_date,
  i.agencies
FROM ((lions.case c LEFT JOIN lions.investigating_agency_grp i
    ON c.id = i.caseid AND c.district = i.district)
  INNER JOIN lions.case_prog_cat_cr_cops p
    ON c.id = p.caseid AND c.district = p.district)
  INNER JOIN lions.case_summary cs
    ON c.id = cs.caseid AND c.district = cs.district
WHERE c.id LIKE '2012%'
LIMIT 1000
;

SELECT typ, COUNT(*)
FROM lions.defendants_cr_cops
WHERE caseid >= '2004%'
GROUP BY typ
;

SELECT disposition,
  COUNT(*)
 FROM lions.defendants_cr_cops
WHERE caseid >= '2004%'
GROUP BY disposition
;

SELECT disposition_reason,
  CASE disposition_reason
	WHEN 'LECI' THEN 'Lack of evidence of criminal intent'
	WHEN 'NFOE' THEN 'No federal offense evident'
	WHEN 'APDM' THEN 'Appeal dismissed'
	WHEN 'WKEV' THEN 'Weak or insufficient evidence'
	WHEN 'WTPR' THEN 'Witness problems'
	WHEN 'SPOC' THEN 'Suspect prosecuted on other charges'
	WHEN 'SPOA' THEN 'Suspect to be prosecuted by other authorities'
	WHEN 'PEPO' THEN 'Petite policy'
	WHEN 'OFPO' THEN 'Office policy (fails to meet prosecution guidelines)'
	WHEN 'MFIN' THEN 'Minimal federal interest'
	WHEN 'LKPR' THEN 'Lack of prosecution resources'
	WHEN 'GWDA' THEN 'Declined per instructions from DOJ'
	WHEN 'DEPO' THEN 'Department policy'
	WHEN 'CADA' THEN 'Civil, administrative or other alternative'
	WHEN 'AGRE' THEN 'Agency request'
	WHEN 'OEOE' THEN 'Opened in error / office error'
	WHEN 'AWCP' THEN 'All work completed'
	WHEN 'JTRD' THEN 'Jury Trial - District Court'
	WHEN 'STLM' THEN 'Statute of limitations'
	WHEN 'NKSU' THEN 'No known suspect'
  END AS reason,
  COUNT(*)
 FROM lions.defendants_cr_cops
WHERE caseid >= '2004%'
  AND disposition IN('ID','DE')
GROUP BY disposition_reason, reason
ORDER BY COUNT(*) DESC
;

SELECT * FROM lions.defendants_cr_cops
;

ALTER TABLE lions.defendants
  ADD disposition_date VARCHAR(25),
  ADD disposition VARCHAR(5),
  ADD disposition_reason VARCHAR(10),
  ADD KEY disposition_idx(disposition),
  ADD KEY disposition_reason_idx(disposition_reason)
;

UPDATE lions.defendants d, lions.participant_court_dispo p
  SET d.disposition_date = p.disposition_date,
    d.disposition = p.disposition,
	d.disposition_reason = p.disposition_reason
  WHERE d.caseid = p.caseid
    AND d.district = p.district
	AND d.id = p.partid
;

ALTER TABLE lions.defendants
  ADD dt_received DATE,
  ADD KEY dt_received_idx(dt_received)
;

UPDATE lions.defendants d, lions.case c
  SET d.dt_received = CONCAT(RIGHT(c.recvd_date, 4), '-', 
      CASE MID(recvd_date, 4, 3)
	    WHEN 'JAN' THEN '01'
		WHEN 'FEB' THEN '02'
		WHEN 'MAR' THEN '03'
		WHEN 'APR' THEN '04'
		WHEN 'MAY' THEN '05'
		WHEN 'JUN' THEN '06'
		WHEN 'JUL' THEN '07'
		WHEN 'AUG' THEN '08'
		WHEN 'SEP' THEN '09'
		WHEN 'OCT' THEN '10'
		WHEN 'NOV' THEN '11'
		WHEN 'DEC' THEN '12'
	  END, '-', LEFT(recvd_date, 2))
	WHERE d.caseid = c.id
	  AND d.district = c.district
;

ALTER TABLE lions.case
  ADD dt_received DATE,
  ADD KEY dt_received_idx(dt_received)
;

ALTER TABLE lions.case_summary
  ADD dt_received DATE,
  ADD KEY dt_received_idx(dt_received)
;

UPDATE lions.case c
  SET c.dt_received = CONCAT(RIGHT(recvd_date, 4), '-', 
      CASE MID(recvd_date, 4, 3)
	    WHEN 'JAN' THEN '01'
		WHEN 'FEB' THEN '02'
		WHEN 'MAR' THEN '03'
		WHEN 'APR' THEN '04'
		WHEN 'MAY' THEN '05'
		WHEN 'JUN' THEN '06'
		WHEN 'JUL' THEN '07'
		WHEN 'AUG' THEN '08'
		WHEN 'SEP' THEN '09'
		WHEN 'OCT' THEN '10'
		WHEN 'NOV' THEN '11'
		WHEN 'DEC' THEN '12'
	  END, '-', LEFT(recvd_date, 2))
;

UPDATE lions.case_summary c
  SET c.dt_received = CONCAT(RIGHT(date_received, 4), '-', 
      CASE MID(date_received, 4, 3)
	    WHEN 'JAN' THEN '01'
		WHEN 'FEB' THEN '02'
		WHEN 'MAR' THEN '03'
		WHEN 'APR' THEN '04'
		WHEN 'MAY' THEN '05'
		WHEN 'JUN' THEN '06'
		WHEN 'JUL' THEN '07'
		WHEN 'AUG' THEN '08'
		WHEN 'SEP' THEN '09'
		WHEN 'OCT' THEN '10'
		WHEN 'NOV' THEN '11'
		WHEN 'DEC' THEN '12'
	  END, '-', LEFT(date_received, 2))
;

DROP TABLE IF EXISTS lions.case_prog_cat_distinct
;

CREATE TABLE lions.case_prog_cat_distinct(
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  caseid VARCHAR(30) NOT NULL,
  district VARCHAR(10) NOT NULL,
  prog_cat VARCHAR(5),
  KEY caseid_idx(caseid),
  KEY district_idx(district),
  KEY prog_cat_idx(prog_cat),
  KEY cd_idx(caseid,district),
  KEY cdp_idx(caseid,district,prog_cat)
) ENGINE=MyISAM, CHARACTER SET=latin1 COLLATE=latin1_general_ci
;

INSERT INTO lions.case_prog_cat_distinct(caseid, district, prog_cat)
  SELECT DISTINCT caseid, district, prog_cat
  FROM lions.case_prog_cat
  WHERE prog_cat <> '*'
;


DROP DATABASE IF EXISTS cr
;
CREATE DATABASE cr
;

/* Create a table uniquely identifying defendants in CR cases */
DROP TABLE IF EXISTS cr.defendants;
CREATE TABLE cr.defendants
  SELECT d.caseid,
    d.district,
	d.id as partid,
	d.home_city,
	d.home_state,
    d.gener as gender,
	d.occupation,
	d.disposition_date,
	d.disposition,
	d.disposition_reason,
    cs.status,
	cs.date_received,
	cs.offense_range,
	cs.defendants,
	cs.filing_date,
	cs.first_yr,
	c.priority,
	c.security,
	c.typ,
	c.lit_resp,
	c.lit_track,
	c.weight,
	c.branch,
	c.status as case_status,
	c.grand_jury_num,
	c.unit,
	c.offense_from,
	c.offense_to,
	c.lead_charge,
	c.civil_poten,
	c.recvd_date,
	c.create_date,
	c.close_date
  FROM ((lions.defendants_cr_cops d LEFT JOIN lions.case_summary cs
      USING(caseid, district))
    LEFT JOIN lions.investigating_agency_grp i
      USING(caseid, district))
	LEFT JOIN lions.case c
	  ON d.caseid = c.id AND d.district = c.district
;

/* Calculate prison sentences for CR defendants */
ALTER TABLE cr.defendants
  ADD prison_months INT DEFAULT NULL,
  ADD sentence_record INT DEFAULT NULL,
  ADD sentence_date VARCHAR(30) DEFAULT NULL,
  ADD incar_type VARCHAR(5) DEFAULT NULL
;

UPDATE cr.defendants d, lions.sentence s
  SET d.prison_months = ( s.incar_days / 30 ) + incar_months + ( incar_years * 12 ),
    d.sentence_record = s.pid,
	d.sentence_date = s.sent_date,
	d.incar_type = s.incar_type
  WHERE d.caseid = s.caseid
    AND d.district = s.district
	AND d.partid = s.partid
;

/* Clean up the dates */
ALTER TABLE cr.defendants
  ADD dt_received DATE,
  ADD dt_disposed DATE,
  ADD dt_closed DATE,
  ADD days_open INT DEFAULT NULL,
  ADD days_to_dispose INT DEFAULT NULL
;

UPDATE cr.defendants
  SET dt_received = CONCAT(RIGHT(recvd_date, 4), '-', 
      CASE MID(recvd_date, 4, 3)
	    WHEN 'JAN' THEN '01'
		WHEN 'FEB' THEN '02'
		WHEN 'MAR' THEN '03'
		WHEN 'APR' THEN '04'
		WHEN 'MAY' THEN '05'
		WHEN 'JUN' THEN '06'
		WHEN 'JUL' THEN '07'
		WHEN 'AUG' THEN '08'
		WHEN 'SEP' THEN '09'
		WHEN 'OCT' THEN '10'
		WHEN 'NOV' THEN '11'
		WHEN 'DEC' THEN '12'
	  END, '-', LEFT(recvd_date, 2)),
    dt_closed = CONCAT(RIGHT(close_date, 4), '-', 
      CASE MID(close_date, 4, 3)
	    WHEN 'JAN' THEN '01'
		WHEN 'FEB' THEN '02'
		WHEN 'MAR' THEN '03'
		WHEN 'APR' THEN '04'
		WHEN 'MAY' THEN '05'
		WHEN 'JUN' THEN '06'
		WHEN 'JUL' THEN '07'
		WHEN 'AUG' THEN '08'
		WHEN 'SEP' THEN '09'
		WHEN 'OCT' THEN '10'
		WHEN 'NOV' THEN '11'
		WHEN 'DEC' THEN '12'
	  END, '-', LEFT(close_date, 2)),
    dt_disposed = CONCAT(RIGHT(disposition_date, 4), '-', 
      CASE MID(disposition_date, 4, 3)
	    WHEN 'JAN' THEN '01'
		WHEN 'FEB' THEN '02'
		WHEN 'MAR' THEN '03'
		WHEN 'APR' THEN '04'
		WHEN 'MAY' THEN '05'
		WHEN 'JUN' THEN '06'
		WHEN 'JUL' THEN '07'
		WHEN 'AUG' THEN '08'
		WHEN 'SEP' THEN '09'
		WHEN 'OCT' THEN '10'
		WHEN 'NOV' THEN '11'
		WHEN 'DEC' THEN '12'
	  END, '-', LEFT(disposition_date, 2))	  
;

UPDATE cr.defendants
  SET days_open = DATEDIFF(dt_closed, dt_received),
    days_to_dispose = DATEDIFF(dt_disposed, dt_received)
;

ALTER TABLE cr.defendants
  ADD charged INT DEFAULT NULL
;

UPDATE cr.defendants d
  SET charged = ( SELECT COUNT(*)
                             FROM lions.case_summary c
							 WHERE c.caseid = d.caseid
							   AND c.district = d.district ) 
;


/* Select the rows you want to work from */
DROP TABLE IF EXISTS cr.defendants_sel;
CREATE TABLE cr.defendants_sel
  LIKE cr.defendants
;

INSERT INTO cr.defendants_sel
  SELECT *
  FROM cr.defendants
  WHERE dt_received >= '2005-01-01'
;

