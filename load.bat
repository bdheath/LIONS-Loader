@cls
@echo  ======== LIONS Download Routine ======================================
@if "%1"=="" goto blank
@if "%1"=="nodownload" goto load:
@download.py %1

:LOAD
@c:\xampp\php\php.exe load.php
@goto done

:BLANK
@echo   ERROR!!!
@echo   REQUIRED USAGE IS "load.bat [month]"
@echo   OR, if data downloaded already, USAGE IS "load.bat nodownload"
@echo  ======================================================================
@goto end

:DONE
@echo  ======== LIONS LOAD COMPLETE =========================================

:END
