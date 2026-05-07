{smcl}
{* *! version 1.2  07may2024}{...}
{title:Title}

{phang}
{bf:api} {hline 2} Modern JSON-to-Stata Bridge via isolated Python environments


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:api}
{cmd:,}
{opt url("string")}
[{opt key("string")}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:api} is a tool designed to import JSON data from web APIs. It solves the problem of complex, nested API responses by utilizing Python's {it:pandas.json_normalize}.

{pstd}
To ensure maximum reliability across different systems, this command avoids Stata's internal Python bridge and instead executes a dynamically generated script in a dedicated external shell.


{marker remarks}{...}
{title:Remarks}

{pstd}
{bf:Frames:} Data is loaded into a new Stata frame called {cmd:api_frame}. If this frame already exists, it will be replaced to ensure the latest data is available.

{pstd}
{bf:⚠️ Automatic Installation Notice:}
Upon the first execution, this command will automatically create a Python virtual environment ({cmd:api_env}) within your {cmd:PERSONAL} ado directory. 

{pstd}
It will automatically download and install the {it:pandas} and {it:requests} Python packages using pip. 

{pstd}
{bf:Security & Isolation:} These installations are strictly {bf:isolated} within the {cmd:api_env} folder. They do {bf:not} affect your global Python configuration or other installed software, ensuring a clean and safe "Plug & Play" experience.


{marker examples}{...}
{title:Examples}

{pstd}Fetch cryptocurrency data:{p_end}
{phang2}{cmd:. api, url("https://api.coincap.io/v2/assets")}{p_end}

{pstd}Fetch test user data:{p_end}
{phang2}{cmd:. api, url("https://jsonplaceholder.typicode.com/users")}{p_end}


{title:Author}

{pstd}Luca G.{p_end}