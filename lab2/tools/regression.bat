::========================================================================================
call clean.bat
::========================================================================================
call build.bat
::========================================================================================
cd ../sim

call run_test.bat 22375 4
call run_test.bat 88888 8
call run_test.bat 99999 3
call run_test.bat 52887 2
call run_test.bat 44444 14
call run_test.bat 74130 27
call run_test.bat 12876 3
call run_test.bat 99555 16
call run_test.bat 66777 46
call run_test.bat 22555 75

