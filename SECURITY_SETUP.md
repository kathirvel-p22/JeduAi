# 🔐 Security Setup Guide

## ⚠️ API Key Leaked - Action Required!

Your Gemini API key was exposed in the GitHub repository and has been blocked by Google.

---

## 🚨 Immediate Steps (Do This Now!)

### Step 1: Get a New API Key

1. **Go to Google AI Studio**: https://makersuite.google.com/app/apikey
2. **Delete the old key**: `AIzaSyC49FaAvNqbGtxXuTFsNJCAytSug9NO0lA`
3. **Create a new API key**
4. **Copy the new key**

### Step 2: Create Your Config File

1. **Copy the template file**:
   ```bash
   cd lib/config
   copy gemini_config.example.dart gemini_config.dart
   ```

2. **Open `gemini_config.dart`** in your editor

3. **Replace the placeholder** with your new API key:
   ```dart
   static const String apiKey = 'YOUR_NEW_API_KEY_HERE';
   ```
   Change to:
   ```dart
   static const String apiKey = 'AIzaSy...your-actual-key';
   ```

4. **Save the file**

### Step 3: Verify It's Protected

Check that `gemini_config.dart` is in `.gitignore`:
```bash
# This should show the file is ignored
git status
```

You should NOT see `lib/config/gemini_config.dart` in the list of files to commit.

---

## ✅ What We Fixed

1. ✅ Removed API key from Git repository
2. ✅ Added `gemini_config.dart` to `.gitignore`
3. ✅ Created template file (`gemini_config.example.dart`)
4. ✅ Pushed security fixes to GitHub

---

## 🔒 Security Best Practices

### DO ✅
- Keep API keys in local config files
- Use `.gitignore` to exclude config files
- Share template files (`.example.dart`)
- Regenerate keys if leaked
- Use environment variables for production

### DON'T ❌
- Commit API keys to Git
- Share API keys in public repositories
- Hardcode keys in source code
- Use the same key for dev and production
- Ignore security warnings

---

## 📝 For Team Members

If someone else clones your repository, they need to:

1. **Copy the template**:
   ```bash
   cp lib/config/gemini_config.example.dart lib/config/gemini_config.dart
   ```

2. **Get their own API key** from Google AI Studio

3. **Update the config file** with their key

4. **Never commit** `gemini_config.dart`

---

## 🔄 Current Status

### Protected Files (Not in Git)
- ✅ `lib/config/gemini_config.dart` - Your actual API key
- ✅ `lib/config/firebase_config.dart` - Firebase credentials
- ✅ `lib/config/supabase_config.dart` - Supabase credentials

### Template Files (In Git)
- ✅ `lib/config/gemini_config.example.dart` - Template for Gemini
- ℹ️ Create similar templates for Firebase and Supabase if needed

---

## 🚀 After Setting Up Your New Key

1. **Hot reload your app**: Press `r` in the terminal
2. **Test the AI features**:
   - Try generating an assessment
   - Test the translation feature
   - Use the AI Tutor

3. **Verify it works**:
   - You should see ✅ success messages
   - No more 403 errors
   - AI features working properly

---

## 📞 Need Help?

If you're still seeing errors:

1. **Check your API key is correct** in `gemini_config.dart`
2. **Verify the key is active** in Google AI Studio
3. **Check rate limits** (10 RPM, 250K TPM, 250 RPD)
4. **Hot reload the app** after changing the key

---

## 🎯 Summary

**What happened**: API key was exposed in public GitHub repository
**Impact**: Google blocked the key for security
**Solution**: Get new key, use template system, protect with .gitignore
**Status**: ✅ Repository is now secure, waiting for your new API key

---

**⚠️ Remember**: Never commit API keys to Git! Always use config templates and .gitignore.
