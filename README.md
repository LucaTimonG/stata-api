# api.ado — The Modern JSON-to-Stata Bridge

![Stata](https://img.shields.io/badge/Stata-16+-blue.svg) ![Python](https://img.shields.io/badge/Python-3.x-green.svg) ![License](https://img.shields.io/badge/License-MIT-yellow.svg)

`api` is a high-performance, user-friendly Stata command designed to fetch, flatten, and import data from any public or authenticated web API directly into a separate Stata frame.

**What makes it unique:** It manages its own isolated Python environment directly within your Stata Personal folder. You never have to worry about Python dependencies or version conflicts on your system.

---

### 🌟 Key Features

* **Zero-Configuration**: Automatically creates a virtual environment (`venv`) in your Stata Personal directory.
* **Auto-Dependency Management**: Installs required libraries (`pandas`, `requests`) automatically on the first run.
* **Non-Destructive**: Loads data into a dedicated frame (`api_frame`), keeping your current dataset safe.
* **Smart Flattening**: Converts complex, nested JSON structures into a clean, tabular format using advanced normalization.
* **Windows Optimized**: Specifically built to handle Windows file paths and shell execution seamlessly.

---

### 📋 Requirements

To use `api`, ensure the following:

* **Stata 16 or higher**: Required for Frame support.
* **Python for Windows**: Must be installed and added to your system **PATH**.
* **Internet Access**: Required for the initial setup (to download packages) and for fetching API data.

---

### ⚙️ Installation

1. **Download** the `api.ado` file.
2. **Copy** it to your Stata **Personal** folder. 
   * *To find this path, type `sysdir` in Stata. Usually, it is: `C:\Users\YourName\ado\personal\`*
3. **Ready**: No further steps required.

---

### 💻 Usage

#### Basic Command
To fetch data from a public API:
```stata
api, url("[https://jsonplaceholder.typicode.com/users](https://jsonplaceholder.typicode.com/users)")
---
```
### 🔑 API Keys and Authentication
If an API requires an access key, you can pass it via the `key()` option:
```stata
api, url("[https://api.example.com/data](https://api.example.com/data)") key("your_secret_api_key")
---
```



🛠 Technical Workflow
When you run api, the following steps occur:

Environment Check: Stata verifies if a Python environment exists in ado/personal/webget_env.

Auto-Setup: If missing, Stata triggers python -m venv to build the local environment.

Dependency Check: A temporary Python script ensures pandas and requests are installed. If not, it runs pip install internally.

Data Retrieval: Python fetches the URL, flattens the JSON using pandas.json_normalize, and saves it as a CSV.

Import: Stata creates api_frame and imports the CSV data using UTF-8 encoding.

⚠️ Troubleshooting
Python environment not found: Ensure Python is installed from python.org and the "Add Python to PATH" box was checked during installation.

Network Errors: In corporate environments, firewalls may block the automatic download of Python packages. Contact your IT department if the initial setup fails.

Empty Data: Some APIs wrap data in root objects (e.g., {"status": "success", "data": [...]}). The command attempts to flatten the entire response.

📄 License
This project is licensed under the MIT License. You are free to use, modify, and distribute this software, provided that the original copyright notice is included.
