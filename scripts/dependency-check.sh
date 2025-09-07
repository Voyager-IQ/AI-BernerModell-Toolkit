#!/bin/bash
# External Dependency Security Check
# Analyzes external dependencies for security concerns

set -e

echo "📦 External Dependency Security Check"
echo "===================================="

DEPENDENCY_ISSUES=0
TEMP_FILE="/tmp/security-check-deps-$$"

# Known CDN domains that are generally trusted
declare -a TRUSTED_CDNS=(
    "cdn.tailwindcss.com"
    "cdn.jsdelivr.net"
    "fonts.googleapis.com"
    "fonts.gstatic.com"
    "cdnjs.cloudflare.com"
)

echo "🔍 Scanning for external dependencies..."

# Check HTML files for external script and link tags
for html_file in *.html; do
    if [[ -f "$html_file" ]]; then
        echo "Analyzing: $html_file"
        
        # Check for external scripts
        echo "  📜 Checking external scripts..."
        grep -n "src=\"http" "$html_file" | while IFS= read -r line; do
            url=$(echo "$line" | grep -o 'https\?://[^"]*')
            domain=$(echo "$url" | sed 's|https\?://||' | cut -d'/' -f1)
            
            # Check if domain is in trusted list
            trusted=false
            for trusted_cdn in "${TRUSTED_CDNS[@]}"; do
                if [[ "$domain" == "$trusted_cdn" ]]; then
                    trusted=true
                    break
                fi
            done
            
            if [[ "$trusted" == true ]]; then
                echo "    ✅ Trusted CDN: $domain"
            else
                echo "    ⚠️  WARNING: Untrusted external source: $domain"
                DEPENDENCY_ISSUES=$((DEPENDENCY_ISSUES + 1))
            fi
        done
        
        # Check for external stylesheets
        echo "  🎨 Checking external stylesheets..."
        grep -n "href=\"http" "$html_file" | while IFS= read -r line; do
            url=$(echo "$line" | grep -o 'https\?://[^"]*')
            domain=$(echo "$url" | sed 's|https\?://||' | cut -d'/' -f1)
            
            # Check if domain is in trusted list
            trusted=false
            for trusted_cdn in "${TRUSTED_CDNS[@]}"; do
                if [[ "$domain" == "$trusted_cdn" ]]; then
                    trusted=true
                    break
                fi
            done
            
            if [[ "$trusted" == true ]]; then
                echo "    ✅ Trusted CDN: $domain"
            else
                echo "    ⚠️  WARNING: Untrusted external stylesheet: $domain"
                DEPENDENCY_ISSUES=$((DEPENDENCY_ISSUES + 1))
            fi
        done
        
        # Check for external API calls
        echo "  🌐 Checking external API endpoints..."
        if grep -n "generativelanguage\.googleapis\.com" "$html_file" >/dev/null; then
            echo "    ✅ Google AI API endpoint detected (documented usage)"
        fi
        
        # Check for integrity attributes on external resources
        echo "  🔒 Checking SRI (Subresource Integrity)..."
        external_scripts=$(grep -c "src=\"http" "$html_file" 2>/dev/null || echo "0")
        integrity_attrs=$(grep -c "integrity=" "$html_file" 2>/dev/null || echo "0")
        
        # Clean up any newlines
        external_scripts=$(echo "$external_scripts" | tr -d '\n')
        integrity_attrs=$(echo "$integrity_attrs" | tr -d '\n')
        
        if [[ "$external_scripts" -gt 0 ]] && [[ "$integrity_attrs" -eq 0 ]]; then
            echo "    ⚠️  WARNING: External scripts without integrity checks"
            echo "    💡 RECOMMENDATION: Add integrity attributes for security"
            DEPENDENCY_ISSUES=$((DEPENDENCY_ISSUES + 1))
        elif [[ "$integrity_attrs" -gt 0 ]]; then
            echo "    ✅ Integrity attributes found"
        fi
        
        # Check for crossorigin attributes
        if grep -n "crossorigin" "$html_file" >/dev/null; then
            echo "    ✅ CORS attributes configured"
        fi
        
        echo ""
    fi
done

# Check for any local dependency files that might indicate a package manager
echo "🔍 Checking for local dependency management..."
for dep_file in package.json package-lock.json yarn.lock composer.json requirements.txt; do
    if [[ -f "$dep_file" ]]; then
        echo "  📦 Found: $dep_file"
        echo "  ℹ️  INFO: Local dependency management detected"
    fi
done

# Check for any .js files that might contain dependency info
echo "🔍 Checking JavaScript files for dependency patterns..."
for js_file in *.js; do
    if [[ -f "$js_file" ]]; then
        echo "Analyzing: $js_file"
        
        # Check for require() or import statements
        if grep -n "require\|import.*from" "$js_file" >/dev/null 2>&1; then
            echo "  📦 Module imports detected"
        fi
        
        # Check for external API calls
        if grep -n "fetch\|XMLHttpRequest\|axios" "$js_file" >/dev/null 2>&1; then
            echo "  🌐 HTTP requests detected"
        fi
    fi
done

echo "📊 Dependency Security Summary:"
if [[ $DEPENDENCY_ISSUES -eq 0 ]]; then
    echo "  ✅ No critical dependency security issues detected"
    echo "  📝 All external dependencies use trusted CDNs"
else
    echo "  ⚠️  $DEPENDENCY_ISSUES dependency security issues detected"
    echo "  🔧 Consider adding SRI integrity checks and reviewing untrusted domains"
fi

# Clean up
rm -f "$TEMP_FILE"

exit $DEPENDENCY_ISSUES