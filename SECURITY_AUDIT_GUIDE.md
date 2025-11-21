# 🔒 Security Audit Guide

## Running Security Audits

### Quick Commands

#### Check for vulnerabilities:
```bash
# Backend
cd backend
npm audit

# Frontend  
cd frontend
npm audit
```

#### Fix vulnerabilities automatically:
```bash
# Backend
cd backend
npm audit fix

# Frontend
cd frontend
npm audit fix
```

#### Force fix (includes breaking changes):
```bash
# Use with caution - may break compatibility
npm audit fix --force
```

---

## Easy Way - Use the Script

Run: **`install-with-audit.bat`**

This will:
1. ✅ Install all dependencies
2. ✅ Run `npm audit fix` on both projects
3. ✅ Generate audit reports
4. ✅ Show summary of vulnerabilities

---

## Understanding Audit Levels

| Level | Severity | Action |
|-------|----------|--------|
| **INFO** | Informational | Monitor, no immediate action |
| **LOW** | Minor issue | Fix when convenient |
| **MODERATE** | Should fix | Fix soon |
| **HIGH** | Important | Fix ASAP |
| **CRITICAL** | Severe | Fix immediately |

---

## Common npm audit Commands

```bash
# View audit report
npm audit

# Fix automatically (safe fixes only)
npm audit fix

# Fix with breaking changes
npm audit fix --force

# Audit report in JSON
npm audit --json

# Audit production dependencies only
npm audit --production

# View detailed audit report
npm audit --verbose
```

---

## What npm audit fix Does

### Automatic Fixes (Safe)
- Updates dependencies to patched versions
- Only makes changes within semver ranges
- Won't break your app

### Force Fixes (--force)
- Updates to latest versions (may break)
- Ignores semver ranges
- Use with caution!

---

## Handling Vulnerabilities

### 1. Low/Moderate Vulnerabilities
- Run `npm audit fix`
- Most will be fixed automatically

### 2. High/Critical Vulnerabilities
- Try `npm audit fix` first
- If still present, consider `npm audit fix --force`
- Test your app after force fixing!

### 3. Unfixable Vulnerabilities
Some vulnerabilities can't be fixed because:
- No patch available yet
- Dependency hasn't updated
- Breaking change required

**Options:**
- Document in `.trivyignore` with justification
- Find alternative package
- Accept the risk (if low impact)
- Wait for upstream fix

---

## Example Workflow

```bash
# 1. Check current status
cd backend
npm audit

# 2. Try safe fixes
npm audit fix

# 3. Check remaining issues
npm audit

# 4. If critical issues remain, force fix
npm audit fix --force

# 5. Test the application
npm test
npm run dev

# 6. Repeat for frontend
cd ..\frontend
npm audit
npm audit fix
npm test
```

---

## Documenting Exceptions

If you must accept a vulnerability, document it:

**File**: `security/.trivyignore`

```
# [Package Name] - [CVE ID if available]
# Justification: Reason why this is accepted
# Risk: Low/Medium/High
# Mitigation: What steps were taken to reduce risk
# Review Date: When this will be reviewed again

# Example:
# vue-template-compiler - CVE-2021-XXXXX
# Justification: Only used in development, not in production bundle
# Risk: Low - Development dependency only
# Mitigation: Not exposed to production environment
# Review Date: 2025-12-01
```

---

## CI/CD Integration

Your CI pipeline should include:

```yaml
# .github/workflows/security.yml
jobs:
  security-audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - name: Audit Backend
        run: |
          cd backend
          npm audit --audit-level=high
      - name: Audit Frontend
        run: |
          cd frontend
          npm audit --audit-level=high
```

---

## Best Practices

1. **Regular Audits**: Run `npm audit` weekly
2. **Before Deploying**: Always audit before production deployment
3. **Keep Updated**: Regularly update dependencies
4. **Review Changes**: Check what `npm audit fix` changes
5. **Test After Fixing**: Always test after running audit fix
6. **Document Exceptions**: Explain why vulnerabilities are accepted
7. **Monitor**: Set up Dependabot or similar tools

---

## Automated Tools

### GitHub Dependabot
- Automatically creates PRs for dependency updates
- Free for public repositories
- Enable in GitHub repository settings

### npm audit in CI
- Fail builds on high/critical vulnerabilities
- Included in Phase 3 CI pipeline

### Snyk
- More detailed vulnerability scanning
- Free tier available
- Integrates with GitHub

---

## Current Project Status

Your project includes:
- ✅ ESLint for code quality
- ✅ TypeScript for type safety
- ✅ Parameterized SQL queries (prevents injection)
- ✅ Non-root Docker users
- ✅ Security headers in Nginx
- 🔄 npm audit (you're running this now!)
- 📋 CI/CD security scanning (Phase 3)

---

## Quick Reference

| Task | Command |
|------|---------|
| Check vulnerabilities | `npm audit` |
| Fix safe issues | `npm audit fix` |
| Force fix all | `npm audit fix --force` |
| Install with audit | `install-with-audit.bat` |
| View details | `npm audit --verbose` |
| Production only | `npm audit --production` |

---

## Troubleshooting

### "npm audit requires package-lock.json"
```bash
npm install
# This generates package-lock.json
```

### "No vulnerabilities found"
✅ Great! Your dependencies are secure.

### "8 vulnerabilities (2 high, 6 moderate)"
Run `npm audit fix` to fix most of them.

### "Found X vulnerabilities (Y require manual review)"
Check `npm audit` output for details on each vulnerability.

---

**Run `install-with-audit.bat` to get started with security checks!** 🔒
