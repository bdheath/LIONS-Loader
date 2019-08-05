<?

/*

	LIONS UNPACK AND LOAD UTILITY
	Handles import and load

*/

	extract($_GET);
	extract($_POST);
	
	$options = getopt("s:");
	if($options[s] == 'nodownload') {
		$nodownload = true; 
		}
		

	set_time_limit(60*60*24*7);

	echo "LIONS UPDATE AND LOAD UTILITY - Brad Heath - USA Today\n\n";
	if($nodownload) { 
		echo "(Script will assume text already exists)\n\n"; 
	}

	// ask user for current month
	if(!$nodownload) {
		shell_exec("start http://www.justice.gov/usao/reading_room/data/CaseStats.htm");
		fwrite(STDOUT, "What is the most recent month for data? ");
		$month = trim(fgets(STDIN));
		fwrite(STDOUT, "Fetching $month\n");
		
		// download data
		for($i = 1; $i <= 10; $i++) {
	
			$filename = "DISK" . $i . ".ZIP";
			$url = "http://www.justice.gov/usao/reading_room/data/$month" . "_Current_FY/" . $filename;
			$local = "c:/lions/$filename";
			print "   - Getting $filename ... ";
			$fIn = fopen($url,"rb");
			$fOut = fopen($local,"wb");
			while(!feof($fIn)) {
				$c = fgets($fIn, 4096);
				fwrite($fOut,$c);
			}
			fclose($fIn); fclose($fOut);
			print "ok\n";
		}
	
		echo "\n\nLoading - This will take some time ... \n\n";
	
		// extract text data and prepare for load
		print "Extracting text data ... ";
		shell_exec("c:/lions/parse.bat");
		print "done\n\n";
	
	}

	// re-create database and load text data
	$link = mysql_pconnect("localhost","root","spunky");
	$commands = explode(';', file_get_contents('c:/lions/sql/_lions.sql'));
	print "Running SQL Commands ";
	foreach($commands as $command) {
		mysql_query($command, $link);
		print ".";
	}
	print "done\n\n";
	
	// build first assignment table
	include("c:/xampp/php/lions-assignment-dc.php");
	
	// build second assignment table
	include("c:/xampp/php/lions-assignment-dc-l.php");

	// build staff summary
	$link = mysql_pconnect("localhost","root","spunky");
	$commands = explode(';', file_get_contents('c:/lions/sql/_staff_summary.sql'));
	print "Running SQL Commands ";
	foreach($commands as $command) {
		mysql_query($command, $link);
		print ".";
	}
	print "done\n\n";
	
	// jury trial summary
	include("c:/xampp/php/lions-case-summary-jtri.php");
	
	echo "\n\n## ------------------ ##\nLIONS Load Complete\n\n";



?>