#!/bin/bash
# Security Report Generator
# Generates a comprehensive security report

set -e

echo "📊 Security Report Generator"
echo "==========================="

REPORT_FILE="/tmp/security-report-$(date +%Y%m%d-%H%M%S).txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Create report header
cat > "$REPORT_FILE" << EOF
🔒 AI-BernerModell-Toolkit Security Report
==========================================
Generated: $TIMESTAMP
Repository: AI-BernerModell-Toolkit

EXECUTIVE SUMMARY
================
This report provides a comprehensive security analysis of the AI-BernerModell-Toolkit,
focusing on frontend security concerns including Content Security Policy, API key
handling, external dependencies, and HTML security best practices.

PROJECT OVERVIEW
================
- Project Type: Static HTML/JavaScript frontend application
- Main Files: index.html, AI-dashboard.html
- Security Model: Client-side API key handling (documented risk)
- External Dependencies: Tailwind CSS, Chart.js (via CDN)

EOF

echo "📋 Generating comprehensive security report..."
echo "Report location: $REPORT_FILE"

# Add detailed findings
echo "" >> "$REPORT_FILE"
echo "DETAILED SECURITY FINDINGS" >> "$REPORT_FILE"
echo "==========================" >> "$REPORT_FILE"

# Run each security check and capture output
echo "" >> "$REPORT_FILE"
echo "1. CONTENT SECURITY POLICY ANALYSIS" >> "$REPORT_FILE"
echo "-----------------------------------" >> "$REPORT_FILE"
./scripts/csp-check.sh >> "$REPORT_FILE" 2>&1 || true

echo "" >> "$REPORT_FILE"
echo "2. API KEY SECURITY ANALYSIS" >> "$REPORT_FILE"
echo "---------------------------" >> "$REPORT_FILE"
./scripts/api-key-check.sh >> "$REPORT_FILE" 2>&1 || true

echo "" >> "$REPORT_FILE"
echo "3. DEPENDENCY SECURITY ANALYSIS" >> "$REPORT_FILE"
echo "------------------------------" >> "$REPORT_FILE"
./scripts/dependency-check.sh >> "$REPORT_FILE" 2>&1 || true

echo "" >> "$REPORT_FILE"
echo "4. HTML SECURITY ANALYSIS" >> "$REPORT_FILE"
echo "------------------------" >> "$REPORT_FILE"
./scripts/html-security-check.sh >> "$REPORT_FILE" 2>&1 || true

# Add recommendations section
cat >> "$REPORT_FILE" << EOF

SECURITY RECOMMENDATIONS
========================

HIGH PRIORITY
-------------
1. Consider adding Subresource Integrity (SRI) hashes to external CDN resources
2. Review CSP policy for 'unsafe-inline' usage - consider using nonces
3. For production deployment, implement API key proxy to avoid client-side exposure

MEDIUM PRIORITY
--------------
1. Add rel="noopener noreferrer" to external links with target="_blank"
2. Consider implementing additional security headers via web server configuration
3. Review and minimize external dependencies

LOW PRIORITY
-----------
1. Add comprehensive security documentation beyond SECURITY.md
2. Implement automated security testing in CI/CD pipeline
3. Consider Content Security Policy reporting

COMPLIANCE NOTES
================
- Client-side API key handling is documented as intentional design decision
- SECURITY.md properly documents security model and contact information
- Project follows responsible disclosure practices

For security issues, contact: security@voyageriq.de

EOF

# Display summary
echo ""
echo "✅ Security report generated successfully!"
echo "📄 Report saved to: $REPORT_FILE"
echo ""
echo "📋 Quick Summary:"
grep -E "✅|⚠️|❌" "$REPORT_FILE" | tail -10 || echo "No immediate issues found in summary."
echo ""
echo "📖 View full report:"
echo "   cat $REPORT_FILE"
echo ""
echo "🔧 To address issues, review the detailed findings above."