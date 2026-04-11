#!/usr/bin/env python3
"""
clean_filename.py - Remove Windows reserved characters from filenames.

Windows reserved characters: \\ / : * ? " < > |
Also handles reserved names (CON, PRN, AUX, NUL, COM1-9, LPT1-9)
and strips leading/trailing spaces and dots.

Usage:
    python clean_filename.py "my: invalid? file*.txt"
    python clean_filename.py --path /path/to/directory
    python clean_filename.py --undo
    python clean_filename.py --undo --log-file /custom/path/undo_log.json
"""

import os
import re
import json
import argparse
from datetime import datetime

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
    stem, ext = os.path.splitext(filename)

    pattern = "[" + re.escape(RESERVED_CHARS) + "]"
    stem = re.sub(pattern, replacement, stem)
    ext  = re.sub(pattern, replacement, ext)

    stem = stem.strip(". ")

    if replacement:
        stem = re.sub(re.escape(replacement) + r"+", replacement, stem)

    clean = (stem + ext).strip()

    if not stem:
        clean = ("_" + ext).strip()

    base_no_ext = os.path.splitext(clean)[0].upper()
    if base_no_ext in RESERVED_NAMES:
        clean = "_" + clean

    return clean


def rename_files_in_directory(directory: str, replacement: str = "_",
                               dry_run: bool = False,
                               log_file: str = "undo_log.json") -> None:
    """
    Walk a directory and rename any files whose names contain reserved chars.
    Successful renames are appended to an undo log for later reversal.

    Args:
        directory:   Path to the directory to process.
        replacement: Replacement character (default '_').
        dry_run:     If True, print what would happen without renaming.
        log_file:    Path to the undo log JSON file.
    """
    log = []

    for root, dirs, files in os.walk(directory):
        for name in files:
            cleaned = clean_filename(name, replacement)
            if cleaned != name:
                src = os.path.join(root, name)
                dst = os.path.join(root, cleaned)
                if dry_run:
                    print(f"[dry-run] Would rename:\n  {src}\n       -> {dst}\n")
                else:
                    if os.path.exists(dst):
                        print(f"[skip] Target already exists: {dst}")
                        continue
                    os.rename(src, dst)
                    log.append({"src": src, "dst": dst})
                    print(f"Renamed:\n  {src}\n      -> {dst}\n")

    if log:
        entry = {"timestamp": datetime.now().isoformat(), "renames": log}
        existing = []
        if os.path.exists(log_file):
            with open(log_file) as f:
                existing = json.load(f)
        existing.append(entry)
        with open(log_file, "w") as f:
            json.dump(existing, f, indent=2)
        print(f"Undo log saved -> {log_file}  ({len(log)} rename(s) recorded)")


def undo_last_rename(log_file: str = "undo_log.json") -> None:
    """
    Reverse the most recent batch of renames recorded in the undo log.

    Args:
        log_file: Path to the undo log JSON file.
    """
    if not os.path.exists(log_file):
        print(f"No undo log found at: {log_file}")
        return

    with open(log_file) as f:
        log = json.load(f)

    if not log:
        print("Undo log is empty -- nothing to undo.")
        return

    last = log.pop()
    count = len(last["renames"])
    print(f"Undoing batch from {last['timestamp']} ({count} rename(s))...\n")

    for entry in reversed(last["renames"]):
        src, dst = entry["dst"], entry["src"]   # swap: dst becomes the source
        if not os.path.exists(src):
            print(f"[skip] File not found: {src}")
            continue
        if os.path.exists(dst):
            print(f"[skip] Target already exists: {dst}")
            continue
        os.rename(src, dst)
        print(f"Restored:\n  {src}\n        -> {dst}\n")

    with open(log_file, "w") as f:
        json.dump(log, f, indent=2)

    remaining = len(log)
    print(f"Undo complete. {remaining} batch(es) remaining in log.")


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
        default=".",
        help="Recursively rename files inside DIR (default: current directory).",
    )
    parser.add_argument(
        "--replacement",
        default="_",
        metavar="CHAR",
        help="Character to use instead of reserved chars (default: '_'). "
             "Pass '' to delete them.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be renamed without making changes (use with --path).",
    )
    parser.add_argument(
        "--undo",
        action="store_true",
        help="Reverse the most recent rename batch recorded in the undo log.",
    )
    parser.add_argument(
        "--log-file",
        default="undo_log.json",
        metavar="FILE",
        help="Path to the undo log file (default: undo_log.json).",
    )

    args = parser.parse_args()

    if args.undo:
        undo_last_rename(args.log_file)

    if args.path:
        if not os.path.isdir(args.path):
            parser.error(f"Not a directory: {args.path}")
        rename_files_in_directory(args.path, args.replacement, args.dry_run, args.log_file)

    elif args.input:
        result = clean_filename(args.input, args.replacement)
        print(result)

if __name__ == "__main__":
    main()