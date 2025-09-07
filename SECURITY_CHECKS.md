# Security Check System Documentation

## Overview

The AI-BernerModell-Toolkit includes a comprehensive security checking system that validates frontend security best practices for this HTML/JavaScript project.

## Usage

### Primary Command (matching the request)
```bash
make s-securityx-check
```

### Alternative Commands
```bash
make security-check      # Full security audit
make help               # Show all available commands
```

### Individual Security Checks
```bash
make csp-check          # Content Security Policy validation
make api-key-check      # API key exposure detection  
make dependency-check   # External dependency security
make html-security-check # HTML security scanning
```

## Security Checks Performed

### 1. Content Security Policy (CSP) Check
- **Purpose**: Validates CSP headers and policies
- **Checks for**:
  - Missing CSP meta tags
  - Unsafe directives (`unsafe-inline`, `unsafe-eval`)
  - Overly permissive wildcards
  - HTTPS enforcement
- **File**: `scripts/csp-check.sh`

### 2. API Key Security Check  
- **Purpose**: Detects potential API key exposure
- **Checks for**:
  - Hardcoded API keys or tokens
  - API keys in URL parameters (security risk)
  - Proper client-side handling patterns
  - Environment file leakage
- **Context-aware**: Accounts for documented client-side API usage
- **File**: `scripts/api-key-check.sh`

### 3. External Dependency Check
- **Purpose**: Validates external resource security
- **Checks for**:
  - Untrusted CDN domains
  - Missing Subresource Integrity (SRI) hashes
  - CORS configuration
  - External API endpoint validation
- **File**: `scripts/dependency-check.sh`

### 4. HTML Security Check
- **Purpose**: Scans HTML for common security vulnerabilities
- **Checks for**:
  - Missing security meta tags
  - XSS risks (inline handlers, innerHTML usage)
  - Clickjacking protection
  - External link security (noopener)
  - Sensitive data in comments/attributes
- **File**: `scripts/html-security-check.sh`

### 5. Security Report Generation
- **Purpose**: Creates comprehensive security reports
- **Generates**: Detailed analysis with recommendations
- **File**: `scripts/generate-security-report.sh`

## Project-Specific Considerations

### Client-Side API Keys
This project intentionally handles API keys client-side (as documented in SECURITY.md). The security checker:
- Recognizes this documented behavior
- Reduces false positives for intended patterns
- Still warns about API keys in URL parameters (legitimate concern)
- Suggests server-side proxy solutions for production

### Trusted CDN Sources
The dependency checker recognizes these trusted CDN sources:
- `cdn.tailwindcss.com` (Tailwind CSS)
- `cdn.jsdelivr.net` (Chart.js)
- `fonts.googleapis.com` (Google Fonts)
- `fonts.gstatic.com` (Google Fonts)
- `cdnjs.cloudflare.com` (CloudFlare CDN)

## Security Report Output

Reports are generated in `/tmp/security-report-YYYYMMDD-HHMMSS.txt` containing:
- Executive summary
- Detailed findings for each check
- Prioritized recommendations  
- Compliance notes
- Contact information for security issues

## Exit Codes

- `0`: No critical security issues detected
- `1`: Security issues found (warnings/recommendations)
- `2`: Script execution errors

## Requirements

- `bash` shell
- Standard Unix utilities (`grep`, `sed`, `awk`)
- `jq` (optional, for advanced JSON processing)

## Integration

### CI/CD Integration
Add to your workflow:
```bash
make s-securityx-check || echo "Security warnings detected - review report"
```

### Pre-commit Hooks
```bash
#!/bin/bash
make s-securityx-check
exit $?
```

## Customization

### Adding New Checks
1. Create script in `scripts/` directory
2. Make executable: `chmod +x scripts/new-check.sh`
3. Add target to `Makefile`
4. Update main `security-check` target

### Modifying Thresholds
Edit the individual check scripts to adjust:
- Warning/error thresholds
- Trusted domain lists
- Pattern matching rules

## Troubleshooting

### Common Issues
- **Permission denied**: Run `chmod +x scripts/*.sh`
- **Command not found**: Ensure `make` is installed
- **False positives**: Review context-specific filtering in scripts

### Debug Mode
Run individual checks for detailed output:
```bash
./scripts/csp-check.sh
./scripts/api-key-check.sh
# etc.
```

## Security Contact

For security issues: security@voyageriq.de  
See [SECURITY.md](SECURITY.md) for full security policy.