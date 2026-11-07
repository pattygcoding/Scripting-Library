-- Searches files of a given extension for one or more terms.

local lfs = require("lfs")

local MAX_RESULTS = 3000

local function collect_files(directory, extension, results)
  for entry in lfs.dir(directory) do
    if entry ~= "." and entry ~= ".." then
      local full = directory .. "/" .. entry
      local attr = lfs.attributes(full)
      if attr then
        if attr.mode == "directory" then
          collect_files(full, extension, results)
        elseif entry:sub(-#extension) == extension then
          table.insert(results, full)
        end
      end
    end
  end
end

local function escape_pattern(text)
  return (text:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1"))
end

local function main()
  local options = { uncapped = false, cross = false, dir = false, calls = false }
  local positional = {}

  local i = 1
  while i <= #arg do
    local a = arg[i]
    if a == "--uncapped" then
      options.uncapped = true
      i = i + 1
    elseif a == "--cross" then
      options.cross = true
      i = i + 1
    elseif a == "--dir" then
      options.dir = true
      i = i + 1
    elseif a == "--calls" then
      options.calls = true
      i = i + 1
    else
      positional[#positional + 1] = a
      i = i + 1
    end
  end

  local extension = positional[1]
  if not extension or #positional < 2 then
    io.stderr:write("Usage: search-match.lua EXTENSION TERM [TERM...] [options]\n")
    os.exit(1)
  end
  if extension:sub(1, 1) ~= "." then
    extension = "." .. extension
  end

  local terms = {}
  for index = 2, #positional do
    terms[#terms + 1] = positional[index]
  end

  local files = {}
  collect_files(".", extension, files)
  table.sort(files)

  local results_count = 0
  local cap_reached = false

  for _, file in ipairs(files) do
    if cap_reached then
      break
    end

    local printed_name = false
    local skip_using = extension == ".cs"
    local active = not skip_using
    local line_number = 0
    local term_matches = {}
    for _, term in ipairs(terms) do
      term_matches[term] = {}
    end

    local handle = io.open(file, "r")
    if handle then
      for line in handle:lines() do
        line_number = line_number + 1

        if skip_using and line:match("^%s*using ") then
          -- skip leading using directives
        else
          if skip_using then
            active = true
            skip_using = false
          end

          if active then
            for _, term in ipairs(terms) do
              local pattern = escape_pattern(term)
              if line:find(pattern) and (not options.calls or line:find("%." .. pattern)) then
                if options.cross then
                  table.insert(term_matches[term], { line_number, line })
                else
                  if not printed_name then
                    print(options.dir and file or file:match("([^/\\]+)$"))
                    printed_name = true
                  end
                  print(line_number .. "\t" .. (line:gsub("^%s+", "")))
                  results_count = results_count + 1
                  if not options.uncapped and results_count >= MAX_RESULTS then
                    cap_reached = true
                    break
                  end
                end
              end
            end
            if cap_reached then
              break
            end
          end
        end
      end
      handle:close()
    else
      io.stderr:write("An error occurred while processing " .. file .. "\n")
    end

    if options.cross then
      local all_present = true
      for _, term in ipairs(terms) do
        if #term_matches[term] == 0 then
          all_present = false
        end
      end

      if all_present then
        print(options.dir and file or file:match("([^/\\]+)$"))
        for _, term in ipairs(terms) do
          for _, match in ipairs(term_matches[term]) do
            print(match[1] .. "\t" .. (match[2]:gsub("^%s+", "")))
          end
        end
        results_count = results_count + 1
        if not options.uncapped and results_count >= MAX_RESULTS then
          cap_reached = true
        end
      end
    end
  end
end

main()
