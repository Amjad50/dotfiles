# kini.py: enforce a handful of managed entries in a KDE config file and leave
# every other line exactly as KDE wrote it.
#
# Used by the modify_ scripts for ~/.config/kglobalshortcutsrc and ~/.config/kxkbrc
# (chezmoi `include`s this file into them) and by .bin/kde-capture.
# The managed entries live in .chezmoitemplates/kde/*.overrides.
#
# Shortcut mode (kglobalshortcutsrc): an override names only the ACTIVE shortcut.
# A line is rewritten only when its set of active keys differs from the override,
# so KDE reordering keys or rewriting ",," as ",none," never produces a diff.
import sys


# KConfig escapes twice: the file level turns \\ \t \s \n \r \xHH into characters,
# then a list value (action=active,default,name) uses \, for a literal comma and
# \\ for a literal backslash. "Meta+\\," in the file is therefore the single
# shortcut Meta+Comma, and "Meta+\\\\" is Meta+Backslash.
FILE_ESCAPES = {"s": " ", "t": "\t", "n": "\n", "r": "\r", "\\": "\\"}


def raw_fields(raw):
    """Split a raw list value on its separator commas, keeping each field's raw text.

    ",".join(raw_fields(raw)) == raw, so one field can be swapped without
    touching the others.
    """
    fields, start, i, escaping = [], 0, 0, False
    while i < len(raw):
        if raw[i] == "\\" and i + 1 < len(raw):
            nxt = raw[i + 1]
            # A file-level \\ is one backslash in the list text: it escapes the
            # next list character unless it is itself escaped.
            escaping = (not escaping) if nxt == "\\" else False
            i += 4 if nxt == "x" else 2
            continue
        if raw[i] == "," and not escaping:
            fields.append(raw[start:i])
            start = i + 1
        escaping = False
        i += 1
    fields.append(raw[start:])
    return fields


def decode(raw):
    """A raw field as KDE reads it: file escapes, then list escapes, resolved."""
    text, i = [], 0
    while i < len(raw):
        if raw[i] == "\\" and i + 1 < len(raw):
            nxt = raw[i + 1]
            if nxt in FILE_ESCAPES:
                text.append(FILE_ESCAPES[nxt])
                i += 2
                continue
            if nxt == "x" and i + 3 < len(raw):
                text.append(chr(int(raw[i + 2:i + 4], 16)))
                i += 4
                continue
            text.append(raw[i:i + 2])  # \, and \; belong to the list level
            i += 2
            continue
        text.append(raw[i])
        i += 1
    listed, out, i = "".join(text), [], 0
    while i < len(listed):
        if listed[i] == "\\" and i + 1 < len(listed):
            out.append(listed[i + 1])
            i += 2
            continue
        out.append(listed[i])
        i += 1
    return "".join(out)


def keyset(active):
    """The set of key sequences in a raw active-shortcut field ("none" = empty).

    Alternatives are tab-separated; their order doesn't matter.
    """
    return frozenset(k for k in decode(active).split("\t") if k not in ("", "none"))


def is_service(group):
    return group.startswith("[services]")


def parse_overrides(text):
    """'[group]' headers and 'key=value' lines; '#' comments and blanks ignored."""
    order, groups, cur = [], {}, None
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        if line.startswith("["):
            cur = line.rstrip()
            if cur not in groups:
                groups[cur] = {}
                order.append(cur)
            continue
        if cur is None or "=" not in line:
            raise SystemExit(f"kini: bad override line: {line!r}")
        key, _, value = line.partition("=")
        groups[cur][key] = value
    return order, groups


def apply_value(group, key, live, want, shortcuts):
    """The value to write for a managed key that is already in the file."""
    if not shortcuts:
        return want
    if is_service(group):
        return live if keyset(live) == keyset(want) else want
    fields = raw_fields(live)
    if len(fields) != 3:
        return f"{want},none,{key}"
    if keyset(fields[0]) == keyset(want):
        return live
    return ",".join([want] + fields[1:])


def fresh_value(group, key, want, shortcuts):
    """The value to write for a managed key the file doesn't have yet."""
    if shortcuts and not is_service(group):
        return f"{want},none,{key}"  # KDE fills in the default and name later
    return want


def merge(text, overrides, shortcuts):
    order, want = parse_overrides(overrides)
    out, seen, present, cur = [], set(), set(), None

    def add_missing(group):
        if group not in want:
            return
        missing = [(k, v) for k, v in want[group].items() if (group, k) not in seen]
        if not missing:
            return
        tail = []
        while out and not out[-1].strip():
            tail.insert(0, out.pop())
        for key, value in missing:
            out.append(f"{key}={fresh_value(group, key, value, shortcuts)}")
            seen.add((group, key))
        out.extend(tail)

    for line in text.splitlines():
        if line.startswith("["):
            add_missing(cur)
            cur = line.rstrip()
            present.add(cur)
        elif cur in want and "=" in line and not line.lstrip().startswith("#"):
            key, _, live = line.partition("=")
            if key in want[cur]:
                seen.add((cur, key))
                new = apply_value(cur, key, live, want[cur][key], shortcuts)
                if new != live:
                    line = f"{key}={new}"
        out.append(line)
    add_missing(cur)

    for group in order:
        if group in present:
            continue
        if out and out[-1].strip():
            out.append("")
        out.append(group)
        for key, value in want[group].items():
            out.append(f"{key}={fresh_value(group, key, value, shortcuts)}")

    return "\n".join(out) + "\n" if out else ""


def main(overrides, shortcuts):
    sys.stdout.write(merge(sys.stdin.read(), overrides, shortcuts))
