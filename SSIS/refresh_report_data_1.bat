"C:\Program Files (x86)\Microsoft SQL Server\110\DTS\Binn\dtexec.exe" /f "refresh_report_data.dtsx" ^
/SET "\"\package.Variables[connection_report_data].Value\"";"\"server=restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com;uid=postgres;password=;Database=sandbox_report_data;\"" 
