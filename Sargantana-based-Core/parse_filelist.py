import os
import re

#Retuns (sources, includes, defines)
def parse_filelist(filepath, base_dir=None, env=None, visited=None):
    filepath = os.path.abspath(filepath)
    if visited is None:
        visited = set()
    if filepath in visited:
        return [], [], []
    visited.add(filepath)

    if base_dir is None:
        base_dir = os.path.dirname(filepath)

    if env is None:
        env = dict(os.environ)

    sources = []
    includes = []
    defines = []
    
    def substitute_variables(s):
        return re.sub(
            r'\$\{(\w+)\}|\$(\w+)',
            lambda m: env.get(m.group(1) or m.group(2), m.group(0)),
            s
        )

    def resolve(path):
        path = substitute_variables(path)
        if os.path.isabs(path):
            return os.path.normpath(path)
        return os.path.normpath(os.path.join(base_dir, path))

    with open(filepath, 'r') as fh:
        for raw_line in fh:
            line = raw_line.strip()
            if not line or line.startswith('//'):
                continue
            if line.startswith('-F ') or line.startswith('-f '):
                sub_path = resolve(line[3:])
                sub_base = os.path.dirname(sub_path)
                s, i, d = parse_filelist(sub_path, sub_base, env, visited)
                sources.extend(s)
                includes.extend(i)
                defines.extend(d)
                continue
            if line.startswith('+incdir+'):
                includes.append(resolve(line[8:]))
                continue
            if line.startswith('+define+'):
                defines.append(substitute_variables(line[8:]))
                continue
            if line.startswith('+') or line.startswith('-'):
                continue
            sources.append(resolve(line))

    return sources, includes, defines

HDL_EXTENSIONS = {'.sv', '.v', '.svh', '.vh', '.vhd', '.vhdl'}
C_EXTENSIONS = {'.cpp', '.cc', '.c'}
HEADER_EXTENSIONS = {'.h','.hh','.hpp'}

def classify_sources(sources):
    hdl_files, c_files, headr_files = [], [], []
    for src in sources:
        ext = os.path.splitext(src)[1].lower()
        if ext in HDL_EXTENSIONS:
            hdl_files.append(src)
        elif ext in C_EXTENSIONS:
            c_files.append(src)
        elif ext in HEADER_EXTENSIONS:
            headr_files.append(src)
        else:
            hdl_files.append(src)
    return hdl_files, c_files, headr_files


def extract_verilog_defines(header_path):
    defines = []
    with open(header_path, 'r') as file:
        for raw_line in file:
            line = raw_line.strip()
            m = re.match(r"`define\s+(\w+)(?:\s+(.+))?", line)
            if m:
                name = m.group(1)
                value = m.group(2)
                if value is not None:
                    defines.append(f"{name}={value}")
                else:
                    defines.append(name)
    return defines, os.path.dirname(os.path.abspath(header_path))
