
# -----------------------------------------------------
# STAFF SUMMARY SECTION
# -----------------------------------------------------

DROP TABLE IF EXISTS lions.staff_summary
;

CREATE TABLE IF NOT EXISTS lions.staff_summary(
  staffid VARCHAR(10),
  district VARCHAR(10),
  last_name VARCHAR(255),
  first_name VARCHAR(255),
  staff_title VARCHAR(10),
  staff_section VARCHAR(10),
  initials VARCHAR(10),
  total_cases INT,
  total_cases_adverse INT,
  total_cases_adverse_cta INT,
  total_cases_adverse_dct INT,
  total_cases_adverse_mt INT,
  total_cases_adverse_nt INT,
  total_cases_adverse_ndct INT,
  tc_cases INT,
  tc_cases_adverse INT,
  tc_cases_adverse_cta INT,
  tc_cases_adverse_dct INT,
  tc_cases_adverse_mt INT,
  tc_cases_adverse_nt INT,
  tc_cases_adverse_ndct INT,
  tc_cases_jtri INT,
  lc_cases INT,
  lc_cases_adverse INT,
  lc_cases_adverse_cta INT,
  lc_cases_adverse_dct INT,
  lc_cases_adverse_mt INT,
  lc_cases_adverse_nt INT,
  lc_cases_adverse_ndct INT,
  lc_cases_jtri INT,  
  KEY staffid_idx(staffid),
  KEY district_idx(district),
  KEY last_name_idx(last_name),
  KEY total_cases_idx(total_cases),
  KEY total_cases_adverse_idx(total_cases_adverse),
  KEY tc_cases_idx(tc_cases),
  KEY tc_cases_adverse_idx(tc_cases_adverse),
  KEY total_cases_adverse_ndct_idx(total_cases_adverse_ndct),
  KEY tc_cases_adverse_ndct_idx(tc_cases_adverse_ndct),
  KEY lc_cases_idx(lc_cases),
  KEY lc_cases_adverse_idx(lc_cases_adverse),
  KEY lc_cases_adverse_ndct_idx(lc_cases_adverse_ndct),
  KEY lc_cases_jtri_idx(lc_cases_jtri),
  KEY tc_cases_jtri_idx(tc_cases_jtri),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

TRUNCATE TABLE lions.staff_summary
;
INSERT INTO lions.staff_summary
    (staffid, district, last_name, first_name, staff_title, initials, staff_section)
  SELECT staffid,
    district,
    last_name,
    first_name,
    staff_title,
    initials,
    staff_section
  FROM lions.staff
  WHERE last_name NOT LIKE '?%'
;

# ADVERSE
UPDATE lions.staff_summary AS ss,
  (  SELECT a.staffid, a.district, 
       SUM(IF(adverse_new_trial > 0, 1, 0)) AS adverse_new_trial,
	   SUM(IF(adverse_mistrial > 0, 1, 0)) AS adverse_mistrial,
	   SUM(IF(adverse > 0, 1, 0)) AS adverse_total,
	   SUM(IF(jtri > 0, 1, 0)) AS jtri,
	   COUNT(*) AS total_cases
     FROM lions.assignment_distinct AS a INNER JOIN lions.case_summary AS cs
	   USING(caseid, district)
	 GROUP BY staffid, district
  ) AS t
  SET ss.total_cases_adverse_nt = t.adverse_new_trial,
    ss.total_cases_adverse_mt = t.adverse_mistrial,
	ss.total_cases = t.total_cases,
	ss.total_cases_adverse = t.adverse_total,
	ss.tc_cases_jtri = t.jtri
  WHERE t.staffid = ss.staffid
    AND t.district = ss.district
;

# ADVERSE
UPDATE lions.staff_summary AS ss,
  (  SELECT a.staffid, a.district, 
       SUM(IF(adverse_new_trial > 0, 1, 0)) AS tc_adverse_new_trial,
	   SUM(IF(adverse_mistrial > 0, 1, 0)) AS tc_adverse_mistrial,
	   SUM(IF(adverse > 0, 1, 0)) AS tc_adverse_total,
	   SUM(IF(jtri > 0, 1, 0)) AS tc_jtri,
	   COUNT(*) AS tc_cases
     FROM lions.assignment_distinct_dc AS a INNER JOIN lions.case_summary AS cs
	   USING(caseid, district)
	 GROUP BY staffid, district
  ) AS t
  SET ss.tc_cases = t.tc_cases,
    ss.tc_cases_adverse = t.tc_adverse_total,
	ss.tc_cases_adverse_nt = t.tc_adverse_new_trial,
	ss.tc_cases_adverse_mt = t.tc_adverse_mistrial
  WHERE t.staffid = ss.staffid
    AND t.district = ss.district
;





# TRIAL COURT ADVERSE NON-DISTRICT COURT (DJ)
UPDATE lions.staff_summary AS ss
  SET tc_cases_adverse_ndct = (
      SELECT COUNT(*)
      FROM lions.assignment_distinct_dc AS a 
          INNER JOIN lions.case_summary AS cs
        ON a.caseid = cs.caseid
          AND a.district = cs.district
      WHERE a.staffid = ss.staffid
        AND a.district = ss.district
        AND cs.district = ss.district
        AND cs.adverse > 0
        AND ( 
            cs.adverse_new_trial > 0
            OR cs.adverse_mistrial > 0 
            OR cs.adverse_cta > 0
          )
    )
;




# LEAD COUNSEL ADVRSE CASES NON-DCT 
UPDATE lions.staff_summary AS ss
  SET lc_cases_adverse_ndct = (
      SELECT COUNT(*)
      FROM lions.assignment_distinct_dc_l AS a 
          INNER JOIN lions.case_summary AS cs
        ON a.caseid = cs.caseid
          AND a.district = cs.district
      WHERE a.staffid = ss.staffid
        AND a.district = ss.district
        AND cs.district = ss.district
        AND cs.adverse > 0
        AND ( 
            cs.adverse_new_trial > 0
            OR cs.adverse_mistrial > 0 
            OR cs.adverse_cta > 0
          )
    )
;

# LEAD COUNSEL ADVERSE TRIAL COURT CASES
UPDATE lions.staff_summary AS ss
  SET lc_cases_adverse = (
      SELECT COUNT(*)
      FROM lions.assignment_distinct_dc_l AS a 
          INNER JOIN lions.case_summary AS cs
        ON a.caseid = cs.caseid
          AND a.district = cs.district
      WHERE a.staffid = ss.staffid
        AND a.district = ss.district
        AND cs.district = ss.district
        AND cs.adverse > 0
    )
;

# LEAD COUNSEL ADVERSE TRIAL COURT CASES (NEW TRIAL)
UPDATE lions.staff_summary AS ss
  SET lc_cases_adverse_nt = (
      SELECT COUNT(*)
      FROM lions.assignment_distinct_dc_l AS a 
          INNER JOIN lions.case_summary AS cs
        ON a.caseid = cs.caseid
          AND a.district = cs.district
      WHERE a.staffid = ss.staffid
        AND a.district = ss.district
        AND cs.district = ss.district
        AND cs.adverse > 0
        AND cs.adverse_new_trial > 0
    )
;

# TRIAL COURT ADVERSE MISTRIAL
UPDATE lions.staff_summary AS ss
  SET lc_cases_adverse_mt = (
      SELECT COUNT(*)
      FROM lions.assignment_distinct_dc_l AS a 
          INNER JOIN lions.case_summary AS cs
        ON a.caseid = cs.caseid
          AND a.district = cs.district
      WHERE a.staffid = ss.staffid
        AND a.district = ss.district
        AND cs.district = ss.district
        AND cs.adverse > 0
        AND cs.adverse_mistrial > 0
    )
;

# TOTAL TRIAL COURT CASES
UPDATE lions.staff_summary AS ss
  SET lc_cases = (
      SELECT COUNT(*)
      FROM lions.assignment_distinct_dc_l AS a 
          INNER JOIN lions.case_summary AS cs
        ON a.caseid = cs.caseid
          AND a.district = cs.district
      WHERE a.staffid = ss.staffid
        AND a.district = ss.district
        AND cs.district = ss.district
    )
;

# TOTAL LEAD COUNSEL CASES WITH JURY TRIAL
UPDATE lions.staff_summary AS ss
  SET lc_cases_jtri = (
      SELECT COUNT(*)
      FROM lions.assignment_distinct_dc_l AS a 
          INNER JOIN lions.case_summary AS cs
        ON a.caseid = cs.caseid
          AND a.district = cs.district
      WHERE a.staffid = ss.staffid
        AND a.district = ss.district
        AND cs.district = ss.district
        AND cs.jtri > 0
    )
;

