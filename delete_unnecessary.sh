#!/bin/bash

# DELETE_UNNECESSARY.sh
# This script identifies and deletes unnecessary files from your repository

echo "🔍 Scanning for unnecessary files..."
echo ""

# Create a list of files to delete
TO_DELETE=()

# Check for common unnecessary files
echo "Checking for cache and temporary files..."

# Vite cache
if [ -d "node_modules/.vite" ]; then
    echo "  ❌ Found: node_modules/.vite (Vite cache)"
    TO_DELETE+=("node_modules/.vite")
fi

# OS files
if [ -f ".DS_Store" ]; then
    echo "  ❌ Found: .DS_Store (macOS)"
    TO_DELETE+=(".DS_Store")
fi

if [ -f "Thumbs.db" ]; then
    echo "  ❌ Found: Thumbs.db (Windows)"
    TO_DELETE+=("Thumbs.db")
fi

# Find all .DS_Store files recursively
while IFS= read -r file; do
    if [ -n "$file" ]; then
        echo "  ❌ Found: $file (macOS)"
        TO_DELETE+=("$file")
    fi
done < <(find . -name ".DS_Store" 2>/dev/null)

# Temporary files
while IFS= read -r file; do
    if [ -n "$file" ]; then
        echo "  ❌ Found: $file (temporary)"
        TO_DELETE+=("$file")
    fi
done < <(find . -name "*.tmp" -o -name "*.temp" -o -name "*.bak" -o -name "*.old" 2>/dev/null | grep -v node_modules)

# Log files
while IFS= read -r file; do
    if [ -n "$file" ]; then
        echo "  ❌ Found: $file (log file)"
        TO_DELETE+=("$file")
    fi
done < <(find . -name "*.log" 2>/dev/null | grep -v node_modules)

# Check for duplicate or conflicting files
echo ""
echo "Checking for potentially redundant files..."

# Check for old README variations
if [ -f "README.txt" ]; then
    echo "  ⚠️  Found: README.txt (you already have README.md)"
    TO_DELETE+=("README.txt")
fi

if [ -f "readme.md" ]; then
    echo "  ⚠️  Found: readme.md (duplicate of README.md)"
    TO_DELETE+=("readme.md")
fi

# Check for old gitignore
if [ -f ".gitignore.old" ]; then
    echo "  ❌ Found: .gitignore.old"
    TO_DELETE+=(".gitignore.old")
fi

echo ""
echo "=========================================="
echo "📋 Summary"
echo "=========================================="

if [ ${#TO_DELETE[@]} -eq 0 ]; then
    echo "✅ No unnecessary files found! Your repository is clean."
    exit 0
fi

echo "Found ${#TO_DELETE[@]} files/directories to delete:"
echo ""

for item in "${TO_DELETE[@]}"; do
    echo "  • $item"
done

echo ""
echo "=========================================="
read -p "Do you want to delete these files? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🗑️  Deleting files..."
    
    for item in "${TO_DELETE[@]}"; do
        if [ -e "$item" ]; then
            rm -rf "$item"
            echo "  ✅ Deleted: $item"
        fi
    done
    
    echo ""
    echo "✅ Cleanup complete!"
    echo ""
    echo "Next steps:"
    echo "1. Run: git add ."
    echo "2. Run: git commit -m 'chore: remove unnecessary files'"
else
    echo ""
    echo "❌ Cancelled. No files were deleted."
fi

echo ""
echo "=========================================="
echo "💡 Additional Cleanup Suggestions"
echo "=========================================="
echo ""
echo "These directories should NOT be in git:"
echo "  • node_modules/ (should be in .gitignore)"
echo "  • dist/ or build/ (should be in .gitignore)"
echo "  • .env files (should be in .gitignore)"
echo ""

# Check if node_modules is tracked
if git ls-files --error-unmatch node_modules/ >/dev/null 2>&1; then
    echo "⚠️  WARNING: node_modules/ is tracked by git!"
    echo "   Run: git rm -r --cached node_modules/"
    echo "   Make sure 'node_modules/' is in .gitignore"
    echo ""
fi

# Check if dist or build is tracked
if git ls-files --error-unmatch dist/ >/dev/null 2>&1 || git ls-files --error-unmatch build/ >/dev/null 2>&1; then
    echo "⚠️  WARNING: build output is tracked by git!"
    echo "   Run: git rm -r --cached dist/ build/"
    echo "   Make sure 'dist/' and 'build/' are in .gitignore"
    echo ""
fi

# Check for .env files
if git ls-files --error-unmatch .env >/dev/null 2>&1; then
    echo "⚠️  WARNING: .env file is tracked by git!"
    echo "   This is a SECURITY RISK!"
    echo "   Run: git rm --cached .env"
    echo "   Make sure '.env' is in .gitignore"
    echo ""
fi

echo "=========================================="
