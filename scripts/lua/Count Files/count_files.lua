local lfs = require "lfs"

function count_files(include_node)
    local current_directory = lfs.currentdir()
    
    local all_files = {}
    
    local function recursive_find(dir)
        for file in lfs.dir(dir) do
            if file ~= "." and file ~= ".." then
                local full_path = dir .. '/' .. file
                local attr = lfs.attributes(full_path)
                if attr.mode == "file" then
                    if include_node or not full_path:find("node_modules") then
                        table.insert(all_files, full_path)
                    end
                elseif attr.mode == "directory" then
                    recursive_find(full_path)
                end
            end
        end
    end

    recursive_find(current_directory)

    local total_files = #all_files
    local files_by_extension = {}

    for _, file in ipairs(all_files) do
        local ext = file:match("^.+(%..+)$") or ""
        files_by_extension[ext] = (files_by_extension[ext] or 0) + 1
    end

    -- Output results
    print("\027[96mTotal number of files: \027[0m\027[93m" .. total_files .. "\027[0m")
    print("\027[96mFiles by extension:\027[0m")
    for ext, count in pairs(files_by_extension) do
        print("\027[93m" .. ext .. ": " .. count .. "\027[0m")
    end
end

local include_node = false
for _, arg in ipairs(arg) do
    if arg == "--includenode" then
        include_node = true
        break
    end
end

count_files(include_node)
