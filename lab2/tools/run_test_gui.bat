<<<<<<< HEAD
=======
<<<<<<<< HEAD:lab2/tools/run_test_gui.bat
>>>>>>> master
::========================================================================================
call clean.bat
::========================================================================================
call build.bat
::========================================================================================
cd ../sim
<<<<<<< HEAD
:: vsim -gui -do run.do
vsim -gui -do "do run.do %1 %2"
=======
@REM vsim -gui -do run.do
vsim -gui -do "do run.do %1"
========
vsim -c -do "do run.do %1 %2"
>>>>>>>> master:lab2/tools/run_test.bat
>>>>>>> master
