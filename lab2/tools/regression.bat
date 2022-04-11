::========================================================================================
call clean.bat
::========================================================================================
call build.bat
::========================================================================================
cd ../sim

call run_test_c.bat 1111;
call run_test_c.bat 2222;
call run_test_c.bat 3333;
call run_test_c.bat 4444;
call run_test_c.bat 5555;
call run_test_c.bat 6666;
call run_test_c.bat 7777;
call run_test_c.bat 8888;
call run_test_c.bat 9999;
