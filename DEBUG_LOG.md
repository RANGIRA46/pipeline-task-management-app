# 🛠️ CI/CD Debugging Log

**Date**: 2025-11-21 20:05
**Status**: Debugging in progress 🐞

---

## 🚨 Identified Issues

### 1. Backend Dockerfile CMD Path (FIXED)
- **Issue**: `infra/docker/backend.Dockerfile` was trying to run `dist/index.js`.
- **Reality**: The compiled file is `dist/server.js` (based on `package.json`).
- **Fix**: Updated CMD to `["node", "dist/server.js"]`.
- **Status**: Committed, waiting for push.

### 2. GitHub Actions Workflow - Cache Error
- **Issue**: `Error: Some specified paths were not resolved, unable to cache dependencies.`
- **Cause**: CI cannot find `backend/package-lock.json` or `frontend/package-lock.json`.
- **Investigation**: Checking if these files are tracked by git.
- **Action**: If missing from git, will add them. If present, `git pull` + `git push` should sync state.

### 3. Git Sync
- **Issue**: Push rejected because local is behind remote.
- **Action**: Running `git pull origin main` to merge remote changes.

---

## 🧪 Local Verification

- [x] `npm ci` (Backend) - Started
- [x] `npm ci` (Frontend) - Started
- [ ] `npm test` (Backend) - In progress
- [ ] `npm run lint` (Backend) - In progress
- [ ] `npm run build` (Backend) - In progress
- [ ] `npm run build` (Frontend) - In progress

---

## 🚀 Next Steps

1. **Approve Git Push**: Send the Dockerfile fix to GitHub.
2. **Monitor CI**: Watch the new workflow run.
3. **Verify Azure**: Continue with Terraform deployment once CI is green.

---
