local json = require("dkjson")  -- Make sure dkjson is installed
local csv = io.open('data.csv', 'w')

function json_to_csv(json_file, csv_file)
    local file = io.open(json_file, "r")
    local data = file:read("*a")
    file:close()

    local decoded_data = json.decode(data)
    local headers = {}

    for k in pairs(decoded_data[1]) do
        table.insert(headers, k)
    end
    csv:write(table.concat(headers, ",") .. "\n")

    for _, row in ipairs(decoded_data) do
        local values = {}
        for _, header in ipairs(headers) do
            table.insert(values, row[header])
        end
        csv:write(table.concat(values, ",") .. "\n")
    end
end

json_to_csv('data.json', 'data.csv')
csv:close()
