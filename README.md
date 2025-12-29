# How to Deploy SillyTavern on Zeabur (Complete Beginner's Guide)

This guide will walk you through deploying SillyTavern on Zeabur from scratch. No prior experience needed!

---

## What You'll Need
- A GitHub account (free): https://github.com
- A Zeabur account (free tier available): https://zeabur.com

---

## Part 1: Create Your GitHub Repository

### Step 1: Create a New Repository
1. Go to https://github.com/new
2. Fill in:
   - **Repository name:** `sillytavern-zeabur` (or any name you like)
   - **Description:** (optional) "My SillyTavern deployment"
   - **Visibility:** Choose **Private** (recommended for security)
3. Check ✅ **Add a README file**
4. Click **Create repository**

### Step 2: Create the `startup.sh` File
1. In your new repository, click **Add file** → **Create new file**
2. Name it: `startup.sh`
3. Paste this content:

```sh
#!/bin/sh
set -e

echo "Generating config.yaml..."
cat > /home/node/app/config/config.yaml << EOF
listen: true
port: 8080
whitelistMode: false
basicAuthMode: true
basicAuthUser:
  username: "${BASIC_USER:-admin}"
  password: "${BASIC_PASS:-changeme}"
enableUserAccounts: false
securityOverride: false
autorun: false
enableCorsProxy: false
allowKeysExposure: false
EOF

echo "Config generated. Starting SillyTavern..."
exec node server.js --configPath /home/node/app/config/config.yaml --dataRoot /home/node/app/data
```

4. Click **Commit changes** (green button)
5. Click **Commit changes** again in the popup

### Step 3: Create the `Dockerfile`
1. Click **Add file** → **Create new file**
2. Name it: `Dockerfile` (exactly like this, no extension)
3. Paste this content:

```dockerfile
FROM ghcr.io/sillytavern/sillytavern:latest

USER root

RUN mkdir -p /home/node/app/config /home/node/app/data

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

ENTRYPOINT ["/startup.sh"]
```

4. Click **Commit changes** (green button)
5. Click **Commit changes** again in the popup

✅ **Your GitHub repository is ready!** You should now have 3 files:
- `README.md`
- `startup.sh`
- `Dockerfile`

---

## Part 2: Set Up Zeabur

### Step 1: Create an Account & Project
1. Go to https://zeabur.com
2. Sign up or log in (you can use your GitHub account)
3. Click **New Project**
4. Choose a region close to you (e.g., Singapore, US West)
5. Name your project (e.g., "SillyTavern")

### Step 2: Connect Your GitHub Repository
1. In your project, click **+ Add Service**
2. Choose **Git - Deploy your source code**
3. Select **GitHub**
4. Authorize Zeabur to access your repositories if prompted
5. Find and select your `sillytavern-zeabur` repository
6. Click **Deploy**

> ⏳ The first deployment will start but will fail. This is expected! We need to add variables and volumes first.

### Step 3: Add Environment Variables
This is where you set your login password.

1. Click on your service (the box that appeared)
2. Go to the **Variables** tab
3. Click **Add Variable** and add these one by one:

| Key | Value | Notes |
|-----|-------|-------|
| `BASIC_USER` | `admin` | Your login username |
| `BASIC_PASS` | `YourSecretPassword123!` | **⚠️ Use a STRONG password!** |

> 🔒 **Security Note:** Never use simple passwords like "1234" or "password". Anyone who finds your URL can try to log in!

### Step 4: Add Storage Volumes
Volumes keep your data (chats, characters, settings) safe even if the container restarts.

1. Go to the **Volumes** tab (or Storage/Disk tab)
2. Click **Add Volume** and create these:

| Mount Path | Volume Name |
|------------|-------------|
| `/home/node/app/config` | `st-config` |
| `/home/node/app/data` | `st-data` |

### Step 5: Set Up Networking (Get Your URL)
1. Go to the **Networking** tab
2. Click **Add Domain**
3. Choose one of these options:
   - **Zeabur subdomain** (free): Click "Generate" to get something like `myapp-xyz.zeabur.app`
   - **Custom domain**: Enter your own domain if you have one
4. Make sure the port is set to `8080`

### Step 6: Redeploy
1. Go to the **Deployments** tab
2. Click **Redeploy** (or **Restart**)
3. Wait 2-5 minutes for the deployment to complete

---

## Part 3: Access Your SillyTavern

1. Go to your Zeabur domain (the URL from Step 5)
2. A login popup will appear
3. Enter:
   - **Username:** The value you set for `BASIC_USER` (e.g., `admin`)
   - **Password:** The value you set for `BASIC_PASS`
4. Click **Sign In**

🎉 **Congratulations!** You now have SillyTavern running in the cloud!

---

## Troubleshooting

### Problem: Container keeps getting "Killed" or "BackOff"
**Solution:** 
1. Delete both volumes in Zeabur
2. Recreate them with the same paths
3. Redeploy

### Problem: "401 Unauthorized" or wrong password
**Solution:**
1. Check your `BASIC_USER` and `BASIC_PASS` variables in Zeabur
2. Make sure there are no extra spaces before/after the values
3. Delete the `/home/node/app/config` volume, recreate it, and redeploy

### Problem: "Forbidden" error
**Solution:** This usually means whitelistMode is enabled. Make sure your `startup.sh` file has `whitelistMode: false`

### Problem: Deployment stuck on "Pulling"
**Solution:** This is normal! The first pull can take 2-5 minutes. Just wait.

---

## How to Update SillyTavern

When a new version of SillyTavern is released:
1. Go to Zeabur
2. Click on your service
3. Go to **Deployments** tab
4. Click **Redeploy**

The `FROM ghcr.io/sillytavern/sillytavern:latest` line in your Dockerfile will automatically pull the newest version.

---

## How to Change Your Password

1. Go to Zeabur → your service → **Variables** tab
2. Edit the `BASIC_PASS` value
3. Click **Redeploy**

---

## Summary: What Each File Does

| File | Purpose |
|------|---------|
| `Dockerfile` | Tells Zeabur how to build your container |
| `startup.sh` | Creates the config file and starts SillyTavern with authentication enabled |

---

## FAQ

**Q: Is this free?**
A: Zeabur has a free tier with limited resources. For personal use, it's usually enough. Check their pricing for details.

**Q: Is my data safe?**
A: Your data is stored in the volumes. As long as you don't delete them, your chats and characters are safe.

**Q: Can I use this on mobile?**
A: Yes! Just visit your Zeabur URL on any browser.

**Q: How do I backup my data?**
A: Currently, you'd need to download backups from within SillyTavern's settings menu.

