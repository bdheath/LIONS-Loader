# Download script for LIONS case management data

import os, sys, urllib2
import multiprocessing

NUMFILES = 25

numProcesses = 4
multitask = True

def GetLionsSegment(i,month):
	filename = 'DISK' + str(i) + '.zip'
	# old URL format (script updated in Jan. 2015)
	# url = "http://www.justice.gov/usao/reading_room/data/" + month + "_Current_FY/" + filename
	url = "http://media.justice.gov/video/usao/data/" + month + "_Current_FY/" + filename
	try:
		urllib2.urlopen(url)
	except:
		filename = 'DISK' + str(i).zfill(2) + '.zip'
		url = "http://media.justice.gov/video/usao/data/" + month + "_Current_FY/" + filename
	
	localfile = '/lions/' + filename
	SmartDownload(url,localfile)

def SmartDownload(url,localfile):
	try:
		usock = urllib2.urlopen(url)
		remoteSize = float(usock.info().get('Content-Length'))
		remoteSizeStr = str(usock.info().get('Content-Length'))
	except:
		print "ERROR: Could not open remote file: " + url
	print "  <- downloading to " + localfile + " (" + remoteSizeStr + " bytes)"
	localSize = 0
	while True:
		DownloadFile(url,localfile)
		localSize = os.path.getsize(localfile)
		print "     - Downloaded " + str(localSize) + " bytes to " + localfile
		if localSize >= remoteSize:
			break
		else:
			print "## FAILED - " + localfile + " starting again ..."
	
def DownloadFile(url, fpath):
	request = urllib2.Request(url)
	urlfile = urllib2.urlopen(request)
	chunk = 4096 * 2
	f = open(fpath, "wb")
	while 1:
		data = urlfile.read(chunk)
		if not data:
			break
		f.write(data)
		
if __name__ == '__main__':
#	month = raw_input("Month: ")
	if len(sys.argv) == 1:
		print "ERROR: You need to specify the month. USAGE: download.py [month]"
	else:
		print "LIONS Downloader"
		month = sys.argv[1]
		pool = multiprocessing.Pool(processes=numProcesses)
		for i in range(1,NUMFILES + 1):
			if multitask:
				pool.apply_async(GetLionsSegment, args=(i, month))
			else:
				GetLionsSegment(i, month)
		pool.close()
		pool.join()