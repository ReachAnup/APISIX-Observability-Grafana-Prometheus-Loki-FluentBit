# 🔐 API Key Management Solution

This setup provides a **secure** way to manage API keys for your APISIX observability stack.

## 🚨 **SECURITY NOTICE**
- ⚠️ **NEVER commit `secrets.yaml` to Git** - This file contains your actual API keys
- ⚠️ **NEVER commit `.env` files** - These may contain sensitive environment variables  
- ✅ **Always use the provided scripts** - They ensure keys are injected securely
- ✅ **Use placeholders in config files** - Keep `REPLACE_WITH_YOUR_API_KEY` in committed files

## 📁 Files Structure

### `secrets.yaml` 
Contains your API keys (🚨 **NEVER commit this file to git**):
```yaml
google:
  api_key: "YOUR_ACTUAL_API_KEY_HERE"
```

### `.gitignore`
Updated to exclude sensitive files:
```
# Environment and secrets
secrets.yaml
.env
*.env
```

## 🚀 How to Use

### 1. **Setup (One-time)**
Create your secrets file:
```bash
notepad secrets.yaml
```

Add your API key in this format:
```yaml
google:
  api_key: "YOUR_ACTUAL_GOOGLE_API_KEY_HERE"
```

### 2. **Update Configuration (Run before starting services)**

**Option A: PowerShell (Recommended)**
```powershell
.\update-api-key.ps1
```

**Option B: Batch Script**
```cmd
update-api-key.bat
```

**Option C: Manual**
1. Open `apisix_conf\master\apisix.yaml`
2. Find this line: `X-goog-api-key: "REPLACE_WITH_YOUR_API_KEY"`
3. Replace `REPLACE_WITH_YOUR_API_KEY` with your actual API key from `secrets.yaml`

### 3. **Start Services**
```bash
docker-compose -f docker-compose-master.yaml up -d
```

## ✅ Working Endpoints

- **🟢 http://localhost:9080/hello** - Mock AI service
- **🟢 http://localhost:9080/health** - Health check
- **🔵 http://localhost:9080/hello-gemini** - Gemini AI proxy (with your API key)

## 🔄 Simple Approach

This solution provides multiple ways to update the API key:

1. **🚀 Automated Scripts**: 
   - `update-api-key.ps1` (PowerShell - recommended)
   - `update-api-key.bat` (Batch script)
   
2. **📝 Manual Method**: Direct editing of configuration files

Both scripts:
- Read API key from `secrets.yaml` (git-ignored)
- Automatically update `apisix_conf/master/apisix.yaml`
- Simple and reliable approach

## 🛡️ Security Notes

1. ✅ `secrets.yaml` is in `.gitignore` - won't be committed
2. ✅ API keys are only stored locally
3. ✅ Configuration is persistent across container restarts
4. ✅ Simple and reliable approach

## 🐛 Troubleshooting

- If routes return 404: Check APISIX container logs with `docker logs apisix-observability-stack-apisix-1`
- If API key not working: Verify the key format in `secrets.yaml` matches the template
- If services won't start: Ensure all volumes are properly mounted in `docker-compose-master.yaml`
