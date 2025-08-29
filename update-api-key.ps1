# Simple PowerShell script to inject API key from secrets.yaml into apisix.yaml
# Run this before starting Docker services

$secretsFile = "secrets.yaml"
$configFile = "apisix_conf\master\apisix.yaml"

Write-Host "🔧 Updating APISIX configuration with API key from secrets..." -ForegroundColor Green

# Check if secrets file exists
if (-not (Test-Path $secretsFile)) {
    Write-Host "❌ Error: $secretsFile not found!" -ForegroundColor Red
    Write-Host "📝 Please create $secretsFile with your Google API key" -ForegroundColor Yellow
    exit 1
}

# Read secrets file and extract API key
$secretsContent = Get-Content $secretsFile -Raw
if ($secretsContent -match 'api_key:\s*["\']?([^"\'\r\n]+)["\']?') {
    $apiKey = $matches[1].Trim()
    Write-Host "✅ Found API key: $($apiKey.Substring(0, [Math]::Min(10, $apiKey.Length)))..." -ForegroundColor Green
    
    # Update APISIX configuration
    $configContent = Get-Content $configFile -Raw
    $updatedConfig = $configContent -replace 'REPLACE_WITH_YOUR_API_KEY', $apiKey
    Set-Content $configFile $updatedConfig
    
    Write-Host "✅ Configuration updated successfully!" -ForegroundColor Green
    Write-Host "🚀 You can now start services with: docker-compose -f docker-compose-master.yaml up -d" -ForegroundColor Cyan
} else {
    Write-Host "❌ Error: Could not extract API key from $secretsFile" -ForegroundColor Red
    Write-Host "📝 Please check the format of your secrets.yaml file" -ForegroundColor Yellow
    exit 1
}
