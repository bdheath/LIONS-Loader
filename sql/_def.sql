DROP TABLE IF EXISTS lions.def
;


CREATE TABLE lions.def(
  caseid VARCHAR(50),
  district VARCHAR(10),
  partid VARCHAR(50),
  charged INT DEFAULT NULL,
  charged_dc INT DEFAULT NULL,
  charged_dc_dt DATE DEFAULT NULL,
  case_lead_charge VARCHAR(50),
  case_lead_agency VARCHAR(50),
  case_status VARCHAR(5),
  counts INT,
  dt_received DATE DEFAULT NULL,
  modified TIMESTAMP,
  typ VARCHAR(5),
  role VARCHAR(5),
  KEY caseid_idx(caseid),
  KEY caseid_district_idx(caseid,district),
  PRIMARY KEY(caseid,district,partid),
  KEY charged_dc_idx(charged_dc),
  KEY case_lead_charge_idx(case_lead_charge)
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

ALTER TABLE lions.def
  ADD charged_dc_pid INT,
  ADD charged_pid INT,
  ADD KEY case_lead_agency_idx(case_lead_agency)
;

ALTER TABLE lions.def
  ADD charged_dt DATE
;

ALTER TABLE lions.def
  ADD charges_21usc INT
;

ALTER TABLE lions.def
  ADD charges_21usc841 INT
;

ALTER TABLE lions.def
  ADD charges_8usc1325 INT,
  ADD charges_8usc1326 INT,
  ADD charges_8usc1324 INT,
  ADD charges_18usc1591 INT,
  ADD charges_mannact INT
;

ALTER TABLE lions.def
  ADD charges_21usc952 INT,
  ADD charges_21usc846 INT
;

ALTER TABLE lions.def
  ADD ausas VARCHAR(255)
;

INSERT INTO lions.def
  (caseid, district, partid, case_lead_charge, dt_received,
    case_status, typ, role)
  SELECT p.caseid, p.district, p.id,
    c.lead_charge,
	STR_TO_DATE(c.recvd_date, '%d-%b-%Y'),
	c.status,
	p.typ,
	p.role
  FROM lions.participant p INNER JOIN lions.case c
    ON p.caseid = c.id 
	AND p.district = c.district
	AND p.typ IN('I','B')
	AND ( p.role IN('D','DG','DJ','DO','DP','D*') OR p.role LIKE 'D%')
  WHERE c.class = 'R'
    AND c.us_role = 'P'
	AND c.id >= '1995'
	AND p.caseid >= '1995'
;

UPDATE lions.def d, 
  ( SELECT p.id, p.agency, p.caseid, p.district, 
      a.lead_agent
	FROM lions.participant p LEFT JOIN lions.gs_agent a
	  ON p.caseid = a.caseid
	  AND p.district = a.district
	  AND p.id = a.partid
	WHERE p.caseid >= '1995'
	  AND a.caseid >= '1995'
	  AND p.typ = 'A'
	  AND p.role = 'IN'
	  AND a.lead_agent = 'Y'
  ) AS t
  SET d.case_lead_agency = t.agency
  WHERE d.caseid = t.caseid
    AND d.district = t.district
	AND d.case_lead_agency IS NULL
;


ALTER TABLE lions.court_history
  ADD KEY id_caseid_district_idx(id,caseid,district),
  ADD KEY id_caseid_district_court_idx(id,caseid,district,court),
  ADD KEY id_caseid_district_disposition_idx(id,caseid,district,disposition)
;

ALTER TABLE lions.participant_court
  ADD KEY id_caseid_district_idx(crthsid,caseid,district),
  ADD KEY id_caseid_district_disposition_idx(crthsid,caseid,district,disposition)
;

-- Build a temporary table holding charging and declination information
DROP TABLE IF EXISTS lions.pcch
;

CREATE TABLE lions.pcch
  SELECT pc.caseid,
    pc.district,
	pc.partid,
	pc.crthsid,
	pc.disposition,
	ch.court,
	pc.disposition_reason,
	MIN(STR_TO_DATE(pc.disposition_date, '%d-%b-%Y')) AS dt
  FROM lions.participant_court pc LEFT JOIN lions.court_history ch
    ON pc.crthsid = ch.id AND pc.caseid = ch.caseid AND pc.district = ch.district
  WHERE pc.caseid >= '1995'
    AND pc.disposition IN('ID','DE','NW')
	AND pc.disposition_date <> ''
  GROUP BY caseid, district, partid, crthsid, disposition, court, disposition_reason
;
  


ALTER TABLE lions.pcch 
  ADD KEY caseid_district_partid_idx(caseid,district,partid),
  ADD KEY caseid_district_idx(caseid,district),
  ADD KEY caseid_district_partid_court_idx(caseid,partid,district,court),
  ADD KEY caseid_district_partid_disposition_idx(caseid,partid,district,disposition),
  ADD KEY disposition_reason_idx(disposition_reason)
;


-- Now figure out when the case was charged in district court and at all
-- District court charges

UPDATE lions.def d, ( 
    SELECT MIN(dt) AS dt,
	  caseid,
	  district,
	  partid
	FROM lions.pcch
	WHERE disposition = 'NW'
	  AND disposition_reason IN('SIND','INDT','INFO')
	GROUP BY caseid, district, partid
  ) AS p
  SET d.charged_dc_dt = p.dt
  WHERE d.caseid = p.caseid
    AND d.partid = p.partid
	AND d.district = p.district
;

-- First charge date in any court
UPDATE lions.def d, ( 
    SELECT MIN(dt) AS dt,
	  caseid,
	  district,
	  partid
	FROM lions.pcch
	WHERE disposition = 'NW'
	  AND disposition_reason IN('SIND','INDT','INFO','CMPL','COMP')
	GROUP BY caseid, district, partid
  ) AS p
  SET d.charged_dt = p.dt
  WHERE d.caseid = p.caseid
    AND d.partid = p.partid
	AND d.district = p.district
;

-- Now fix inconsistencies 
UPDATE lions.def d 
  SET charged_dt = charged_dc_dt
  WHERE charged_dt IS NULL
    AND charged_dc_dt >= '1995-01-01'
;


-- AUSA Summary
SET group_concat_max_len = 25000;

UPDATE lions.def d, (
    SELECT a.caseid, a.district, 
	  LEFT(GROUP_CONCAT(TRIM(CONCAT(TRIM(s.initials), ' (',TRIM(s.first_name), ' ', TRIM(s.last_name),')'))),255) AS ausas
    FROM lions.assignment AS a INNER JOIN lions.staff AS s USING(staffid,district)
    GROUP BY caseid, district	
  ) AS t	
  SET d.ausas = t.ausas
  WHERE t.caseid = d.caseid
    AND t.district = d.district
    AND d.caseid >= '1996'
    AND ( d.ausas IS NULL OR d.ausas = '' )
;
 
-- Case declination coding
ALTER TABLE lions.def
  ADD declination VARCHAR(10),
  ADD declination_pid INT,
  ADD declination_reason VARCHAR(10),
  ADD declination_dt DATE
;

-- Now get the declination info
UPDATE lions.def d, ( 
    SELECT MIN(dt) AS dt,
	  caseid,
	  district,
	  partid
	FROM lions.pcch
	WHERE disposition IN('ID','DE')
	GROUP BY caseid, district, partid
  ) AS p
  SET d.declination_dt = p.dt
  WHERE d.caseid = p.caseid
    AND d.partid = p.partid
	AND d.district = p.district
;

UPDATE lions.def d, ( 
    SELECT disposition,
	  disposition_reason,
	  caseid,
	  district,
	  partid,
	  dt
	FROM lions.pcch
	WHERE disposition IN('ID','DE')
  ) AS p
  SET d.declination = p.disposition,
    d.declination_reason = p.disposition_reason
  WHERE p.dt = d.declination_dt
    AND d.caseid = p.caseid
    AND d.partid = p.partid
	AND d.district = p.district
;	
	
ALTER TABLE lions.def
  ADD first_prog_cat VARCHAR(10),
  ADD first_prog_cat_desc VARCHAR(255)
;


UPDATE lions.def
  SET first_prog_cat = (
      SELECT prog_cat
      FROM lions.case_prog_cat AS c
      WHERE def.caseid = c.caseid
        AND def.district = c.district
      LIMIT 1
    )
;

UPDATE lions.def d
  SET first_prog_cat_desc = CASE d.first_prog_cat
      WHEN '011' THEN 'Federal Corruption - Procurement'
      WHEN '012' THEN 'Federal Corruption - Program'
      WHEN '013' THEN 'Federal Corruption - Law Enforcement'
      WHEN '014' THEN 'Federal Corruption - Other'
      WHEN '015' THEN 'State Corruption'
      WHEN '016' THEN 'Local Corruption'
      WHEN '017' THEN 'Other Public Corruption'
	  WHEN '020' THEN 'Organized Crime'
      WHEN '021' THEN 'Organized Crime - Emerging Organizations'
	  WHEN '023' THEN 'Organized Crime - Top International Organizations'
	  WHEN '024' THEN 'Transnational Organized Crime'
      WHEN '031' THEN 'Federal Procurement Fraud'
      WHEN '032' THEN 'Federal Program Fraud'
	  WHEN '03Z' THEN 'Other Fraud'
      WHEN '033' THEN 'Tax Fraud'
      WHEN '036' THEN 'Financial Institution Fraud'
      WHEN '037' THEN 'Bankruptcy Fraud'
	  WHEN '038' THEN 'Advance Fee Schemes'
      WHEN '03A' THEN 'Consumer Fraud'
      WHEN '03B' THEN 'Securities Fraud'
      WHEN '03C' THEN 'Commodities Fraud'
      WHEN '03D' THEN 'Other Investment Fraud'
      WHEN '03F' THEN 'Comuter Crime'
      WHEN '03G' THEN 'Health Care Fraud'
      WHEN '03H' THEN 'Fraud Against Insurance Providers'
      WHEN '03I' THEN 'Intellectual Property Violations'
      WHEN '03J' THEN 'Insider Fraud Against Insurance Providers'
      WHEN '03L' THEN 'Mortgage Fraud'
      WHEN '03T' THEN 'Corporate Fraud'
      WHEN '03S' THEN 'Telemarketing Fraud'
      WHEN '03U' THEN 'Identity Theft'
      WHEN '03V' THEN 'Aggravated Identity Theft'
      WHEN '040' THEN 'Drug Trafficking'
      WHEN '045' THEN 'Drug Possession'
      WHEN '047' THEN 'OCDETF'
      WHEN '05D' THEN 'Civil Rights - Law Enforcement'
	  WHEN '05E' THEN 'Civil Rights - Slavery'
	  WHEN '05F' THEN 'Civil Rights - Racial Violence, Including Hate Crimes'
	  WHEN '05G' THEN 'Civil Rights - Access To Clinics'
      WHEN '05H' THEN 'Civil Rights - Hate Crimes Arising out of Terrorist Attacks on U.S.'
	  WHEN '050' THEN 'Civil Rights - Other'
      WHEN '055' THEN 'Violations and the Immigration and Nationality Act'
      WHEN '061' THEN 'Counterfeiting and Forgery'
      WHEN '063' THEN 'Customs Violation - Currency'
	  WHEN '064' THEN 'Energy Pricing and Related Fraud'
      WHEN '066' THEN 'Health and Safety Violations - Employers'
      WHEN '06A' THEN 'Trafficking in Contraband Cigarettes'
      WHEN '06B' THEN 'Wildlife Protection'
      WHEN '06C' THEN 'Marine Resources'
      WHEN '06D' THEN 'Energy Violations'
      WHEN '06E' THEN 'Environmental Crime'
      WHEN '06H' THEN 'Export Enforcement / General'
      WHEN '065' THEN 'Indian Offenses - Non-Violent'
      WHEN '070' THEN 'Internal Security'
      WHEN '071' THEN 'International Terrorism Incidents, Impacting U.S.'
      WHEN '072' THEN 'Domestic Terrorism'
      WHEN '073' THEN 'Terrorism Related Hoaxes'
      WHEN '076' THEN 'Terrorist Financing'
      WHEN '077' THEN 'Export Enforcement - Terrorism Related'
      WHEN '074' THEN 'Offenses Against the Administration of Justice'
      WHEN '081' THEN 'Fugitive Crimes'
      WHEN '082' THEN 'Postal Service Crimes'
      WHEN '085' THEN 'Election Fraud'
      WHEN '086' THEN 'Theft of Government Property'
      WHEN '080' THEN 'Project Safe Childjood'
      WHEN '087' THEN 'Child Pornography'
      WHEN '089' THEN 'Obscenity'
      WHEN '053' THEN 'Firearms / Triggerlock'
      WHEN '083' THEN 'Bank Robbery'
      WHEN '092' THEN 'Indian Country - Violent Crime'
      WHEN '06Z' THEN 'Other Government Regulatory Offenses'
      WHEN '03Z' THEN 'Other White Collar Crime / Fraud'
      WHEN '06G' THEN 'Money Laundering Structuring / Other'
      WHEN '056' THEN 'Crimes Against Government Property'
      WHEN '088' THEN 'Embezzlement and Theft of Items From United States'
      WHEN '084' THEN 'Violations of State Laws Adopted by US'
      WHEN '075' THEN 'Theft of Property in Interstate Transportation'
      WHEN '039' THEN 'Other Fraud Agaisnt Businesses'
      WHEN '090' THEN 'Other Criminal Prosecutions'
      WHEN '06F' THEN 'Money Laundering Structuring / Narcotics'      
      WHEN '091' THEN 'Domestic Violence'
	  WHEN '093' THEN 'All Other Violent Crimes'
      ELSE NULL 
    END 
;




DROP TABLE IF EXISTS lions.big_crosstab_def;
CREATE TABLE lions.big_crosstab_def
  SELECT p.prog_cat,
    CASE p.prog_cat
      WHEN '011' THEN 'Federal Corruption - Procurement'
      WHEN '012' THEN 'Federal Corruption - Program'
      WHEN '013' THEN 'Federal Corruption - Law Enforcement'
      WHEN '014' THEN 'Federal Corruption - Other'
      WHEN '015' THEN 'State Corruption'
      WHEN '016' THEN 'Local Corruption'
      WHEN '017' THEN 'Other Public Corruption'
	  WHEN '020' THEN 'Organized Crime'
      WHEN '021' THEN 'Organized Crime - Emerging Organizations'
	  WHEN '023' THEN 'Organized Crime - Top International Organizations'
	  WHEN '024' THEN 'Transnational Organized Crime'
      WHEN '031' THEN 'Federal Procurement Fraud'
      WHEN '032' THEN 'Federal Program Fraud'
	  WHEN '03Z' THEN 'Other Fraud'
      WHEN '033' THEN 'Tax Fraud'
      WHEN '036' THEN 'Financial Institution Fraud'
      WHEN '037' THEN 'Bankruptcy Fraud'
	  WHEN '038' THEN 'Advance Fee Schemes'
      WHEN '03A' THEN 'Consumer Fraud'
      WHEN '03B' THEN 'Securities Fraud'
      WHEN '03C' THEN 'Commodities Fraud'
      WHEN '03D' THEN 'Other Investment Fraud'
      WHEN '03F' THEN 'Comuter Crime'
      WHEN '03G' THEN 'Health Care Fraud'
      WHEN '03H' THEN 'Fraud Against Insurance Providers'
      WHEN '03I' THEN 'Intellectual Property Violations'
      WHEN '03J' THEN 'Insider Fraud Against Insurance Providers'
      WHEN '03L' THEN 'Mortgage Fraud'
      WHEN '03T' THEN 'Corporate Fraud'
      WHEN '03S' THEN 'Telemarketing Fraud'
      WHEN '03U' THEN 'Identity Theft'
      WHEN '03V' THEN 'Aggravated Identity Theft'
      WHEN '040' THEN 'Drug Trafficking'
      WHEN '045' THEN 'Drug Possession'
      WHEN '047' THEN 'OCDETF'
      WHEN '05D' THEN 'Civil Rights - Law Enforcement'
	  WHEN '05E' THEN 'Civil Rights - Slavery'
	  WHEN '05F' THEN 'Civil Rights - Racial Violence, Including Hate Crimes'
	  WHEN '05G' THEN 'Civil Rights - Access To Clinics'
      WHEN '05H' THEN 'Civil Rights - Hate Crimes Arising out of Terrorist Attacks on U.S.'
	  WHEN '050' THEN 'Civil Rights - Other'
      WHEN '055' THEN 'Violations and the Immigration and Nationality Act'
      WHEN '061' THEN 'Counterfeiting and Forgery'
      WHEN '063' THEN 'Customs Violation - Currency'
	  WHEN '064' THEN 'Energy Pricing and Related Fraud'
      WHEN '066' THEN 'Health and Safety Violations - Employers'
      WHEN '06A' THEN 'Trafficking in Contraband Cigarettes'
      WHEN '06B' THEN 'Wildlife Protection'
      WHEN '06C' THEN 'Marine Resources'
      WHEN '06D' THEN 'Energy Violations'
      WHEN '06E' THEN 'Environmental Crime'
      WHEN '06H' THEN 'Export Enforcement / General'
      WHEN '065' THEN 'Indian Offenses - Non-Violent'
      WHEN '070' THEN 'Internal Security'
      WHEN '071' THEN 'International Terrorism Incidents, Impacting U.S.'
      WHEN '072' THEN 'Domestic Terrorism'
      WHEN '073' THEN 'Terrorism Related Hoaxes'
      WHEN '076' THEN 'Terrorist Financing'
      WHEN '077' THEN 'Export Enforcement - Terrorism Related'
      WHEN '074' THEN 'Offenses Against the Administration of Justice'
      WHEN '081' THEN 'Fugitive Crimes'
      WHEN '082' THEN 'Postal Service Crimes'
      WHEN '085' THEN 'Election Fraud'
      WHEN '086' THEN 'Theft of Government Property'
      WHEN '080' THEN 'Project Safe Childjood'
      WHEN '087' THEN 'Child Pornography'
      WHEN '089' THEN 'Obscenity'
      WHEN '053' THEN 'Firearms / Triggerlock'
      WHEN '083' THEN 'Bank Robbery'
      WHEN '092' THEN 'Indian Country - Violent Crime'
      WHEN '06Z' THEN 'Other Government Regulatory Offenses'
      WHEN '03Z' THEN 'Other White Collar Crime / Fraud'
      WHEN '06G' THEN 'Money Laundering Structuring / Other'
      WHEN '056' THEN 'Crimes Against Government Property'
      WHEN '088' THEN 'Embezzlement and Theft of Items From United States'
      WHEN '084' THEN 'Violations of State Laws Adopted by US'
      WHEN '075' THEN 'Theft of Property in Interstate Transportation'
      WHEN '039' THEN 'Other Fraud Agaisnt Businesses'
      WHEN '090' THEN 'Other Criminal Prosecutions'
      WHEN '06F' THEN 'Money Laundering Structuring / Narcotics'      
      WHEN '091' THEN 'Domestic Violence'
	  WHEN '093' THEN 'All Other Violent Crimes'
      ELSE NULL 
    END AS description,
  SUM(IF(YEAR(d.charged_dt) = '1996', 1, 0)) AS c1996,     
  SUM(IF(YEAR(d.charged_dt) = '1997', 1, 0)) AS c1997,
  SUM(IF(YEAR(d.charged_dt) = '1996', 1, 0)) AS c1998,
  SUM(IF(YEAR(d.charged_dt) = '1999', 1, 0)) AS c1999,
  SUM(IF(YEAR(d.charged_dt) = '2000', 1, 0)) AS c2000,
  SUM(IF(YEAR(d.charged_dt) = '2001', 1, 0)) AS c2001,
  SUM(IF(YEAR(d.charged_dt) = '2002', 1, 0)) AS c2002,
  SUM(IF(YEAR(d.charged_dt) = '2003', 1, 0)) AS c2003,
  SUM(IF(YEAR(d.charged_dt) = '2004', 1, 0)) AS c2004,
  SUM(IF(YEAR(d.charged_dt) = '2005', 1, 0)) AS c2005,
  SUM(IF(YEAR(d.charged_dt) = '2006', 1, 0)) AS c2006,
  SUM(IF(YEAR(d.charged_dt) = '2007', 1, 0)) AS c2007,
  SUM(IF(YEAR(d.charged_dt) = '2008', 1, 0)) AS c2008,
  SUM(IF(YEAR(d.charged_dt) = '2009', 1, 0)) AS c2009,
  SUM(IF(YEAR(d.charged_dt) = '2010', 1, 0)) AS c2010,
  SUM(IF(YEAR(d.charged_dt) = '2011', 1, 0)) as c2011,
  SUM(IF(YEAR(d.charged_dt) = '2012', 1, 0)) AS c2012,
  SUM(IF(YEAR(d.charged_dt) = '2013', 1, 0)) AS c2013,
  SUM(IF(YEAR(d.charged_dt) = '2014', 1, 0)) AS c2014,
  SUM(IF(YEAR(d.charged_dt) = '2015', 1, 0)) AS c2015,
  SUM(IF(YEAR(d.charged_dt) = '2016', 1, 0)) AS c2016,
  SUM(IF(YEAR(d.charged_dt) = '2017', 1, 0)) AS c2017,
  SUM(IF(YEAR(d.charged_dt) = '2018', 1, 0)) AS c2018,
  SUM(IF(YEAR(d.charged_dt) = '2019', 1, 0)) AS c2019,

  COUNT(*) AS total_cases
  FROM lions.def AS d INNER JOIN lions.case_prog_cat AS p
    USING(caseid, district)
  WHERE d.charged_dt >= '1996-01-01'
  GROUP BY p.prog_cat,
    description
;

--- Specific charging provisions

UPDATE lions.def d
  SET d.charges_21usc = ( 
    SELECT COUNT(*) AS c
	FROM lions.participant_count p
	WHERE p.caseid = d.caseid
	  AND p.district = d.district
	  AND p.partid = d.partid
	  AND p.charge LIKE '21%'
  )
  WHERE charges_21usc IS NULL
;

UPDATE lions.def d
  SET d.charges_21usc841 = ( 
    SELECT COUNT(*) AS c
	FROM lions.participant_count p
	WHERE p.caseid = d.caseid
	  AND p.district = d.district
	  AND p.partid = d.partid
	  AND (p.charge LIKE '21 :00841%'
	    OR p.charge LIKE '21%841%')
  )
  WHERE charges_21usc841 IS NULL
;

UPDATE lions.def d
  SET d.charges_8usc1325 = ( 
    SELECT COUNT(*) AS c
	FROM lions.participant_count p
	WHERE p.caseid = d.caseid
	  AND p.district = d.district
	  AND p.partid = d.partid
	  AND (p.charge LIKE '08 :01325%')

  )
  WHERE charges_8usc1325 IS NULL
;
 
UPDATE lions.def d
  SET d.charges_8usc1326 = ( 
    SELECT COUNT(*) AS c
	FROM lions.participant_count p
	WHERE p.caseid = d.caseid
	  AND p.district = d.district
	  AND p.partid = d.partid
	  AND (p.charge LIKE '08 :01326%')

  )
  WHERE charges_8usc1326 IS NULL
;

UPDATE lions.def d
  SET d.charges_8usc1324 = ( 
    SELECT COUNT(*) AS c
	FROM lions.participant_count p
	WHERE p.caseid = d.caseid
	  AND p.district = d.district
	  AND p.partid = d.partid
	  AND (p.charge LIKE '08 :01324%')

  )
  WHERE charges_8usc1324 IS NULL
;

UPDATE lions.def d
  SET d.charges_21usc952 = ( 
    SELECT COUNT(*) AS c
	FROM lions.participant_count p
	WHERE p.caseid = d.caseid
	  AND p.district = d.district
	  AND p.partid = d.partid
	  AND (p.charge LIKE '21 :00952%')
  )
  WHERE charges_21usc952 IS NULL
;


UPDATE lions.def d
  SET d.charges_21usc846 = ( 
    SELECT COUNT(*) AS c
	FROM lions.participant_count p
	WHERE p.caseid = d.caseid
	  AND p.district = d.district
	  AND p.partid = d.partid
	  AND (p.charge LIKE '21 :00846%')
  )
  WHERE charges_21usc846 IS NULL
;

UPDATE lions.def d
  SET d.charges_18usc1591 = ( 
    SELECT COUNT(*) AS c
	FROM lions.participant_count p
	WHERE p.caseid = d.caseid
	  AND p.district = d.district
	  AND p.partid = d.partid
	  AND (p.charge LIKE '18 :01591%')
  )
  WHERE charges_18usc1591 IS NULL
;


UPDATE lions.def d
  SET d.charges_mannact = ( 
    SELECT COUNT(*) AS c
	FROM lions.participant_count p
	WHERE p.caseid = d.caseid
	  AND p.district = d.district
	  AND p.partid = d.partid
	  AND (p.charge LIKE '18 :0242%')
  )
  WHERE charges_mannact IS NULL
;
