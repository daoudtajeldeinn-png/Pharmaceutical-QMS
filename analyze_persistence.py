import re
import sys

# Force UTF-8 stdout
sys.stdout.reconfigure(encoding='utf-8')

FILE_PATH = "f:/PharmaQMS-Vue/app/dist/assets/index-D1EKfkgj.js"
OUTPUT_PATH = "f:/PharmaQMS-Vue/analysis_persistence.txt"

def search_in_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
        output = []
        output.append(f"File size: {len(content)} bytes")
        
        # Regex to find localStorage.getItem("KEY") or 'KEY'
        # Matches: localStorage.getItem("ANY_TEXT")
        matches = set()
        pattern = re.compile(r'localStorage\.getItem\s*\(\s*["\']([^"\']+)["\']\s*\)')
        
        for m in pattern.finditer(content):
            matches.add(m.group(1))
        
        output.append(f"\n--- Found localStorage Keys ({len(matches)}) ---")
        for key in sorted(matches):
            output.append(f"- {key}")

        with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
            f.write('\n'.join(output))
            
        print(f"Analysis written to {OUTPUT_PATH}")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    search_in_file(FILE_PATH)
