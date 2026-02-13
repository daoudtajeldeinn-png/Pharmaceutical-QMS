import re
import sys

# Force UTF-8 stdout
sys.stdout.reconfigure(encoding='utf-8')

FILE_PATH = "f:/PharmaQMS-Vue/app/dist/assets/index-D1EKfkgj.js"
OUTPUT_PATH = "f:/PharmaQMS-Vue/analysis_bmr.txt"
KEYWORDS = [
    "BMR",
    "Batch Record",
    "Manufacturing",
    "Formula",
    "MFR",
    "products",
    "recipes"
]
CONTEXT_CHARS = 100

def search_in_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
        output = []
        output.append(f"File size: {len(content)} bytes")
        
        for keyword in KEYWORDS:
            matches = [m.start() for m in re.finditer(re.escape(keyword), content, re.IGNORECASE)]
            if matches:
                output.append(f"\n--- Matches for '{keyword}' ({len(matches)}) ---")
                for pos in matches[:10]:
                    start = max(0, pos - CONTEXT_CHARS)
                    end = min(len(content), pos + len(keyword) + CONTEXT_CHARS)
                    snippet = content[start:end].replace('\n', ' ')
                    output.append(f"@{pos}: ...{snippet}...")
            else:
                output.append(f"No matches for '{keyword}'")
        
        with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
            f.write('\n'.join(output))
            
        print(f"Analysis written to {OUTPUT_PATH}")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    search_in_file(FILE_PATH)
