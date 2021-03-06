DROP DATABASE IF EXISTS lions;

# PHASE ONE
CREATE DATABASE IF NOT EXISTS lions;
USE lions;

CREATE TABLE lions.case(
  district VARCHAR(3),
  id VARCHAR(10),
  class VARCHAR(1),
  name VARCHAR(50),
  recvd_date VARCHAR(11),
  security VARCHAR(1),
  priority VARCHAR(1),
  typ VARCHAR(4),
  us_role VARCHAR(2),
  lit_resp VARCHAR(2),
  lit_track VARCHAR(1),
  weight VARCHAR(2),
  branch VARCHAR(3),
  grand_jury_num VARCHAR(15),
  unit VARCHAR(4),
  cdmns_num VARCHAR(11),
  tribe VARCHAR(4),
  reservation VARCHAR(4),
  spec_proj VARCHAR(2),
  vic_wit VARCHAR(1),
  adr_mode VARCHAR(2),
  collect_ind VARCHAR(1),
  offense_from VARCHAR(11),
  offense_to VARCHAR(11),
  lead_charge VARCHAR(25),
  physical_loc VARCHAR(20),
  stor_num VARCHAR(20),
  civil_poten VARCHAR(1),
  sys_init_date VARCHAR(11),
  access_date VARCHAR(11),
  status VARCHAR(1),
  close_date VARCHAR(11),
  dest_date VARCHAR(11),
  premanent VARCHAR(1),
  case_restricted VARCHAR(1),
  criminal_poten VARCHAR(1),
  tot_victims VARCHAR(11),
  related_flu_flag VARCHAR(1),
  qui_tam VARCHAR(1),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  KEY district_idx(district),
  KEY id_idx(id),
  KEY cd_idx(id,district)
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

CREATE TABLE lions.dna(
  district VARCHAR(3),
  id VARCHAR(10),
  caseid VARCHAR(10),
  proceeding_aft_relief_granted VARCHAR(1),
  new_trial_ord VARCHAR(1),
  charge_dismissed VARCHAR(1),
  guilty_plea_entered VARCHAR(1),
  found_guilty VARCHAR(1),
  acquitted VARCHAR(1),
  resentenced_cap_case VARCHAR(1),
  testing_ordered VARCHAR(1),
  relief_granted VARCHAR(1),
  comments VARCHAR(1),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  KEY district_idx(district),
  KEY id_idx(id),
  KEY caseid_idx(caseid)
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

CREATE TABLE lions.dom_terror(
  district VARCHAR(10),
  id VARCHAR(10),
  caseid VARCHAR(10),
  dom_terr_ind VARCHAR(2),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  KEY district_idx(district),
  KEY id_idx(id),
  KEY caseid_idx(caseid)
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

CREATE TABLE lions.case_prog_cat(
  district VARCHAR(10),
  caseid VARCHAR(10),
  prog_cat VARCHAR(3),
  id VARCHAR(10),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  KEY district_idx(district),
  KEY id_idx(id),
  KEY caseid_idx(caseid),
  KEY prog_cat_idx(prog_cat)
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;
  
TRUNCATE TABLE lions.case;

LOAD DATA LOCAL INFILE '/lions/gs_case.txt' 
  INTO TABLE lions.case
  FIELDS TERMINATED BY ''
;

LOAD DATA LOCAL INFILE '/lions/gs_dna.txt'
  INTO TABLE lions.dna
  FIELDS TERMINATED BY ''
;

LOAD DATA LOCAL INFILE '/lions/gs_case_prog_cat.txt'
  INTO TABLE lions.case_prog_cat
  FIELDS TERMINATED BY ''
;

LOAD DATA LOCAL INFILE '/lions/gs_case_dom_terr_ind.txt'
  INTO TABLE lions.dom_terror
  FIELDS TERMINATED BY ''
;

DROP TABLE IF EXISTS lions.participant;

CREATE TABLE lions.participant(
  district VARCHAR(10),
  caseid VARCHAR(10),
  id VARCHAR(10),
  typ VARCHAR(1),
  role VARCHAR(2),
  security VARCHAR(1),
  defend_num VARCHAR(11),
  salutation VARCHAR(20),
  last_name VARCHAR(60),
  first_name VARCHAR(30),
  title VARCHAR(30),
  last_sounds VARCHAR(4),
  first_sounds VARCHAR(4),
  business_type VARCHAR(2),
  ein VARCHAR(20),
  prop_type VARCHAR(2),
  total_tracts VARCHAR(11),
  cats_asset_id VARCHAR(15),
  agency VARCHAR(4),
  agency_num VARCHAR(30),
  job_position VARCHAR(4),
  ssn VARCHAR(11),
  birth_date VARCHAR(11),
  gener VARCHAR(1),
  juvenile VARCHAR(1),
  race VARCHAR(2),
  race_description VARCHAR(30),
  immig_stat VARCHAR(2),
  country VARCHAR(2),
  tribe VARCHAR(4),
  reservation VARCHAR(4),
  arrest_date VARCHAR(11),
  poid VARCHAR(12),
  fbi_number VARCHAR(15),
  crim_hist VARCHAR(1),
  est_loss DOUBLE(14,2),
  act_loss DOUBLE(14,2),
  home_address VARCHAR(90),
  home_city VARCHAR(20),
  home_state VARCHAR(2),
  home_county VARCHAR(20),
  home_zip VARCHAR(10),
  home_phone VARCHAR(15),
  home_fax VARCHAR(15),
  off_address VARCHAR(90),
  off_city VARCHAR(20),
  off_state VARCHAR(2),
  off_county VARCHAR(20),
  off_zip VARCHAR(10),
  off_phone VARCHAR(15),
  off_fax VARCHAR(15),
  marshals_num VARCHAR(9),
  agcyoffid VARCHAR(10),
  lower_crt_trial_nbr VARCHAR(25),
  business_contact_name VARCHAR(60),
  collect_ind VARCHAR(1),
  sys_init_date VARCHAR(11),
  weight VARCHAR(2),
  employer_name VARCHAR(40),
  employer_type VARCHAR(3),
  employer_desc VARCHAR(40),
  npi VARCHAR(10),
  occupation VARCHAR(3),
  occup_desc VARCHAR(60),
  hcare_busn_type VARCHAR(3),
  hcare_busn_desc VARCHAR(40),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  KEY district_idx(district),
  KEY id_idx(id),
  KEY caseid_idx(caseid),
  KEY cdp_idx(caseid,district,id),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;


CREATE TABLE participant_count(
  district VARCHAR(10),
  caseid VARCHAR(10),
  partid VARCHAR(10),
  crthsid VARCHAR(10),
  instid VARCHAR(10),
  charge VARCHAR(25),
  category VARCHAR(1),
  countid VARCHAR(10),
  disposition VARCHAR(2),
  disp_reason VARCHAR(4),
  disp_date VARCHAR(11),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  KEY district_idx(district),
  KEY caseid_idx(caseid),
  KEY partid_idx(partid),
  KEY disposition_idx(disposition),
  KEY category_idx(category),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

LOAD DATA LOCAL INFILE '/lions/gs_part_count.txt'
  INTO TABLE lions.participant_count
  FIELDS TERMINATED BY ''
;


CREATE TABLE IF NOT EXISTS lions.archive_case(
  district VARCHAR(10),
  id VARCHAR(10),
  class VARCHAR(1),
  name VARCHAR(50),
  recvd_date VARCHAR(11),
  us_role VARCHAR(2),
  lead_charge VARCHAR(25),
  prog_cat VARCHAR(3),
  cause_act VARCHAR(4),
  branch VARCHAR(3),
  comments VARCHAR(60),
  court VARCHAR(2),
  location VARCHAR(2),
  court_number VARCHAR(25),
  filing_date VARCHAR(11),
  service_date VARCHAR(11),
  disposition VARCHAR(2),
  disposition_reason VARCHAR(4),
  disposition_date VARCHAR(11),
  inst_type VARCHAR(2),
  inst_file_date VARCHAR(11),
  ausa_last VARCHAR(30),
  ausa_first VARCHAR(30),
  agency VARCHAR(4),
  appeals_filed VARCHAR(11),
  store_num VARCHAR(20),
  dest_date VARCHAR(11),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  KEY district_idx(district),
  KEY id_idx(id)
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

DROP TABLE IF EXISTS lions.event;

CREATE TABLE lions.event(
  district VARCHAR(10),
  caseid VARCHAR(10),
  crthsid VARCHAR(10),
  id VARCHAR(10),
  typ VARCHAR(4),
  action VARCHAR(2),
  event_date VARCHAR(11),
  sched_date VARCHAR(11),
  sched_time VARCHAR(11),
  sched_loc VARCHAR(200),
  staffid VARCHAR(10),
  judgeid VARCHAR(10),
  document_code VARCHAR(3),
  document_staffid VARCHAR(10),
  document_date VARCHAR(11),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  KEY district_idx(district),
  KEY id_idx(id),
  KEY caseid_idx(caseid),
  KEY action_idx(action),
  KEY typ_idx(typ),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

DROP TABLE IF EXISTS lions.court_history;

CREATE TABLE lions.court_history(
  district VARCHAR(10),
  caseid VARCHAR(10),
  id VARCHAR(10),
  court VARCHAR(2),
  location VARCHAR(2),
  us_role VARCHAR(2),
  court_number VARCHAR(25),
  filing_date VARCHAR(11),
  service_date VARCHAR(11),
  trial_days VARCHAR(14),
  noap_date VARCHAR(11),
  appeal_type VARCHAR(1),
  sent_appeal VARCHAR(1),
  disposition VARCHAR(2),
  disposition_date VARCHAR(11),
  disposition_reason1 VARCHAR(4),
  disposition_reason2 VARCHAR(4),
  disposition_reason3 VARCHAR(4),
  sys_disp_date VARCHAR(11),
  sys_filing_date VARCHAR(11),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  KEY district_idx(district),
  KEY id_idx(id),
  KEY caseid_idx(caseid),
  KEY disposition_idx(disposition),
  KEY disposition_reason1_idx(disposition_reason1),
  KEY court_idx(court),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

ALTER TABLE lions.case
  ADD dt_recvd DATE,
  ADD dt_close DATE
;

UPDATE lions.case
  SET dt_recvd = STR_TO_DATE(recvd_date, '%d-%b-%Y'),
    dt_close = STR_TO_DATE(close_date, '%d-%b-%Y')
;


TRUNCATE TABLE lions.court_history;

LOAD DATA LOCAL INFILE '/lions/gs_court_hist.txt'
  INTO TABLE lions.court_history
  FIELDS TERMINATED BY ''
;

ALTER TABLE lions.case
  ADD yr VARCHAR(4)
;
UPDATE lions.case
  SET yr = RIGHT(recvd_date,4)
;

ALTER TABLE lions.case
  ADD KEY yr_idx(yr)
;

ALTER TABLE lions.court_history
  ADD yr VARCHAR(4),
  ADD KEY yr_idx(yr)
;

UPDATE lions.court_history
  SET yr = RIGHT(filing_date,4)
;

DROP TABLE IF EXISTS lions.court_history_dc;

CREATE TABLE lions.court_history_dc
  SELECT caseid, court, district, id,
    yr, filing_date, disposition, disposition_reason1,
    disposition_reason2, disposition_reason3
  FROM lions.court_history
  WHERE court = 'DC'
;

ALTER TABLE lions.court_history_dc
  ADD KEY id_idx(id),
  ADD KEY caseid_idx(caseid),
  ADD KEY district_idx(district),
  ADD KEY yr_idx(yr),
  ADD fy VARCHAR(4),
  ADD mo VARCHAR(3),
  ADD KEY mo_idx(mo),
  ADD pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
;

UPDATE lions.court_history_dc 
  SET mo = MID(filing_date,4,3)
;

UPDATE lions.court_history_dc
  SET fy = IF( mo IN ('OCT','NOV','DEC'), yr + 1, yr )
;

ALTER TABLE lions.court_history_dc ADD KEY fy_idx(fy)
;

DROP TABLE IF EXISTS lions.court_history_tc;

CREATE TABLE lions.court_history_tc
  SELECT caseid, court, district, id,
    yr, filing_date, disposition, disposition_reason1,
    disposition_reason2, disposition_reason3
  FROM lions.court_history
  WHERE court IN('DC','NC','MG')
;
	
ALTER TABLE lions.court_history_nt
  ADD KEY id_idx(id),
  ADD KEY caseid_idx(caseid),
  ADD KEY district_idx(district),
  ADD KEY yr_idx(yr),
  ADD fy VARCHAR(4),
  ADD mo VARCHAR(3),
  ADD KEY mo_idx(mo),
  ADD pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
;


DROP TABLE IF EXISTS lions.ch;
CREATE TABLE lions.ch
  SELECT caseid, district,
    MIN(fy) AS first_fy,
    MIN(yr) AS first_yr
  FROM lions.court_history_dc
  WHERE filing_date IS NOT NULL
    AND filing_date <> ''
  GROUP BY caseid,
    district
;
ALTER TABLE lions.ch
  ADD KEY caseid_idx(caseid),
  ADD KEY district_idx(district),
  ADD KEY first_fy_idx(first_fy),
  ADD pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
;

DROP TABLE IF EXISTS lions.chc;
CREATE TABLE lions.chc
  SELECT ch.caseid, ch.district, ch.first_fy, ch.first_yr,
    c.status, c.class, c.us_role
  FROM lions.ch INNER JOIN lions.case AS c
    ON ch.caseid = c.id AND ch.district = c.district
  WHERE c.class = 'R'
;

ALTER TABLE lions.chc
  ADD KEY caseid_idx(caseid),
  ADD KEY district_idx(district),
  ADD pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ADD KEY status_idx(status),
  ADD KEY first_fy_idx(first_fy),
  ADD KEY first_yr_idx(first_yr)
;


TRUNCATE TABLE lions.archive_case;
LOAD DATA LOCAL INFILE '/lions/gs_archive_case.txt'
  INTO TABLE lions.archive_case
  FIELDS TERMINATED BY ''
;

TRUNCATE TABLE lions.event;

LOAD DATA LOCAL INFILE '/lions/gs_event.txt'
  INTO TABLE lions.event
  FIELDS TERMINATED BY ''
;

CREATE TABLE lions.event_adverse
  LIKE lions.event
;

INSERT INTO lions.event_adverse
  SELECT * 
  FROM lions.event
  WHERE typ IN('NWTR','MIST','HUNG','REVR','RESN','VARM','VACA')
;

CREATE TABLE lions.participant_court(
  district VARCHAR(10),
  caseid VARCHAR(10),
  partid VARCHAR(10),
  crthsid VARCHAR(10),
  appeal_role VARCHAR(2),
  disposition VARCHAR(2),
  disposition_reason VARCHAR(4),
  disposition_date VARCHAR(11),
  sys_disposition_date VARCHAR(11),
  sys_init_date VARCHAR(11),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  KEY district_idx(district),
  KEY caseid_idx(caseid),
  KEY partid_idx(partid),
  KEY crthsid_idx(crthsid),
  KEY disposition_idx(disposition),
  KEY appeal_role_idx(appeal_role),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;
ALTER TABLE lions.participant_court
  ADD KEY disposition_reason_idx(disposition_reason)
;

ALTER TABLE lions.participant_count
  ADD disp_mo VARCHAR(3),
  ADD disp_yr VARCHAR(4),
  ADD KEY disp_mo_idx(disp_mo),
  ADD KEY disp_yr_idx(disp_yr)
;

UPDATE lions.participant_count
  SET disp_yr = RIGHT(disp_date,4),
    disp_mo = MID(disp_date,4,3)
;

TRUNCATE TABLE lions.participant_court;
LOAD DATA LOCAL INFILE '/lions/gs_part_court.txt'
  INTO TABLE lions.participant_court
  FIELDS TERMINATED BY ''
;

ALTER TABLE lions.participant_court
  ADD disp_mo VARCHAR(3),
  ADD disp_yr VARCHAR(4),
  ADD KEY disp_mo_idx(disp_mo),
  ADD KEY disp_yr_idx(disp_yr)
;

UPDATE lions.participant_court
  SET disp_yr = RIGHT(disposition_date,4),
    disp_mo = MID(disposition_date,4,3)
;

CREATE TABLE lions.inst_charge(
  district VARCHAR(10),
  caseid VARCHAR(10),
  crthsid VARCHAR(10),
  instid VARCHAR(10),
  charge VARCHAR(25),
  category VARCHAR(1),
  pent_prov VARCHAR(25),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  id VARCHAR(10),
  KEY district_idx(district),
  KEY caseid_idx(caseid),
  KEY crthsid_idx(crthsid),
  KEY id_idx(id),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;  


# PHASE 2 

DROP TABLE IF EXISTS lions.assignment
;

CREATE TABLE IF NOT EXISTS lions.assignment(
  district VARCHAR(10),
  caseid VARCHAR(10),
  crthsid VARCHAR(10),
  id VARCHAR(10),
  staffid VARCHAR(10),
  position VARCHAR(1),
  start_date VARCHAR(11),
  end_date VARCHAR(11),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  KEY district_idx(district),
  KEY caseid_idx(caseid),
  KEY crthsid_idx(crthsid),
  KEY id_idx(id),
  KEY staffid_idx(staffid),
  KEY position_idx(position),
  start_yr VARCHAR(4),
  KEY start_yr_idx(start_yr),
  end_yr VARCHAR(4),
  KEY end_yr_idx(end_yr),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

TRUNCATE TABLE lions.assignment;
LOAD DATA LOCAL INFILE '/lions/gs_assignment.txt'
  INTO TABLE lions.assignment
  FIELDS TERMINATED BY ''
;

ALTER TABLE lions.assignment
  DROP update_user,
  DROP create_user
;

UPDATE lions.assignment 
  SET start_yr = RIGHT(start_date,4),
    end_yr = RIGHT(end_date,4)
;


DROP TABLE IF EXISTS lions.assignment_distinct
;

CREATE TABLE lions.assignment_distinct
  SELECT DISTINCT district,
    caseid,
    staffid
  FROM lions.assignment
;

ALTER TABLE lions.assignment_distinct
  ADD pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ADD KEY district_idx(district),
  ADD KEY caseid_idx(caseid),
  ADD KEY staffid_idx(staffid)
;

DROP TABLE IF EXISTS lions.staff
;

CREATE TABLE IF NOT EXISTS lions.staff(
  district VARCHAR(3),
  staffid VARCHAR(10),
  username VARCHAR(18),
  initials VARCHAR(8),
  init_stat VARCHAR(1),
  staff_title VARCHAR(3),
  salutation VARCHAR(8),
  last_name VARCHAR(30),
  first_name VARCHAR(30),
  office_loc VARCHAR(30),
  phone VARCHAR(15),
  issued_date VARCHAR(11),
  default_dir VARCHAR(40),
  default_print VARCHAR(40),
  default_dc_loc VARCHAR(2),
  default_branch VARCHAR(3),
  name_search VARCHAR(1),
  staff_sec_type VARCHAR(1),
  staff_section VARCHAR(8),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  ad_username VARCHAR(30),
  lcms_position VARCHAR(25),
  case_type VARCHAR(10),
  action_stage VARCHAR(10),
  dr_username VARCHAR(30),
  guid VARCHAR(30),
  KEY district_idx(district),
  KEY staffid_idx(staffid),
  KEY initials_idx(initials),
  KEY last_name_idx(last_name),
  KEY first_name_idx(first_name),
  KEY staff_title_idx(staff_title),
  KEY staff_sec_type_idx(staff_sec_type),
  KEY staff_section_idx(staff_section),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

TRUNCATE TABLE lions.staff
;
LOAD DATA LOCAL INFILE '/lions/gs_staff.txt'
  INTO TABLE lions.staff
  FIELDS TERMINATED BY ''
;

DROP TABLE IF EXISTS lions.districts;
CREATE TABLE lions.districts
  SELECT DISTINCT district FROM lions.staff
;
ALTER TABLE lions.districts
  ADD KEY district_idx(district),
  ADD pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
;


TRUNCATE TABLE lions.participant;
ALTER TABLE lions.participant DISABLE KEYS;
LOAD DATA LOCAL INFILE '/lions/participant.txt'
  INTO TABLE lions.participant
  FIELDS TERMINATED BY ''
;
ALTER TABLE lions.participant ENABLE KEYS;

DROP TABLE IF EXISTS lions.defendants
;

CREATE TABLE IF NOT EXISTS lions.defendants
  SELECT *
  FROM lions.participant
  WHERE role IN('D','DG','DP','DJ')
;
ALTER TABLE lions.defendants
  ADD KEY id_idx(id),
  ADD KEY caseid_idx(caseid),
  ADD KEY district_idx(district),
  ADD KEY cdp_idx(caseid,district,id),
  ADD def_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ADD KEY typ_idx(typ),
  ADD KEY role_idx(role),
  ADD KEY cd_idx(caseid,district)
;

DROP TABLE IF EXISTS lions.sentence;

CREATE TABLE IF NOT EXISTS lions.sentence(
  district VARCHAR(10),
  caseid VARCHAR(10),
  partid VARCHAR(10),
  sent_date VARCHAR(11),
  guide_depart VARCHAR(1),
  incar_type VARCHAR(3),
  judgeid VARCHAR(10),
  prob_days VARCHAR(11),
  prob_months VARCHAR(11),
  prob_years VARCHAR(11),
  super_rel_days VARCHAR(11),
  super_rel_months VARCHAR(11),
  super_rel_years VARCHAR(11),
  incar_days VARCHAR(11),
  incar_months VARCHAR(11),
  incar_years VARCHAR(11),
  fine VARCHAR(14),
  spec_assessment VARCHAR(14),
  debarred VARCHAR(1),
  spec_condition VARCHAR(4),
  probation_revoked VARCHAR(1),
  super_rel_revoked VARCHAR(1),
  total_revoked_days VARCHAR(11),
  total_revoked_months VARCHAR(11),
  total_revoked_years VARCHAR(11),
  related_flu_usao VARCHAR(10),
  related_flu_seq VARCHAR(3),
  comm_serv_hours VARCHAR(12),
  sys_sent_date VARCHAR(11),
  restitution_amt VARCHAR(16),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  supv_rel_incar_type VARCHAR(1),
  KEY district_idx(district),
  KEY caseid_idx(caseid),
  KEY partid_idx(partid),
  KEY cd_idx(caseid,district),
  KEY cdp_idx(caseid,district,partid),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

TRUNCATE TABLE lions.sentence;
LOAD DATA LOCAL INFILE '/lions/gs_sentence.txt'
  INTO TABLE lions.sentence
  FIELDS TERMINATED BY ''
;


# EXTRANEOUS -- OPTIONAL

DROP TABLE IF EXISTS lions.inst;
CREATE TABLE lions.inst(
  district VARCHAR(10),
  caseid VARCHAR(10),
  crthsid VARCHAR(10),
  id VARCHAR(10),
  typ VARCHAR(2),
  filing_date VARCHAR(11),
  sys_filing_date VARCHAR(11),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  KEY district_idx(district),
  KEY caseid_idx(caseid),
  KEY crthsid_idx(crthsid),
  KEY id_idx(id),
  KEY typ_idx(typ),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;  

TRUNCATE TABLE lions.inst;
LOAD DATA LOCAL INFILE '/lions/gs_instrument.txt'
  INTO TABLE lions.inst
  FIELDS TERMINATED BY ''
;


# CASE SUMMARY 
# -----------------------------------------------------
# CASE SUMMARY SECTION
# -----------------------------------------------------


DROP TABLE IF EXISTS lions.case_summary;

CREATE TABLE lions.case_summary(
  caseid VARCHAR(10),
  district VARCHAR(10),
  status VARCHAR(1),
  lead_charge VARCHAR(10),
  date_received VARCHAR(11),
  offense_range VARCHAR(50),
  prosecutors INT,
  defendants INT,
  prison_sentence INT,
  conviction_records INT,
  jury_trial_records INT,
  adverse_dct INT,
  adverse_cta INT,
  adverse_cta_worst INT,
  adverse_new_trial INT,
  adverse_mistrial INT,
  adverse INT,
  first_prog_cat VARCHAR(10),
  first_prog_cat_desc VARCHAR(255),
  first_yr VARCHAR(4),
  filing_date VARCHAR(11),
  KEY caseid_idx(caseid),
  KEY district_idx(district),
  KEY conviction_records_idx(conviction_records),
  KEY jurial_trial_records_idx(jury_trial_records),
  KEY adverse_dct_idx(adverse_dct),
  KEY adverse_cta_idx(adverse_cta),
  KEY adverse_idx(adverse),
  KEY first_yr_idx(first_yr),
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

ALTER TABLE lions.case_summary
  ADD jtri INT DEFAULT 0,
  ADD KEY jtri_idx(jtri)
;

# CASE LIST
INSERT INTO lions.case_summary(caseid, district, first_yr)
  SELECT caseid,
    district,
    first_yr 
  FROM lions.chc
  WHERE first_yr >= '1995'
    AND class = 'R'
;

# ADVERSE DISTRICT COURT HISTORY
UPDATE lions.case_summary AS cs,
  ( SELECT caseid, district, 
      COUNT(*) AS c
    FROM lions.court_history_dc
    WHERE disposition IN('DJ') OR 
       ( disposition_reason1 IN('MISD','MISM','STRD','STRM') 
            OR disposition_reason2 IN('MISD','MISM','STRD','STRM') 
            OR disposition_reason3 IN('MISD','MISM','STRD','STRM') 
       )
	 GROUP BY caseid, district
  ) AS t
  SET cs.adverse_dct = t.c
  WHERE cs.caseid = t.caseid
    AND cs.district = t.district
;

# BASIC CASE INFORMATION
UPDATE lions.case_summary AS cs, lions.case AS c
  SET cs.lead_charge = c.lead_charge,
    cs.date_received = c.recvd_date,
	cs.status = c.status,
	cs.offense_range = CONCAT(c.offense_from,' - ', c.offense_to)
  WHERE cs.caseid = c.id
    AND cs.district = c.district
;

# ADVERSE APPELLATE FINDINGS
UPDATE lions.case_summary AS cs,
  ( SELECT caseid, district, 
      SUM(IF(court = 'CA' AND disposition = 'NF', 1, 0)) AS adverse_cta,
	  SUM(IF(court = 'CA' AND disposition = 'NF' AND us_role = 'AE' AND disposition_reason1 IN('AFRR','AFRV','AFVR','RARM','RDAP','RDRR','REVA','VACA','VARM'), 1, 0)) AS adverse_cta_worst
	FROM lions.court_history
	GROUP BY caseid, district
  ) AS t
  SET cs.adverse_cta = t.adverse_cta,
    cs.adverse_cta_worst = t.adverse_cta_worst
  WHERE cs.caseid = t.caseid
    AND cs.district = t.district
;

UPDATE lions.case_summary AS cs, 
  ( SELECT caseid, district,
      SUM(IF(typ = 'NWTR', 1, 0)) AS adverse_new_trial,
	  SUM(IF(typ = 'MIST', 1, 0)) AS adverse_mistrial
	FROM lions.event_adverse
	GROUP BY caseid, district
  ) AS t
  SET cs.adverse_new_trial = t.adverse_new_trial,
    cs.adverse_mistrial = t.adverse_mistrial
  WHERE cs.caseid = t.caseid
    AND cs.district = t.district
;

# DEFENDANTS
UPDATE lions.case_summary AS cs,
  ( SELECT caseid, district, COUNT(*) AS c
    FROM lions.defendants
	GROUP BY caseid, district
  ) AS t
  SET cs.defendants = t.c
  WHERE cs.caseid = t.caseid
    AND cs.district = t.district
;

# AUSAs
UPDATE lions.case_summary AS cs,
  ( SELECT caseid, district,
      COUNT(*) AS prosecutors
	FROM lions.assignment_distinct
	GROUP BY caseid, district
  ) AS t
  SET cs.prosecutors = t.prosecutors
  WHERE cs.caseid = t.caseid
    AND cs.district = t.district
;

# CONVICTION RECORDS
UPDATE lions.case_summary AS cs
  SET conviction_records = (
      SELECT COUNT(*)
      FROM lions.court_history_dc AS c
      WHERE c.district = cs.district
        AND c.caseid = cs.caseid
        AND c.disposition = 'GT'
    )
;

# FILING DATE
UPDATE lions.case_summary AS cs
  SET filing_date = (
      SELECT filing_date
      FROM lions.court_history AS c
      WHERE cs.caseid = c.caseid
        AND cs.district = c.district
        AND c.filing_date IS NOT NULL
        AND c.filing_date <> ''
        AND TRIM(c.filing_date) <> ''
      ORDER BY (id * 1) ASC
      LIMIT 1  
    )
;

# FIRST PROG CAT
UPDATE lions.case_summary AS cs
  SET first_prog_cat = (
      SELECT prog_cat
      FROM lions.case_prog_cat AS c
      WHERE cs.caseid = c.caseid
        AND cs.district = c.district
      LIMIT 1
    )
;

# SENTENCES
UPDATE lions.case_summary AS cs
  SET prison_sentence = (
      SELECT (incar_years * 12) + incar_months AS months
      FROM lions.sentence AS s
      WHERE cs.caseid = s.caseid
        AND cs.district = s.district
      ORDER BY months DESC
      LIMIT 1
    )
;

# SUMMARIZE
UPDATE lions.case_summary
  SET adverse = IFNULL(adverse_dct,0)
      + IFNULL(adverse_cta, 0)
      + IFNULL(adverse_new_trial,0)
      + IFNULL(adverse_mistrial,0)
;

ALTER TABLE lions.case_summary
  ADD KEY adverse_new_trial_idx(adverse_new_trial),
  ADD KEY adverse_mistrial_idx(adverse_mistrial)
;

ALTER TABLE lions.case_summary
  ADD dt_filed DATE
;

UPDATE lions.case_summary
  SET dt_filed = STR_TO_DATE(filing_date, '%d-%b-%Y')
;


# CROSSTAB
DROP TABLE IF EXISTS lions.big_crosstab;
CREATE TABLE lions.big_crosstab
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
  SUM(IF(c.first_yr = '1996', 1, 0)) AS c1996,     
  SUM(IF(c.first_yr = '1997', 1, 0)) AS c1997,
  SUM(IF(c.first_yr = '1996', 1, 0)) AS c1998,
  SUM(IF(c.first_yr = '1999', 1, 0)) AS c1999,
  SUM(IF(c.first_yr = '2000', 1, 0)) AS c2000,
  SUM(IF(c.first_yr = '2001', 1, 0)) AS c2001,
  SUM(IF(c.first_yr = '2002', 1, 0)) AS c2002,
  SUM(IF(c.first_yr = '2003', 1, 0)) AS c2003,
  SUM(IF(c.first_yr = '2004', 1, 0)) AS c2004,
  SUM(IF(c.first_yr = '2005', 1, 0)) AS c2005,
  SUM(IF(c.first_yr = '2006', 1, 0)) AS c2006,
  SUM(IF(c.first_yr = '2007', 1, 0)) AS c2007,
  SUM(IF(c.first_yr = '2008', 1, 0)) AS c2008,
  SUM(IF(c.first_yr = '2009', 1, 0)) AS c2009,
  SUM(IF(c.first_yr = '2010', 1, 0)) AS c2010,
  SUM(IF(c.first_yr = '2011', 1, 0)) as c2011,
  SUM(IF(c.first_yr = '2012', 1, 0)) AS c2012,
  SUM(IF(c.first_yr = '2013', 1, 0)) AS c2013,
  SUM(IF(c.first_yr = '2014', 1, 0)) AS c2014,
  SUM(IF(c.first_yr = '2015', 1, 0)) AS c2015,
  SUM(IF(c.first_yr = '2016', 1, 0)) AS c2016,
  SUM(IF(c.first_yr = '2017', 1, 0)) AS c2017,
  SUM(IF(c.first_yr = '2018', 1, 0)) AS c2018,
  COUNT(*) AS total_cases
  FROM lions.chc AS c INNER JOIN lions.case_prog_cat AS p
    USING(caseid, district)
  WHERE c.first_yr >= '1996'
  GROUP BY p.prog_cat,
    description
;
  
DROP TABLE IF EXISTS lions.big_crosstab_fy;
CREATE TABLE lions.big_crosstab_fy
  SELECT p.prog_cat,
    CASE p.prog_cat
      WHEN '011' THEN 'Federal Corruption - Procurement'
      WHEN '012' THEN 'Federal Corruption - Program'
      WHEN '013' THEN 'Federal Corruption - Law Enforcement'
      WHEN '014' THEN 'Federal Corruption - Other'
      WHEN '015' THEN 'State Corruption'
      WHEN '016' THEN 'Local Corruption'
      WHEN '017' THEN 'Other Public Corruption'
      WHEN '021' THEN 'Organized Crime - Emerging Organizations'
      WHEN '031' THEN 'Federal Procurement Fraud'
      WHEN '032' THEN 'Federal Program Fraud'
      WHEN '033' THEN 'Tax Fraud'
      WHEN '036' THEN 'Financial Institution Fraud'
      WHEN '037' THEN 'Bankruptcy Fraud'
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
      WHEN '05F' THEN 'Civil Rights - Racial Violence, Including Hate Crimes'
      WHEN '05H' THEN 'Civil Rights - Hate Crimes Arising out of Terrorist Attacks on U.S.'
      WHEN '055' THEN 'Violations and the Immigration and Nationality Act'
      WHEN '061' THEN 'Counterfeiting and Forgery'
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
      ELSE NULL 
    END AS description,
  SUM(IF(c.first_fy = '1996', 1, 0)) AS c1996,     
  SUM(IF(c.first_fy = '1997', 1, 0)) AS c1997,
  SUM(IF(c.first_fy = '1996', 1, 0)) AS c1998,
  SUM(IF(c.first_fy = '1999', 1, 0)) AS c1999,
  SUM(IF(c.first_fy = '2000', 1, 0)) AS c2000,
  SUM(IF(c.first_fy = '2001', 1, 0)) AS c2001,
  SUM(IF(c.first_fy = '2002', 1, 0)) AS c2002,
  SUM(IF(c.first_fy = '2003', 1, 0)) AS c2003,
  SUM(IF(c.first_fy = '2004', 1, 0)) AS c2004,
  SUM(IF(c.first_fy = '2005', 1, 0)) AS c2005,
  SUM(IF(c.first_fy = '2006', 1, 0)) AS c2006,
  SUM(IF(c.first_fy = '2007', 1, 0)) AS c2007,
  SUM(IF(c.first_fy = '2008', 1, 0)) AS c2008,
  SUM(IF(c.first_fy = '2009', 1, 0)) AS c2009,
  SUM(IF(c.first_fy = '2010', 1, 0)) AS c2010,
  SUM(IF(c.first_fy = '2011', 1, 0)) AS c2011,
  COUNT(*) AS total_cases
  FROM lions.chc AS c INNER JOIN lions.case_prog_cat AS p
    USING(caseid, district)
  WHERE c.first_fy >= '1996'
  GROUP BY p.prog_cat,
    description
;

# define and load controlled substances table
DROP TABLE lions.controlled_sub
;
CREATE TABLE IF NOT EXISTS lions.controlled_sub(
  district VARCHAR(10),
  caseid VARCHAR(10),
  id VARCHAR(10),
  typ VARCHAR(1),
  quantity VARCHAR(14),
  measure VARCHAR(1),
  description VARCHAR(30),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),
  qty DOUBLE,
  pid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  KEY district_idx(district),
  KEY caseid_idx(caseid),
  KEY qty_idx(qty),
  KEY measure_idx(measure),
  KEY typ_idx(typ)
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

LOAD DATA LOCAL INFILE '/lions/gs_control_sub.txt'
  INTO TABLE lions.controlled_sub
  FIELDS TERMINATED BY ''
;

UPDATE lions.controlled_sub
  SET qty = quantity
  WHERE quantity IS NOT NULL
;

# FIRST PROG CAT DESC
UPDATE lions.case_summary AS cs
  SET first_prog_cat_desc = (
      SELECT description
      FROM lions.big_crosstab AS b
      WHERE cs.first_prog_cat = b.prog_cat
    ) 
  WHERE first_prog_cat IS NOT NULL
;

# MONTHLY CROSSTAB
DROP TABLE IF EXISTS lions.crosstab_month;
CREATE TABLE lions.crosstab_month
  SELECT p.prog_cat,
    CASE p.prog_cat
      WHEN '011' THEN 'Federal Corruption - Procurement'
      WHEN '012' THEN 'Federal Corruption - Program'
      WHEN '013' THEN 'Federal Corruption - Law Enforcement'
      WHEN '014' THEN 'Federal Corruption - Other'
      WHEN '015' THEN 'State Corruption'
      WHEN '016' THEN 'Local Corruption'
      WHEN '017' THEN 'Other Public Corruption'
      WHEN '021' THEN 'Organized Crime - Emerging Organizations'
      WHEN '031' THEN 'Federal Procurement Fraud'
      WHEN '032' THEN 'Federal Program Fraud'
      WHEN '033' THEN 'Tax Fraud'
      WHEN '036' THEN 'Financial Institution Fraud'
      WHEN '037' THEN 'Bankruptcy Fraud'
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
      WHEN '05F' THEN 'Civil Rights - Racial Violence, Including Hate Crimes'
      WHEN '05H' THEN 'Civil Rights - Hate Crimes Arising out of Terrorist Attacks on U.S.'
      WHEN '055' THEN 'Violations and the Immigration and Nationality Act'
      WHEN '061' THEN 'Counterfeiting and Forgery'
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
      ELSE NULL 
    END AS description,
  RIGHT(c.filing_date, 4) AS yr,
  CONCAT(RIGHT(filing_date,4), '-', 
    IF(MID(filing_date,4,3) = 'JAN', '01', 
	IF(MID(filing_date,4,3) = 'FEB', '02', 
	IF(MID(filing_date,4,3) = 'MAR', '03', 
	IF(MID(filing_date,4,3) = 'APR', '04', 
	IF(MID(filing_date,4,3) = 'MAY', '05', 
	IF(MID(filing_date,4,3) = 'JUN', '06', 
	IF(MID(filing_date,4,3) = 'JUL', '07', 
	IF(MID(filing_date,4,3) = 'AUG', '08', 
	IF(MID(filing_date,4,3) = 'SEP', '09', 
	IF(MID(filing_date,4,3) = 'OCT', '10', 
	IF(MID(filing_date,4,3) = 'NOV', '11', 
	IF(MID(filing_date,4,3) = 'DEC', '12','')))))))))))))
	AS yrmo,
  COUNT(*) AS cases
  FROM lions.case_summary AS c INNER JOIN lions.case_prog_cat AS p
    USING(caseid, district)
  WHERE c.first_yr >= '1990'
  GROUP BY p.prog_cat,
    description,
    yr,
    yrmo
;

ALTER TABLE lions.case_summary
   ADD first_fy VARCHAR(4)
;

ALTER TABLE lions.case_summary
   ADD KEY first_fy_idx(first_fy)
;

UPDATE lions.case_summary AS cs
  SET first_fy = ( 
    SELECT first_fy FROM chc
	WHERE chc.caseid = cs.caseid
	  AND chc.district = cs.district
  )
;

UPDATE lions.staff AS s, lions_lookups.staff AS l
  SET s.last_name = l.last_name,
    s.first_name = l.first_name
  WHERE s.district = l.district
    AND s.staffid = l.staffid
	AND s.initials = l.initials
;

DROP TABLE IF EXISTS lions.event_r35
;
CREATE TABLE IF NOT EXISTS lions.event_r35
  LIKE lions.event
;
INSERT INTO lions.event_r35
  SELECT *
  FROM lions.event
  WHERE typ IN ('RURD','RURH')
;

ALTER TABLE lions.case_summary ADD KEY cdidx(caseid,district);
ALTER TABLE lions.sentence ADD KEY cdidx(caseid,district);

CREATE TABLE IF NOT EXISTS lions.defendants_mf
  SELECT * FROM lions.defendants LIMIT 0
;
ALTER TABLE lions.defendants_mf
  ADD KEY dci_idx(district,caseid,id),
  ADD KEY dcig_idx(district,caseid,id,gener)
;
INSERT INTO lions.defendants_mf
  SELECT * 
  FROM lions.defendants
  WHERE gener IN('M','F')
;

DROP TABLE IF EXISTS lions.ussc_lookup_big;
create table if not exists lions.ussc_lookup_big
  select case_summary.*,
	sentence.partid,
	incar_days,
	incar_months,
	incar_years,
	incar_type,
	restitution_amt,
	(incar_days / 30) + incar_months + (incar_years * 12) as tot_incar_months,
	(super_rel_days / 30) + super_rel_months + (super_rel_years * 12) AS tot_super_rel,
	judgeid,
	guide_depart,
	sent_date,
	right(sent_date,4) AS sent_yr,
	CASE MID(sent_date,4,3)
		when 'JAN' then '01'
		when 'FEB' then '02'
		when 'MAR' then '03'
		when 'APR' then '04'
		when 'MAY' then '05'
		when 'JUN' then '06'
		when 'JUL' then '07'
		when 'AUG' then '08'
		when 'SEP' then '09'
		when 'OCT' then '10'
		when 'NOV' then '11'
		when 'DEC' then '12'
	END AS sent_mo,
	fine
  from lions.sentence inner join lions.case_summary
    using(caseid,district)
  where case_summary.first_yr >= '1998'
;

ALTER TABLE lions.ussc_lookup_big
    ADD KEY caseid_idx(caseid),
	ADD KEY district_idx(district),
	ADD KEY guide_depart_idx(guide_depart),
	ADD KEY sent_mo_idx(sent_mo),
	ADD KEY sent_yr_idx(sent_yr),
	ADD KEY fine_idx(fine)
;

ALTER TABLE lions.ussc_lookup_big
  ADD dist VARCHAR(20),
  ADD KEY dist_idx(dist)
;

UPDATE  lions.ussc_lookup_big
  SET dist = 
  CASE district
    WHEN 'ME' THEN 'D. Maine'
	WHEN 'MA' THEN  'D. Mass.'
	WHEN 'NH' THEN 'D.N.H.'
	WHEN 'RI' THEN  'D.R.I.'
	WHEN 'PR' THEN  'D.P.R.'
	WHEN 'CT' THEN 'D. Conn.'
	WHEN 'NYN' THEN 'N.D.N.Y.'
	WHEN 'NYE' THEN 'E.D.N.Y.'
	WHEN 'NYS' THEN 'S.D.N.Y.'
	WHEN 'NYW' THEN 'W.D.N.Y.'
	WHEN 'VT' THEN 'D. Vt.'
    WHEN 'DE' THEN   'D. Del.'
	WHEN 'NJ' THEN 'D.N.J.'
	WHEN 'PAE' THEN 'E.D. Pa.'
	WHEN 'PAM' THEN 'M.D. Pa.'
	WHEN 'PAW' THEN 'W.D. Pa.'
	WHEN 'MD' THEN 'D. Md.'
	WHEN 'NCE' THEN 'E.D.N.C.'
	WHEN 'NCM' THEN 'M.D.N.C.'
	WHEN 'NCW' THEN 'W.D.N.C.'
    WHEN 'SC' THEN 'D.S.C.'
	WHEN 'VAE' THEN   'E.D. Va.'
	WHEN 'VAW' THEN  'W.D. Va.'
	WHEN 'WVN' THEN 'N.D. W. Va.'
	WHEN 'WVS' THEN 'S.D. W. Va.'
	WHEN 'ALN' THEN 'N.D. Ala.'
	WHEN 'ALM' THEN 'M.D. Ala.'
	WHEN 'ALS' THEN 'S.D. Ala.'
	WHEN 'FLN' THEN 'N.D. Fla.'
	WHEN 'FLM' THEN 'M.D. Fla.'
	WHEN 'FLS' THEN 'S.D. Fla.'
    WHEN 'GAN' THEN 'N.D. Ga.'
	WHEN 'GAM' THEN 'M.D. Ga.'
	WHEN 'GAS' THEN 'S.D. Ga.'
	WHEN 'LAE' THEN 'E.D. La.'
	WHEN 'LAW' THEN 'W.D. La.'
	WHEN 'MSN' THEN 'N.D. Miss.'
	WHEN 'MSS' THEN 'S.D. Miss.'
	WHEN 'TXN' THEN 'N.D. Texas'
    WHEN 'TXE' THEN 'E.D. Texas'
	WHEN 'TXS' THEN  'S.D. Texas'
	WHEN 'TXW' THEN 'W.D. Texas'
	WHEN 'KYE' THEN 'E.D. Ky.'
	WHEN 'KYW' THEN  'W.D. Ky.'
	WHEN 'MIE' THEN 'E.D. Mich.'
	WHEN 'MIW' THEN 'W.D. Mich.'
	WHEN 'OHN' THEN 'N.D. Ohio'
	WHEN 'OHS' THEN 'S.D. Ohio'
	WHEN 'TNE' THEN 'E.D. Tenn.'
	WHEN 'TNM' THEN 'M.D. Tenn.'
    WHEN 'TNW' THEN  'W.D. Tenn.'
	WHEN 'ILN' THEN  'N.D. Ill.'
	WHEN 'ILC' THEN  'C.D. Ill.'
	WHEN 'ILS' THEN 'S.D. Ill.'
	WHEN 'INN' THEN 'N.D. Ind.'
	WHEN 'INS' THEN 'S.D. Ind.'
	WHEN 'WIE' THEN 'E.D. Wis.'
	WHEN 'WIW' THEN 'W.D. Wis.'
	WHEN 'ARE' THEN 'E.D. Ark.'
	WHEN 'ARW' THEN 'W.D. Ark.'
    WHEN 'IAN' THEN   'N.D. Iowa'
	WHEN 'IAS' THEN 'S.D. Iowa'
	WHEN 'MN' THEN 'D. Minn.'
	WHEN 'MOE' THEN 'E.D. Mo.'
	WHEN 'MOW' THEN 'W.D. Mo.'
	WHEN 'NE' THEN 'D. Neb.'
	WHEN 'ND' THEN 'D.N.D.'
	WHEN 'SD' THEN 'D.S.D.'
	WHEN 'AZ' THEN 'D. Ariz.'
    WHEN 'CAN' THEN   'N.D. Cal.'
	WHEN 'CAE' THEN 'E.D. Cal.'
	WHEN 'CAC' THEN 'C.D. Cal.'
	WHEN 'CAS' THEN 'S.D. Cal.'
	WHEN 'HI' THEN 'D. Hawaii'
	WHEN 'ID' THEN 'D. Idaho'
	WHEN 'MT' THEN 'D. Mont.'
	WHEN 'NV' THEN 'D. Nev.'
	WHEN 'OR' THEN 'D. Ore.'
	WHEN 'WAE' THEN 'E.D. Wa.'
    WHEN 'WAW' THEN   'W.D. Wa.'
	WHEN 'CO' THEN 'D. Colo.'
	WHEN 'KS' THEN 'D. Kan.'
	WHEN 'NM' THEN 'D.N.M.'
	WHEN 'OKN' THEN 'N.D. Okla.'
	WHEN 'OKE' THEN 'E.D. Okla.'
	WHEN 'OKW' THEN 'W.D. Okla.'
	WHEN 'UT' THEN 'D. Utah'
	WHEN 'WY' THEN 'D. Wyo.'
	WHEN 'DC' THEN 'D.D.C.' 
	WHEN 'VI' THEN 'D.V.I.'
	WHEN 'GU' THEN 'D. Guam'
	WHEN 'AK' THEN 'D. Alaska'
	WHEN 'LAM' THEN 'M.D. La.'
	ELSE 'Unknown'
END 
;

ALTER TABLE lions.ussc_lookup_big
  ADD FULLTEXT KEY first_prog_cat_descidx(first_prog_cat_desc)
;

ALTER TABLE lions.ussc_lookup_big
  ADD sentmon INT,
  ADD KEY sentmon_idx(sentmon)
;
UPDATE lions.ussc_lookup_big SET sentmon = sent_mo
;

UPDATE lions.ussc_lookup_big AS l
  SET first_prog_cat_desc = (
    SELECT GROUP_CONCAT(d)
	FROM ( 
		SELECT caseid, district,
		   CASE cpc.prog_cat
			  WHEN '011' THEN 'Federal Corruption - Procurement'
			  WHEN '012' THEN 'Federal Corruption - Program'
			  WHEN '013' THEN 'Federal Corruption - Law Enforcement'
			  WHEN '014' THEN 'Federal Corruption - Other'
			  WHEN '015' THEN 'State Corruption'
			  WHEN '016' THEN 'Local Corruption'
			  WHEN '017' THEN 'Other Public Corruption'
			  WHEN '021' THEN 'Organized Crime - Emerging Organizations'
			  WHEN '031' THEN 'Federal Procurement Fraud'
			  WHEN '032' THEN 'Federal Program Fraud'
			  WHEN '03Z' THEN 'Other Fraud'
			  WHEN '033' THEN 'Tax Fraud'
			  WHEN '036' THEN 'Financial Institution Fraud'
			  WHEN '037' THEN 'Bankruptcy Fraud'
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
			  WHEN '05F' THEN 'Civil Rights - Racial Violence, Including Hate Crimes'
			  WHEN '05H' THEN 'Civil Rights - Hate Crimes Arising out of Terrorist Attacks on U.S.'
			  WHEN '055' THEN 'Violations and the Immigration and Nationality Act'
			  WHEN '061' THEN 'Counterfeiting and Forgery'
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
			  WHEN '093' THEN 'All Other Violent Crimes'
			  ELSE ''
			  END AS d
			FROM lions.case_prog_cat AS cpc INNER JOIN sentencing.informants_xwalk USING(caseid,district)
			GROUP BY caseid, district
		) AS t
		WHERE l.caseid = t.caseid
		  AND l.district = t.district
	)
;

ALTER TABLE lions.ussc_lookup_big
   ADD monsex INT NOT NULL DEFAULT 9
;
UPDATE lions.ussc_lookup_big AS l
  SET monsex = ( 
	SELECT CASE TRIM(gener)
		WHEN 'M' THEN 0
		WHEN 'F' THEN 1
		ELSE 9
		END
		FROM lions.defendants_mf AS d
		WHERE d.caseid = l.caseid
		  AND d.district = l.district
		  AND d.id = l.partid
  )
;

DROP TABLE IF EXISTS lions.case_prog_cat_text;
CREATE TABLE lions.case_prog_cat_text
SELECT caseid, district, 
	GROUP_CONCAT(CASE cpc.prog_cat
			  WHEN '011' THEN 'Federal Corruption - Procurement'
			  WHEN '012' THEN 'Federal Corruption - Program'
			  WHEN '013' THEN 'Federal Corruption - Law Enforcement'
			  WHEN '014' THEN 'Federal Corruption - Other'
			  WHEN '015' THEN 'State Corruption'
			  WHEN '016' THEN 'Local Corruption'
			  WHEN '017' THEN 'Other Public Corruption'
			  WHEN '021' THEN 'Organized Crime - Emerging Organizations'
			  WHEN '031' THEN 'Federal Procurement Fraud'
			  WHEN '032' THEN 'Federal Program Fraud'
			  WHEN '03Z' THEN 'Other Fraud'
			  WHEN '033' THEN 'Tax Fraud'
			  WHEN '036' THEN 'Financial Institution Fraud'
			  WHEN '037' THEN 'Bankruptcy Fraud'
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
			  WHEN '05F' THEN 'Civil Rights - Racial Violence, Including Hate Crimes'
			  WHEN '05H' THEN 'Civil Rights - Hate Crimes Arising out of Terrorist Attacks on U.S.'
			  WHEN '055' THEN 'Violations and the Immigration and Nationality Act'
			  WHEN '061' THEN 'Counterfeiting and Forgery'
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
			  WHEN '093' THEN 'All Other Violent Crimes'
			  ELSE ''
			  END SEPARATOR ' -- ')
			  AS d
			FROM lions.case_prog_cat  AS cpc
			GROUP BY caseid, district
;
ALTER TABLE lions.case_prog_cat_text
  ADD KEY cd_idx(caseid,district)
;



UPDATE lions.ussc_lookup_big AS l
  SET first_prog_cat_desc = ( 
	SELECT d 
	FROM lions.case_prog_cat_text AS c
	WHERE c.caseid = l.caseid
	  AND c.district = l.district
  )
;			

DROP TABLE IF EXISTS lions.gs_agent
;
CREATE TABLE lions.gs_agent (
	district VARCHAR(10),
	caseid VARCHAR(10),
	partid VARCHAR(10),
	id VARCHAR(10),
	salutation VARCHAR(8),
	last_name VARCHAR(30),
	first_name VARCHAR(30),
	title VARCHAR(30),
	phone VARCHAR(20),
	fax VARCHAR(15),
	pager VARCHAR(15),
	lead_agent VARCHAR(1),
	email VARCHAR(100),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),  
	KEY caseid_idx(caseid),
	KEY district_idx(district),
	KEY partid_idx(partid),
	KEY cd_idx(caseid,district),
	KEY cdp_idx(caseid,district,partid),
	KEY lead_agent_idx(lead_agent),
	KEY cdpl_idx(caseid,district,partid,lead_agent)
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

LOAD DATA LOCAL INFILE '/lions/gs_agent.txt'
  INTO TABLE lions.gs_agent
  FIELDS TERMINATED BY ''
;

DROP TABLE IF EXISTS lions.lead_agents;
CREATE TABLE IF NOT EXISTS lions.lead_agents
  SELECT a.caseid, a.district, a.partid, p.typ, p.role, p.agency, p.agency_num,
    p.job_position, p.gener AS gender, p.agcyoffid
  FROM lions.gs_agent a INNER JOIN lions.participant p
    ON a.caseid = p.caseid AND a.district = p.district AND a.partid = p.id
  WHERE a.lead_agent = 'Y'
;
ALTER TABLE lions.lead_agents
  ADD KEY cdp_idx(caseid,district,partid),
  ADD KEY caseid_idx(caseid),
  ADD KEY district_idx(district),
  ADD KEY cd_idx(caseid,district),
  ADD KEY agency_idx(agency),
  ADD KEY agency_num_idx(agency_num),
  ADD KEY typ_idx(typ),
  ADD KEY role_idx(role)
;

CREATE TABLE lions.expert_case(
  district VARCHAR(10),
  caseid VARCHAR(10),
  id VARCHAR(10),
  exp_side VARCHAR(1),
  expertid VARCHAR(10),
  create_date VARCHAR(11),
  create_user VARCHAR(30),
  update_date VARCHAR(11),
  update_user VARCHAR(30),  
  KEY caseid_idx(caseid),
  KEY district_idx(district),
  KEY cd_idx(caseid,district),
  KEY expertid_idx(expertid)
) ENGINE=MyISAM, CHARACTER SET=latin1, COLLATE=latin1_general_ci
;

LOAD DATA LOCAL INFILE '/lions/gs_expert_case.txt'
  INTO TABLE lions.expert_case
  FIELDS TERMINATED BY ''
;

DROP TABLE IF EXISTS lions.investigating_agency;

CREATE TABLE IF NOT EXISTS lions.investigating_agency
  LIKE lions.participant
;

INSERT INTO lions.investigating_agency
  SELECT *
  FROM lions.participant
  WHERE role = 'IN'
;



