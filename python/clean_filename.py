#!/usr/bin/env python3
"""
clean_filename.py - Remove Windows reserved characters from filenames.

Windows reserved characters: \\ / : * ? " < > |
Also handles reserved names (CON, PRN, AUX, NUL, COM1-9, LPT1-9)
and strips leading/trailing spaces and dots.

Usage:
    python clean_filename.py "my: invalid? file*.txt"
    python clean_filename.py --rename /path/to/directory
"""

import os
import re
import argparse

# Characters not allowed in Windows filenames
RESERVED_CHARS = r'\/:*?"<>|'

# Windows reserved filenames (case-insensitive)
RESERVED_NAMES = {
    "CON", "PRN", "AUX", "NUL",
    *(f"COM{i}" for i in range(1, 10)),
    *(f"LPT{i}" for i in range(1, 10)),
}


def clean_filename(filename: str, replacement: str = "_") -> str:
    """
    Remove or replace Windows reserved characters from a filename.

    Args:
        filename:    The original filename (basename only, not a full path).
        replacement: Character to substitute for each reserved character.
                     Defaults to '_'. Use '' to simply delete them.

    Returns:
        A sanitized filename safe for use on Windows (and most other systems).
    """
    # Split off the extension so we can treat stem and ext separately
    stem, ext = os.path.splitext(filename)

    # Replace every reserved character
    pattern = "[" + re.escape(RESERVED_CHARS) + "]"
    stem = re.sub(pattern, replacement, stem)
    ext  = re.sub(pattern, replacement, ext)

    # Strip leading/trailing spaces and dots from the stem
    # (Windows silently strips them, which can cause confusion)
    stem = stem.strip(". ")

    # Collapse runs of the replacement character
    if replacement:
        stem = re.sub(re.escape(replacement) + r"+", replacement, stem)

    # Rebuild the filename
    clean = (stem + ext).strip()

    # If the stem is now empty, use a fallback
    if not stem:
        clean = ("_" + ext).strip()

    # Guard against reserved names (e.g. "NUL.txt" → "_NUL.txt")
    base_no_ext = os.path.splitext(clean)[0].upper()
    if base_no_ext in RESERVED_NAMES:
        clean = "_" + clean

    return clean


def rename_files_in_directory(directory: str, replacement: str = "_",
                               dry_run: bool = False) -> None:
    """
    Walk a directory and rename any files whose names contain reserved chars.

    Args:
        directory:   Path to the directory to process.
        replacement: Replacement character (default '_').
        dry_run:     If True, print what would happen without renaming.
    """
    for root, dirs, files in os.walk(directory):
        for name in files:
            cleaned = clean_filename(name, replacement)
            if cleaned != name:
                src = os.path.join(root, name)
                dst = os.path.join(root, cleaned)
                if dry_run:
                    print(f"[dry-run] Would rename:\n  {src}\n       → {dst}\n")
                else:
                    # Avoid clobbering an existing file
                    if os.path.exists(dst):
                        print(f"[skip] Target already exists: {dst}")
                        continue
                    os.rename(src, dst)
                    print(f"Renamed:\n  {src}\n      → {dst}\n")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Remove Windows reserved characters from filenames."
    )
    parser.add_argument(
        "input",
        nargs="?",
        help="A filename string to clean (prints result to stdout).",
    )
    parser.add_argument(
        "--path",
        metavar="DIR",
        help="Recursively rename files inside DIR.",
    )
    parser.add_argument(
        "--replace",
        default="_",
        metavar="CHAR",
        help="Character to use instead of reserved chars (default: '_'). "
             "Pass '' to delete them.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be renamed without making changes (use with --rename).",
    )

    args = parser.parse_args()

    if args.dry_run and args.path:
        print("Dry-run mode: no files will be renamed, only shown.")

    if args.path:
        if not os.path.isdir(args.path):
            parser.error(f"Not a directory: {args.path}")
        rename_files_in_directory(args.path, args.replace, args.dry_run)

    elif args.input:
        result = clean_filename(args.input, args.replace)
        print(result)

    else:
        # Interactive demo
        examples = [
            'report: final?.docx',
            'file<1>|test*.txt',
            'NUL.txt',
            'CON',
            '  ..hidden.. ',
            'valid_file.txt',
        ]
        print(f"{'Original':<35} {'Cleaned'}")
        print("-" * 60)
        for name in examples:
            print(f"{name!r:<35} {clean_filename(name)!r}")


if __name__ == "__main__":
    main()