#!/bin/bash
# This master shell script containing the logic for directory creation, file generation, sed manipulation, and the trap function.


cleanup_file() {
  if [ -n "$input" ] && [ -d "attendance_tracker_${input}" ]; then
    tar -czf attendance_tracker_${input}_archive.tar.gz attendance_tracker_${input} 2>/dev/null
    rm -rf attendance_tracker_${input}
  fi
}

trap cleanup_file SIGINT


if python3 --version > /dev/null 2>&1
then
	echo "Congratulations, the version currently installed on the system is python3"
else
	echo "Be careful the version currently installed on this system is not python3"
fi

echo "Enter any project name of your choice"
read input

if [ -d "attendance_tracker_${input}" ]; then
    echo "Error directory already exists!"
    exit 1
fi

echo "Do you want to modify the values of warning and failure threshold?"
echo "Enter either y for yes and n for no:"
read answer

if [ "$answer" == "y" ] || [ "$answer" == "Y" ]
then

	echo "Enter the Warning threshold (default 75):"

	read warning

	echo "Enter the Failure threshold (default 50):"

	read failure
	


	if [ -z "$warning" ]

	then
	
		echo "Default value 75 is applied."
	
		warning="75"

	fi

	if [ -z "$failure" ]

	then
	
		echo "Default value 50 is applied."
	
		failure="50"

	fi

	if ! [[ $warning =~ ^[0-9]+$ ]] || [ "$warning" -lt 0 ] || [ "$warning" -gt 100 ]

	then
        
		echo "Enter a value in number form"
        
		exit 1

	fi


	if ! [[ $failure =~ ^[0-9]+$ ]] || [ "$failure" -lt 0 ] || [ "$failure" -gt 100 ]

	then
        
		echo "Enter a value in number form"
        
		exit 1

	fi

else 
	echo "The default warning and failutre thresholds will be applied"
	warning="75"
	failure="50"
fi

mkdir attendance_tracker_${input} || { echo "Error: Was not able to create directory"; exit 1; }
mkdir -p attendance_tracker_${input}/Helpers || { echo "Error: Was not able to create folder"; exit 1; }
mkdir -p attendance_tracker_${input}/reports || { echo "Error: Was not able to create folder"; exit 1; }

cat > attendance_tracker_${input}/attendance_checker.py << 'EOF'
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    # 1. Load Config
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)

    # 2. Archive old reports.log if it exists
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

    # 3. Process Data
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']

        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")

        for row in reader:
            name = row['Names']
            email = row['Email']
            attended = int(row['Attendance Count'])

            # Simple Math: (Attended / Total) * 100
            attendance_pct = (attended / total_sessions) * 100

            message = ""
            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."

            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()
EOF
cat > attendance_tracker_${input}/Helpers/assets.csv << 'EOF'
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
EOF
cat > attendance_tracker_${input}/reports/reports.log << 'EOF'
--- Attendance Report Run: 2026-02-06 18:10:01.468726 ---
[2026-02-06 18:10:01.469363] ALERT SENT TO bob@example.com: URGENT: Bob Smith, your attendance is 46.7%. You will fail this class.
[2026-02-06 18:10:01.469424] ALERT SENT TO charlie@example.com: URGENT: Charlie Davis, your attendance is 26.7%. You will fail this class.
EOF
cat > attendance_tracker_${input}/Helpers/config.json << 'EOF'
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
EOF
sed -i "s/\"failure\": [0-9]*/\"failure\": $failure/" attendance_tracker_${input}/Helpers/config.json
sed -i "s/\"warning\": [0-9]*/\"warning\": $warning/" attendance_tracker_${input}/Helpers/config.json

if [ -d attendance_tracker_${input} ]
then
	echo "Directory attendance_tracker_${input} exists"
else
	echo "Error file missing"
fi

if [ -d attendance_tracker_${input}/Helpers ]
then
	echo "Subdirectory attendance_tracker_${input}/Helpers exists"
else
	echo "Error file missing"
fi

if [ -d attendance_tracker_${input}/reports ]
then
        echo "Subdirectory attendance_tracker_${input}/reports exists"
else
	echo "Error file missing"
fi

if [ -f attendance_tracker_${input}/attendance_checker.py ]
then
        echo "File attendance_tracker_${input}/attendance_checker.py exists"
else
	echo "Error file missing"

fi

if [ -f attendance_tracker_${input}/Helpers/config.json ]
then
        echo "File attendance_tracker_${input}/Helpers/config.json exists"
else
	echo "Error file missing"

fi

if [ -f attendance_tracker_${input}/Helpers/assets.csv ]
then
        echo "File attendance_tracker_${input}/Helpers/assets.csv exists"
else
	echo "Error file missing"

fi

if [ -f attendance_tracker_${input}/reports/reports.log ]
then
	echo "File attendance_tracker_${input}/reports/reports.log exists"
else
	echo "Error file missing"

fi

echo "Configuration complete successfully! Everything was successfully created at: attendance_tracker_${input}"
