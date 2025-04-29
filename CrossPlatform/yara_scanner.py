import yara
from pathlib import Path

def scan_file(file_path: str, rules_dir: str = "yara_rules") -> dict:
    """Scan a file with YARA rules from specified directory"""
    try:
        rules = yara.compile(filepaths={
            'malware': f'{rules_dir}/malware.yar',
            'suspicious': f'{rules_dir}/suspicious.yar'
        })
        matches = rules.match(file_path)
        return {
            'file': file_path,
            'matches': [str(m) for m in matches],
            'meta': [m.meta for m in matches]
        }
    except Exception as e:
        return {'error': str(e)}

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: yara_scanner.py <file_to_scan>")
        sys.exit(1)
    
    result = scan_file(sys.argv[1])
    print("Scan Results:")
    print(f"File: {result.get('file', '')}")
    print("Matches:", ", ".join(result.get('matches', [])))
