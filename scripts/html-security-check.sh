#!/bin/bash
# HTML Security Check
# Validates HTML files for common security issues

set -e

echo "🌐 HTML Security Check"
echo "====================="

HTML_ISSUES=0
TEMP_FILE="/tmp/security-check-html-$$"

echo "🔍 Scanning HTML files for security issues..."

for html_file in *.html; do
    if [[ -f "$html_file" ]]; then
        echo "Analyzing: $html_file"
        
        # Check for missing security headers
        echo "  🔒 Checking security meta tags..."
        
        # Check for viewport meta tag (helps prevent clickjacking)
        if grep -q "viewport" "$html_file"; then
            echo "    ✅ Viewport meta tag present"
        else
            echo "    ⚠️  WARNING: Missing viewport meta tag"
            HTML_ISSUES=$((HTML_ISSUES + 1))
        fi
        
        # Check for charset declaration
        if grep -q "charset=" "$html_file"; then
            echo "    ✅ Character encoding declared"
        else
            echo "    ⚠️  WARNING: Missing character encoding declaration"
            HTML_ISSUES=$((HTML_ISSUES + 1))
        fi
        
        # Check for X-Frame-Options equivalent (CSP frame-ancestors)
        if grep -q "frame-ancestors\|X-Frame-Options" "$html_file"; then
            echo "    ✅ Clickjacking protection configured"
        else
            echo "    ℹ️  INFO: Consider adding frame-ancestors CSP directive"
        fi
        
        # Check for form security
        echo "  📝 Checking form security..."
        form_count=$(grep -c "<form" "$html_file" 2>/dev/null || echo "0")
        form_count=$(echo "$form_count" | tr -d '\n')
        
        if [[ "$form_count" -gt 0 ]]; then
            echo "    📋 $form_count form(s) found"
            
            # Check for HTTPS action URLs
            if grep -n "action=\"http:" "$html_file" >/dev/null; then
                echo "    ⚠️  WARNING: Non-HTTPS form action detected"
                HTML_ISSUES=$((HTML_ISSUES + 1))
            fi
            
            # Check for password inputs
            password_inputs=$(grep -c "type=\"password\"" "$html_file" 2>/dev/null || echo "0")
            if [[ $password_inputs -gt 0 ]]; then
                echo "    🔑 $password_inputs password input(s) found"
                echo "    ✅ Password inputs properly typed"
            fi
        else
            echo "    ℹ️  No forms found"
        fi
        
        # Check for dangerous HTML patterns
        echo "  ⚠️  Checking for dangerous patterns..."
        
        # Check for inline event handlers
        if grep -n "on[a-z]*=" "$html_file" | grep -v "onload\|onready" >/dev/null; then
            echo "    ⚠️  WARNING: Inline event handlers found (XSS risk)"
            HTML_ISSUES=$((HTML_ISSUES + 1))
        fi
        
        # Check for javascript: protocol
        if grep -n "javascript:" "$html_file" >/dev/null; then
            echo "    ⚠️  WARNING: javascript: protocol found (XSS risk)"
            HTML_ISSUES=$((HTML_ISSUES + 1))
        fi
        
        # Check for eval() usage
        if grep -n "eval(" "$html_file" >/dev/null; then
            echo "    ⚠️  WARNING: eval() usage found (security risk)"
            HTML_ISSUES=$((HTML_ISSUES + 1))
        fi
        
        # Check for innerHTML with user data
        if grep -n "innerHTML.*=" "$html_file" >/dev/null; then
            echo "    ⚠️  WARNING: innerHTML usage found (potential XSS risk)"
            echo "    💡 Consider using textContent or safe DOM methods"
            HTML_ISSUES=$((HTML_ISSUES + 1))
        fi
        
        # Check for external resource loading
        echo "  🌐 Checking external resources..."
        
        # Count external resources
        external_scripts=$(grep -c "src=\"http" "$html_file" 2>/dev/null || echo "0")
        external_links=$(grep -c "href=\"http" "$html_file" 2>/dev/null || echo "0")
        
        # Clean up any newlines
        external_scripts=$(echo "$external_scripts" | tr -d '\n')
        external_links=$(echo "$external_links" | tr -d '\n')
        
        echo "    📊 External scripts: $external_scripts"
        echo "    📊 External links: $external_links"
        
        # Check for rel="noopener" on external links
        if grep -n "target=\"_blank\"" "$html_file" >/dev/null; then
            if ! grep -n "rel.*noopener" "$html_file" >/dev/null; then
                echo "    ⚠️  WARNING: External links without rel='noopener' (tabnabbing risk)"
                echo "    💡 Add rel='noopener noreferrer' to external _blank links"
                HTML_ISSUES=$((HTML_ISSUES + 1))
            else
                echo "    ✅ External links properly secured with noopener"
            fi
        fi
        
        # Check for data attributes containing sensitive info
        if grep -n "data-.*key\|data-.*token\|data-.*secret" "$html_file" >/dev/null; then
            echo "    ⚠️  WARNING: Potential sensitive data in data attributes"
            HTML_ISSUES=$((HTML_ISSUES + 1))
        fi
        
        # Check for HTML comments that might contain sensitive info
        if grep -n "<!--.*key\|<!--.*password\|<!--.*token" "$html_file" >/dev/null; then
            echo "    ⚠️  WARNING: Potential sensitive information in HTML comments"
            HTML_ISSUES=$((HTML_ISSUES + 1))
        fi
        
        # Check for proper language attribute
        if grep -q "lang=" "$html_file"; then
            echo "    ✅ Language attribute present"
        else
            echo "    ℹ️  INFO: Consider adding lang attribute to html tag"
        fi
        
        echo ""
    fi
done

# Check for any template files that might have security implications
echo "🔍 Checking for template files..."
for template_file in *.template *.tmpl *.mustache *.handlebars; do
    if [[ -f "$template_file" ]]; then
        echo "  📄 Template file found: $template_file"
        echo "  ⚠️  WARNING: Review template files for XSS vulnerabilities"
        HTML_ISSUES=$((HTML_ISSUES + 1))
    fi
done

# Clean up
rm -f "$TEMP_FILE"

echo "📊 HTML Security Summary:"
if [[ $HTML_ISSUES -eq 0 ]]; then
    echo "  ✅ No critical HTML security issues detected"
    exit 0
else
    echo "  ⚠️  $HTML_ISSUES HTML security issues detected"
    echo "  🔧 Review and address the security recommendations above"
    exit 1
fi