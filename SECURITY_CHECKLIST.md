# 🛡️ Security Pre-Commit Checklist

**ALWAYS run this checklist before committing to GitHub:**

## ✅ **Required Security Checks**

### **1. API Keys Removed from Config Files**
- [ ] `apisix_conf/master/apisix.yaml` contains `REPLACE_WITH_YOUR_API_KEY` (not actual key)
- [ ] No actual API keys in any `.yaml`, `.json`, or `.md` files

### **2. Secrets Files Are Git-Ignored**
- [ ] `secrets.yaml` is listed in `.gitignore`
- [ ] `.env` files are listed in `.gitignore`
- [ ] `secrets.yaml` exists locally but won't be committed

### **3. Documentation Updated**
- [ ] `README.md` has clear setup instructions
- [ ] `API_KEY_MANAGEMENT.md` is up to date
- [ ] No actual API keys in documentation examples

### **4. Scripts Are Functional**
- [ ] `update-api-key.ps1` works correctly
- [ ] `update-api-key.bat` works correctly
- [ ] Scripts read from `secrets.yaml` and update config properly

## 🔍 **Quick Security Scan**

Run this command to check for any remaining API keys:
```bash
grep -r "AIzaSy" . --exclude-dir=.git --exclude="secrets.yaml" --exclude=".env"
```

**Result should be empty!** If any files show up, clean them before committing.

## 🚀 **Safe to Commit If:**
- ✅ All checklist items are complete
- ✅ Security scan returns no results
- ✅ `secrets.yaml` exists locally but is git-ignored
- ✅ All config files use placeholders only

## ⚠️ **NEVER Commit:**
- ❌ `secrets.yaml` - Contains actual API keys
- ❌ `.env` files - May contain sensitive variables
- ❌ Any file with actual API keys
- ❌ Log files with sensitive data
