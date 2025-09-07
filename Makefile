# AI-BernerModell-Toolkit Security Checks
# Usage: make security-check or make s-securityx-check

.PHONY: help security-check s-securityx-check csp-check api-key-check dependency-check html-security-check clean-tmp

# Default target
help:
	@echo "AI-BernerModell-Toolkit Security Checks"
	@echo "======================================="
	@echo "Available targets:"
	@echo "  security-check      - Run all security checks"
	@echo "  s-securityx-check   - Alias for security-check"
	@echo "  csp-check          - Check Content Security Policy configuration"
	@echo "  api-key-check      - Check for potential API key exposure"
	@echo "  dependency-check   - Check external dependencies for known issues"
	@echo "  html-security-check - Check HTML files for security issues"
	@echo "  clean-tmp          - Clean temporary files"

# Main security check target (comprehensive)
security-check:
	@echo "🔍 Checking Content Security Policy..."
	@-./scripts/csp-check.sh
	@echo "🔑 Checking for API key exposure..."
	@-./scripts/api-key-check.sh
	@echo "📦 Checking external dependencies..."
	@-./scripts/dependency-check.sh
	@echo "🌐 Checking HTML security..."
	@-./scripts/html-security-check.sh
	@echo "==========================================="
	@echo "🔒 SECURITY CHECK SUMMARY COMPLETED"
	@echo "==========================================="
	@./scripts/generate-security-report.sh

# Alias for the main security check (matching the problem statement)
s-securityx-check: security-check

# Individual security checks
csp-check:
	@echo "🔍 Checking Content Security Policy..."
	@./scripts/csp-check.sh

api-key-check:
	@echo "🔑 Checking for API key exposure..."
	@./scripts/api-key-check.sh

dependency-check:
	@echo "📦 Checking external dependencies..."
	@./scripts/dependency-check.sh

html-security-check:
	@echo "🌐 Checking HTML security..."
	@./scripts/html-security-check.sh

# Clean up temporary files
clean-tmp:
	@rm -rf /tmp/security-check-*
	@echo "✅ Cleaned temporary security check files"

# Install security check dependencies (if needed)
install-deps:
	@echo "📥 Installing security check dependencies..."
	@command -v jq >/dev/null 2>&1 || (echo "Installing jq..." && sudo apt-get update && sudo apt-get install -y jq)
	@command -v curl >/dev/null 2>&1 || (echo "Installing curl..." && sudo apt-get update && sudo apt-get install -y curl)
	@echo "✅ Dependencies installed"