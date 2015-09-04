<?

/*

	LIONS UNPACK AND LOAD UTILITY
	Handles import and load

*/

	$dbhost = '';
	$dbuser = '';
	$dbpass = '';

	extract($_GET);
	extract($_POST);

	$sql_files = Array('sql/_lions.sql', '/lions/sql/_staff_summary.sql', '/lions/sql/_civilrights.sql');
	
	set_time_limit(60*60*24*7);

	echo "LIONS UPDATE AND LOAD UTILITY - Brad Heath - USA TODAY\n\n";
	
		// extract text data and prepare for load
		print "Extracting text data ... ";
		shell_exec("c:/lions/parse.bat");
		print "done\n\n";
	
	

	// re-create database and load text data
	$link = mysql_pconnect($dbhost, $dbuser, $dbpass);
	
	foreach($sql_files as $sql_file) {
		$commands = explode(';', file_get_contents($sql_file));
		print "Running SQL Commands from $sql_file : ";
		foreach($commands as $command) {
			mysql_query($command, $link);
			print ".";
			sleep(2);
		}
		print "done\n\n";
	}
	

	echo "\n\n## ------------------ ##\nLIONS Load Complete\n\n";



?>