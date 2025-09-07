#!/bin/bash
# CSP (Content Security Policy) Security Check
# Validates CSP headers and policies in HTML files

set -e

echo "🔍 Content Security Policy Check"
echo "================================"

CSP_ISSUES=0
TEMP_FILE="/tmp/security-check-csp-$$"

# Check for CSP meta tags in HTML files
echo "📋 Checking CSP meta tags..."
for html_file in *.html; do
    if [[ -f "$html_file" ]]; then
        echo "Analyzing: $html_file"
        
        # Check if CSP meta tag exists
        if grep -q "Content-Security-Policy" "$html_file"; then
            echo "  ✅ CSP meta tag found"
            
            # Extract CSP content (simple approach)
            # Get all lines from CSP meta tag to the closing >
            CSP_CONTENT=$(awk '/Content-Security-Policy/,/>/' "$html_file" | 
                          sed -n 's/.*content="\(.*\)".*/\1/p; s/.*content="\(.*\)/\1/p' | 
                          tr '\n' ' ' | 
                          sed 's/^[[:space:]]*//' | 
                          sed 's/[[:space:]]*$//' |
                          sed 's/[[:space:]]\+/ /g' |
                          sed 's/">.*$//')
            
            # If still empty, try extracting just the content between quotes
            if [[ -z "$CSP_CONTENT" ]]; then
                CSP_CONTENT=$(sed -n '/Content-Security-Policy/,/>/p' "$html_file" | 
                              sed 's/.*content="//g; s/">.*//g' | 
                              tr '\n' ' ' | 
                              sed 's/^[[:space:]]*//' | 
                              sed 's/[[:space:]]*$//')
            fi
            
            if [[ -n "$CSP_CONTENT" ]]; then
                echo "  📝 CSP Content: $CSP_CONTENT"
                
                # Check for common security issues
                if echo "$CSP_CONTENT" | grep -q "unsafe-inline"; then
                    echo "  ⚠️  WARNING: 'unsafe-inline' directive found - reduces XSS protection"
                    CSP_ISSUES=$((CSP_ISSUES + 1))
                fi
                
                if echo "$CSP_CONTENT" | grep -q "unsafe-eval"; then
                    echo "  ⚠️  WARNING: 'unsafe-eval' directive found - allows eval() execution"
                    CSP_ISSUES=$((CSP_ISSUES + 1))
                fi
                
                if echo "$CSP_CONTENT" | grep -q "\*"; then
                    echo "  ⚠️  WARNING: Wildcard (*) in CSP - overly permissive"
                    CSP_ISSUES=$((CSP_ISSUES + 1))
                fi
                
                # Check for localhost in production CSP
                if echo "$CSP_CONTENT" | grep -q "localhost"; then
                    echo "  ℹ️  INFO: localhost allowed in CSP - ensure this is intended for development"
                fi
                
                # Check for HTTPS enforcement
                if echo "$CSP_CONTENT" | grep -q "https:"; then
                    echo "  ✅ HTTPS sources allowed"
                else
                    echo "  ⚠️  WARNING: No HTTPS-only policy detected"
                    CSP_ISSUES=$((CSP_ISSUES + 1))
                fi
                
            else
                echo "  ❌ ERROR: CSP meta tag found but content is empty"
                CSP_ISSUES=$((CSP_ISSUES + 1))
            fi
        else
            echo "  ⚠️  WARNING: No CSP meta tag found in $html_file"
            CSP_ISSUES=$((CSP_ISSUES + 1))
        fi
        echo ""
    fi
done

# Summary
echo "📊 CSP Check Summary:"
if [[ $CSP_ISSUES -eq 0 ]]; then
    echo "  ✅ No CSP security issues detected"
    exit 0
else
    echo "  ⚠️  $CSP_ISSUES CSP security issues detected"
    echo "  🔧 Consider reviewing CSP policies for security improvements"
    exit 1
fi