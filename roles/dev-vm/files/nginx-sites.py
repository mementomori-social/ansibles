"""Read `nginx -T` from stdin and print, as JSON, where site files go and which
files already serve the domain given as the first argument."""

import json
import os
import re
import sys

MARKER = 'Managed by mementomori-social/ansibles'
# Preferred first: the layout most local setups use for one file per site.
SITE_DIRS = [
    (re.compile(r'(.*/sites-enabled)/\*$'), ''),
    (re.compile(r'(.*/servers)/\*$'), '.conf'),
    (re.compile(r'(.*/conf\.d)/\*\.conf$'), '.conf'),
]

domain = sys.argv[1]
files = re.split(r'^# configuration file (.+):$', sys.stdin.read(), flags=re.M)[1:]
files = list(zip(files[0::2], files[1::2]))
conf_dir = os.path.dirname(files[0][0])

includes = []
existing = []
for path, text in files:
    code = re.sub(r'#.*', '', text)
    for pattern in re.findall(r'^\s*include\s+([^;]+);', code, flags=re.M):
        includes.append(os.path.join(conf_dir, pattern.strip()))

    names = [n for d in re.findall(r'(?<![\w])server_name\s+([^;]+);', code) for n in d.split()]
    if domain in names:
        others = sorted({n for n in names if n not in (domain, '_')})
        existing.append({'path': path, 'others': others, 'managed': MARKER in text})

for regex, suffix in SITE_DIRS:
    for include in includes:
        match = regex.match(include)
        if match:
            print(json.dumps({'site_dir': match.group(1), 'suffix': suffix, 'existing': existing}))
            sys.exit(0)

sys.exit('nginx has no sites-enabled, servers or conf.d include to add a site to')
