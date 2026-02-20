## Project Title
Student Attendance Tracker

## Project Description
The project is design to build an environment with the use of shell script which will create the neccessary directory alongside with their files, enable the customization of settings through command line, and handle system signals in the cleanest way.

## table of contents

- Project Structure
- Files Description
- Project Features
- Essentials
- Step-by-step Installation
- Validation Check
- Signal Handling
- Error Handling
- License
- Author

## Project structure
attendance_tracker_${input}             # The parent directory of the project
 |-attendance_checker.py                # The main logic
 |-Helpers
 |    |-assets.csv                      # The student attendance data
 |    |-config.json                     # Contain the threshold
 |-reports
      |-reports.log                     # Contain the student attendance reports

## Files Description
 # attendance_checker.py
  - It is the main logic. 
  - It reads the configuration from the Helpers/config.json
  - It analyse the attendance data from the Helpres/assets.csv
  - It creates alerts according to the values of the thresholds
  - It log the results to the reports/reports.log

 # Helpers
 - Contain the assets.csv and the config.json
 
 # Helpers/assets.csv
 - Emails of the students
 - Names of the students
 - Number of absence as well as number of attendance

 # Helpers/config.json
 - Warning and failure threshold
 - Total number of sessions
 - Run mode

 # reports
 - Contain the reports.log

 # reports/reports.log
 - Generate log files having the attendance of the student, the alerts sent to the student and the timestamp of the report.


## Essentials
 - Bash shell environment (Shebang)
 - Python3

## Step-by-step Installation
 # Cloning of the repository 
   Use the command git clone https://github.com/DTounda/deploy_agent_DTounda.git
   Then locally enter into the Repo using the command cd deploy_agent_DTounda.git
 # Run the shell script
   bash setup_project.sh

 # Follow the instructions prompted 
  - The script will require from you enter the project name of your choice, then ask if you want to modify the thresholds. If yes it will prompt you to enter your desire warning and failure thresholds otherwise it will apply the default thresholds.

## An example of who the shell script will run
   bash setup_project.sh
    Congratulations, the version currently installed on the system is python3
    Enter any project name of your choice
    venus

    Do you want to modify the values of warning and failure threshold?
    Enter either y for yes and n for no:
    y

    Enter the Warning threshold (default 75):
    70
    Enter the Failure threshold (default 50):
    60

    Directory attendance_tracker_${input} exists
    Configuration complete successfully! Everything was successfully created at: attendance_tracker_${input}

## Validation check
   - Inputs of warning and failure threshold should be numeric data and should be between the range of 0-100
   - The values of failure must be less that the values of warning else the system will print and error prompting the user to adjust the values

## Signals Handling
   Catches the SIGINT signal, compress the file and place it in an achive then remove incomplete directory and exits gracefully

## Example of signals handling
   bash setup_project.sh
    Enter any project name of your choice
    mars
    ^C

## Errors Handling
   - If the user does not have python3 the system will print a warning message but will still continue to run
   - If the values of warning and failure are not numeric, the user will be prompted to enter numeric values in the range specify
   - If directory already exist with that same directory name, change the directory name.


## License
The project is for educational purpose.

## Author
Dorcase Lesly Nana Tounda
GitHub: https://github.com/DTounda/deploy_agent_DTounda.git



Link to the video: https://youtu.be/He87bJaZk3g



