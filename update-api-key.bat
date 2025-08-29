@echo off
setlocal enabledelayedexpansion

echo 🔧 Updating APISIX configuration with API key from secrets...

rem Check if secrets file exists
if not exist "secrets.yaml" (
    echo ❌ Error: secrets.yaml not found!
    echo 📝 Please create secrets.yaml with your Google API key
    pause
    exit /b 1
)

rem Extract API key from secrets.yaml using findstr and for loop
for /f "tokens=2 delims=:" %%a in ('findstr "api_key:" secrets.yaml') do (
    set "raw_key=%%a"
)

rem Clean up the key (remove quotes and spaces)
set "api_key=!raw_key: =!"
set "api_key=!api_key:"=!"

if "!api_key!"=="" (
    echo ❌ Error: Could not extract API key from secrets.yaml
    echo 📝 Please check the format of your secrets.yaml file
    pause
    exit /b 1
)

echo ✅ Found API key: !api_key:~0,10!...

rem Update APISIX configuration using PowerShell (more reliable than batch for text replacement)
powershell -Command "(Get-Content 'apisix_conf\master\apisix.yaml') -replace 'REPLACE_WITH_YOUR_API_KEY', '!api_key!' | Set-Content 'apisix_conf\master\apisix.yaml'"

echo ✅ Configuration updated successfully!
echo 🚀 You can now start services with: docker-compose -f docker-compose-master.yaml up -d
pause
