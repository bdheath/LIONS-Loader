<?

	set_time_limit(60*60*24*7);

	require_once("/xampp/htdocs/_common/incl-dbconnect.php");
	$db = new dbLink();
	
	$sql = "DROP TABLE IF EXISTS lions.assignment_distinct_dc ";
	$db->actionQuery($sql);
	$sql = "DROP TABLE IF EXISTS lions.assignment_distinct_dc_1 ";
	$db->actionQuery($sql);
	$sql = "CREATE TABLE lions.assignment_distinct_dc LIKE lions.assignment_distinct ";
	$db->actionQuery($sql);
	$sql = "CREATE TABLE lions.assignment_distinct_dc_1 LIKE lions.assignment_distinct ";
	$db->actionQuery($sql);



	
	$howmany = $db->getScalar("SELECT COUNT(*) AS c FROM lions.case_summary ");
	
	print "-> Reviewing " . number_format($howmany,0) . " records : ";
	$increment = 1000000;
	$howmanyloops = round($howmany / $increment) + 5;

	$startPos = 0;
	for($i = 0; $i <= $howmanyloops; $i++) {
		
		$sql = "SELECT caseid, district FROM lions.case_summary LIMIT $startPos, $increment ";
		$r = $db->query($sql);
		$startPos = $startPos + $increment;
		while($l = mysql_fetch_array($r)) {
//			$l[district] = trim($l[district]);
			$ss = "SELECT id AS crthsid, district, caseid FROM lions.court_history WHERE court IN('DC','NC','MG') AND caseid='$l[caseid]' AND district='$l[district]' ";
			$sr = $db->query($ss) or die($ss);
			while($sl = mysql_fetch_array($sr)) {
				$sl[crthsid] = trim($sl[crthsid]);
				$s = "SELECT staffid FROM lions.assignment WHERE crthsid='$sl[crthsid]' AND caseid='$l[caseid]' AND district='$l[district]' ";
				$rs = $db->query($s);
				while($sls = mysql_fetch_array($rs)) {
//					$h = $db->getScalar("SELECT COUNT(*) AS c FROM lions.assignment_distinct_dc WHERE staffid='$sls[staffid]' AND caseid='$l[caseid]' AND district='$l[district]' ");
//					if($h == 0) {
						$cs = "INSERT INTO lions.assignment_distinct_dc_1(staffid,caseid,district) VALUES('$sls[staffid]', '$l[caseid]', '$l[district]') ";
						$db->actionQuery($cs) or die($cs);
//					}
				}
				mysql_free_result($rs);
			}
			mysql_free_result($sr);
		}
		mysql_free_result($r);
		print ".";
		
	}
	
	print "\n-> Transforming ... \n";
	$sql = "TRUNCATE TABLE lions.assignment_distinct_dc ";
	$db->actionQuery($sql);
	$sql = "INSERT INTO lions.assignment_distinct_dc(staffid,caseid,district) SELECT DISTINCT staffid, caseid, district FROM lions.assignment_distinct_dc_1 ";
	$db->actionQuery($sql);
	print "ok\n";
	
	print "\n\nYAY! I did it, and it only took " . number_format($db->queries(),0) . " queries!\n\n";

?>