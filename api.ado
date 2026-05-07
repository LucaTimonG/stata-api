program define api
version 16.0
syntax , url(string) [key(string)]



// 1. Resolve paths
local personal `"`c(sysdir_personal)'"'
local tmp_dir  `"`c(tmpdir)'"'

local personal = subinstr("`personal'", "/", "\", .)
local tmp_dir  = subinstr("`tmp_dir'", "/", "\", .)

if substr("`personal'", -1, 1) != "\" local personal "`personal'\"
if substr("`tmp_dir'", -1, 1) != "\" local tmp_dir "`tmp_dir'\"

local env_folder `"`personal'api_env"'
local py_exec    `"`env_folder'\Scripts\python.exe"'
local py_file    `"`tmp_dir'api_script.py"'
local csv_file   `"`tmp_dir'api_data.csv"'

// 2. CHECK: Does the environment exist? If not, create it
capture confirm file "`py_exec'"
if _rc != 0 {
    display as text "Initial Setup: Creating Python environment in `env_folder'..."
    display as text "This may take a minute (only happens once)..."
    
    // Create the virtual environment using the system's default python
    // This assumes the user has Python installed on their Windows system
    shell python -m venv "`env_folder'"
    
    // Double check if it worked
    capture confirm file "`py_exec'"
    if _rc != 0 {
        display as error "ERROR: Could not create Python environment."
        display as error "Make sure Python is installed on your Windows system and added to PATH."
        exit 198
    }

    display as success "Environment created successfully."
}

// 3. Generate the temporary Python script with AUTO-INSTALL logic for packages
capture file close pyout
quietly {
    file open pyout using `"`py_file'"', write replace
    file write pyout "import sys, subprocess" _n
    file write pyout "def check_and_install(pkg):" _n
    file write pyout "    try: __import__(pkg)" _n
    file write pyout "    except ImportError:" _n
    file write pyout "        subprocess.check_call([sys.executable, '-m', 'pip', 'install', pkg])" _n
    
    file write pyout "check_and_install('pandas')" _n
    file write pyout "check_and_install('requests')" _n

    file write pyout "import pandas as pd, requests" _n
    file write pyout "try:" _n
    file write pyout "    r = requests.get(sys.argv[1], timeout=10)" _n
    file write pyout "    r.raise_for_status()" _n
    file write pyout "    pd.json_normalize(r.json()).to_csv(sys.argv[2], index=False, encoding='utf-8')" _n
    file write pyout "except Exception as e: print(e)" _n
    file close pyout
}



// 4. Execute Python via the shell
shell "`py_exec'" "`py_file'" "`url'" "`csv_file'"

// 5. Import the resulting CSV
capture confirm file `"`csv_file'"'

if _rc == 0 {
    capture frame change default
    capture frame drop api_frame
    frame create api_frame
    frame change api_frame
    quietly import delimited `"`csv_file'"', clear encoding("utf-8")

    quietly capture erase `"`py_file'"'
    quietly capture erase `"`csv_file'"'

    display "---"
    display "SUCCESS: Data loaded into 'api_frame'"
    display "---"

}
else {
    display as error "ERROR: Python failed to produce data."
    quietly capture erase `"`py_file'"'
}
end