#!/bin/bash

# MIGRATE_FILES.sh
# This script helps migrate existing files to the new structure

echo "📦 Pharmaceutical QMS - File Migration Script"
echo "=============================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create new structure first
echo "1️⃣  Creating new directory structure..."
bash reorganize.sh
echo ""

# Track what was moved
MOVED_COUNT=0
SKIPPED_COUNT=0

echo "2️⃣  Analyzing existing files..."
echo ""

# Function to move file
move_file() {
    local source=$1
    local dest=$2
    local desc=$3
    
    if [ -f "$source" ]; then
        mkdir -p "$(dirname "$dest")"
        git mv "$source" "$dest" 2>/dev/null || mv "$source" "$dest"
        echo -e "${GREEN}✓${NC} Moved: $desc"
        echo "  $source → $dest"
        ((MOVED_COUNT++))
        return 0
    else
        return 1
    fi
}

# Function to skip file
skip_file() {
    local file=$1
    local reason=$2
    echo -e "${YELLOW}⊘${NC} Skipped: $file ($reason)"
    ((SKIPPED_COUNT++))
}

echo "3️⃣  Migrating files..."
echo ""

# Migrate app directory files
if [ -d "app" ]; then
    echo "📁 Processing app/ directory..."
    
    # Components
    if [ -d "app/components" ]; then
        for file in app/components/*.{tsx,ts,jsx,js} 2>/dev/null; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                move_file "$file" "app/shared/components/$filename" "Component: $filename"
            fi
        done
    fi
    
    # Services
    if [ -d "app/services" ]; then
        for file in app/services/*.{ts,js} 2>/dev/null; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                # Try to categorize service by name
                if [[ "$filename" == *"document"* ]]; then
                    move_file "$file" "app/modules/documents/services/$filename" "Document service: $filename"
                elif [[ "$filename" == *"audit"* ]]; then
                    move_file "$file" "app/modules/audits/services/$filename" "Audit service: $filename"
                elif [[ "$filename" == *"user"* || "$filename" == *"auth"* ]]; then
                    move_file "$file" "app/core/auth/$filename" "Auth service: $filename"
                else
                    move_file "$file" "app/shared/services/$filename" "Shared service: $filename"
                fi
            fi
        done
    fi
    
    # Utils
    if [ -d "app/utils" ]; then
        for file in app/utils/*.{ts,js} 2>/dev/null; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                move_file "$file" "app/shared/utils/$filename" "Utility: $filename"
            fi
        done
    fi
    
    # Models
    if [ -d "app/models" ]; then
        for file in app/models/*.{ts,js} 2>/dev/null; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                # Try to categorize model by name
                if [[ "$filename" == *"document"* ]]; then
                    move_file "$file" "app/modules/documents/models/$filename" "Document model: $filename"
                elif [[ "$filename" == *"user"* ]]; then
                    move_file "$file" "app/core/auth/models/$filename" "User model: $filename"
                else
                    move_file "$file" "app/shared/models/$filename" "Shared model: $filename"
                fi
            fi
        done
    fi
    
    # Config files
    if [ -f "app/config.ts" ] || [ -f "app/config.js" ]; then
        move_file "app/config.ts" "app/core/config/app.config.ts" "App config" || \
        move_file "app/config.js" "app/core/config/app.config.js" "App config"
    fi
    
    # Main app file
    if [ -f "app/app.ts" ]; then
        move_file "app/app.ts" "app/app.ts" "Main app file (kept in place)"
    fi
    
    if [ -f "app/app.tsx" ]; then
        move_file "app/app.tsx" "app/app.tsx" "Main app file (kept in place)"
    fi
fi

echo ""

# Migrate assets
if [ -d "assets" ]; then
    echo "📁 Processing assets/ directory..."
    
    # Images
    if [ -d "assets/images" ]; then
        echo "  ℹ️  assets/images/ already in correct location"
    fi
    
    # Icons - move to assets/images/icons
    if [ -d "icons" ]; then
        if [ ! -d "assets/images/icons" ]; then
            mkdir -p assets/images/icons
            mv icons/* assets/images/icons/ 2>/dev/null
            echo -e "${GREEN}✓${NC} Moved icons/ to assets/images/icons/"
            rmdir icons 2>/dev/null
            ((MOVED_COUNT++))
        fi
    fi
fi

echo ""

# Handle مكتبات (libraries) folder
if [ -d "مكتبات" ]; then
    echo "📁 Processing مكتبات/ (libraries) directory..."
    echo "  ⚠️  Renaming to 'libraries' (English)"
    
    if [ ! -d "libraries" ]; then
        git mv "مكتبات" "libraries" 2>/dev/null || mv "مكتبات" "libraries"
        echo -e "${GREEN}✓${NC} Renamed: مكتبات → libraries"
        ((MOVED_COUNT++))
    else
        echo -e "${YELLOW}⊘${NC} Directory 'libraries' already exists, manual merge needed"
    fi
fi

echo ""

# Move root level config files to config/
echo "📁 Processing configuration files..."

# TypeScript config
if [ -f "tsconfig.json" ]; then
    echo "  ℹ️  tsconfig.json kept in root (standard location)"
fi

# Vite config
if [ -f "vite.config.ts" ] || [ -f "vite.config.js" ]; then
    echo "  ℹ️  vite.config kept in root (standard location)"
fi

# ESLint config
if [ -f ".eslintrc.json" ] || [ -f ".eslintrc.js" ]; then
    echo "  ℹ️  eslint config kept in root (standard location)"
fi

echo ""

# Create index files for modules
echo "4️⃣  Creating barrel exports (index.ts files)..."
echo ""

create_index() {
    local dir=$1
    local file="$dir/index.ts"
    
    if [ -d "$dir" ] && [ ! -f "$file" ]; then
        cat > "$file" << 'EOF'
// Barrel export file
// Export all public APIs from this module

// Export components
export * from './components';

// Export services
export * from './services';

// Export models
export * from './models';

// Export utilities
export * from './utils';
EOF
        echo -e "${GREEN}✓${NC} Created: $file"
    fi
}

# Create index files for each module
for module in app/modules/*/; do
    if [ -d "$module" ]; then
        create_index "$module"
    fi
done

# Create index for shared
create_index "app/shared"

echo ""
echo "=============================================="
echo "📊 Migration Summary"
echo "=============================================="
echo ""
echo -e "${GREEN}Files moved: $MOVED_COUNT${NC}"
echo -e "${YELLOW}Files skipped: $SKIPPED_COUNT${NC}"
echo ""

echo "5️⃣  Next steps:"
echo ""
echo "  1. Update import paths in your TypeScript files"
echo "  2. Add this to tsconfig.json:"
echo ""
cat << 'EOF'
     {
       "compilerOptions": {
         "baseUrl": ".",
         "paths": {
           "@app/*": ["app/*"],
           "@core/*": ["app/core/*"],
           "@modules/*": ["app/modules/*"],
           "@shared/*": ["app/shared/*"],
           "@assets/*": ["assets/*"]
         }
       }
     }
EOF
echo ""
echo "  3. Test your application: npm run dev"
echo "  4. Run tests: npm run test"
echo "  5. Fix any broken imports"
echo "  6. Commit changes: git commit -m 'refactor: migrate to new structure'"
echo ""

echo "=============================================="
echo "✅ Migration complete!"
echo "=============================================="
