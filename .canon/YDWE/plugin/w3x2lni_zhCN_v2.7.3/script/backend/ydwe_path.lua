return function()
    local fs = require 'bee.filesystem'
    local sp = require 'bee.subprocess'
    local function is_ydwe_root(path)
        if not path then
            return false
        end
        return fs.exists(path / 'ui')
            or fs.exists(path / 'share' / 'ui')
            or fs.exists(path / 'share' / 'mpq')
            or fs.exists(path / 'plugin')
            or fs.exists(path / 'YDWE.exe')
            or fs.exists(path / 'KKWE.exe')
            or fs.exists(path / '雪月WE.exe')
    end
    local function try_path(path)
        if is_ydwe_root(path) then
            return path
        end
    end
    local function try_command(command)
        local path = command and command:match '"([^"]*)"'
        if not path then
            return
        end
        local ydwe = fs.path(path):parent_path()
        return try_path(ydwe) or try_path(ydwe:parent_path())
    end
    local p, err = sp.spawn {
        'cmd', '/c',
        'reg', 'query', [[HKEY_CURRENT_USER\SOFTWARE\Classes\YDWEMap\shell\run_war3\command]],
        searchPath = true,
        stdout = true,
    }
    if not p then
        error(err)
        return
    end
    p:wait()
    local command = p.stdout:read 'a'
    local ydwe = try_command(command)
    if ydwe then
        return ydwe
    end

    local base = require('backend.base_path')
    local cwd = fs.current_path()
    local candidates = {
        base,
        base:parent_path(),
        base:parent_path():parent_path(),
        base:parent_path():parent_path() / 'YDWE',
        cwd,
        cwd / 'YDWE',
        cwd:parent_path(),
        cwd:parent_path() / 'YDWE',
    }
    for _, candidate in ipairs(candidates) do
        ydwe = try_path(candidate)
        if ydwe then
            return ydwe
        end
    end
end
