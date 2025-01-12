M = {}

M.get_python_executable = function(global)
  local bin = "/usr/local/bin/python"

  if os.getenv "PYENV_ROOT" then
    bin = os.getenv "PYENV_ROOT" .. "/shims/python"
    -- if global then return bin end
    if os.getenv "VIRTUAL_ENV" then return os.getenv "VIRTUAL_ENV" .. "/bin/python" end
  end
  return bin
  -- return bin
end

return M
