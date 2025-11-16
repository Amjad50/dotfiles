#!/bin/bash
# ============================================================================
# Setup notes directory structure
# This script runs automatically when it changes
# ============================================================================

echo "→ Setting up notes directory structure..."

mkdir -p $HOME/notes/reference
mkdir -p $HOME/notes/active-projects/
mkdir -p $HOME/notes/someday-projects/
mkdir -p $HOME/notes/archive/

chmod 755 $HOME/notes
chmod 755 $HOME/notes/reference
chmod 755 $HOME/notes/active-projects
chmod 755 $HOME/notes/someday-projects
chmod 755 $HOME/notes/archive

echo "✅ Notes directory structure created"
