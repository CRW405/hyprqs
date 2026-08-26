local M = {}

-- skips whitespace plus // and /* */ comments; only ever called between tokens, never inside strings
local function skip_ws(s, i)
	while true do
		local _, j = s:find("^[ \t\r\n]*", i)
		i = j + 1
		if s:sub(i, i + 1) == "//" then
			local _, j2 = s:find("[^\n]*", i + 2)
			i = j2 + 1
		elseif s:sub(i, i + 1) == "/*" then
			local closeStart, closeEnd = s:find("*/", i + 2, true)
			assert(closeStart, "unterminated comment at " .. i)
			i = closeEnd + 1
		else
			return i
		end
	end
end

local decode_value -- forward declaration

local function decode_string(s, i)
	assert(s:sub(i, i) == '"', "expected string at " .. i)
	local j = i + 1
	local out = {}
	while true do
		local c = s:sub(j, j)
		if c == "" then
			error("unterminated string at " .. i)
		elseif c == '"' then
			return table.concat(out), j + 1
		elseif c == "\\" then
			local e = s:sub(j + 1, j + 1)
			local map = { ['"'] = '"', ["\\"] = "\\", ["/"] = "/", b = "\b", f = "\f", n = "\n", r = "\r", t = "\t" }
			if map[e] then
				out[#out + 1] = map[e]
				j = j + 2
			elseif e == "u" then
				local hex = s:sub(j + 2, j + 5)
				out[#out + 1] = utf8.char(tonumber(hex, 16))
				j = j + 6
			else
				error("invalid escape at " .. j)
			end
		else
			out[#out + 1] = c
			j = j + 1
		end
	end
end

local function decode_number(s, i)
	local m = s:match("^%-?%d+%.?%d*[eE]?[%+%-]?%d*", i)
	return tonumber(m), i + #m
end

local function decode_object(s, i)
	local obj = {}
	i = skip_ws(s, i + 1)
	if s:sub(i, i) == "}" then
		return obj, i + 1
	end
	while true do
		local key
		key, i = decode_string(s, i)
		i = skip_ws(s, i)
		assert(s:sub(i, i) == ":", "expected ':' at " .. i)
		i = skip_ws(s, i + 1)
		local value
		value, i = decode_value(s, i)
		obj[key] = value
		i = skip_ws(s, i)
		local c = s:sub(i, i)
		if c == "," then
			i = skip_ws(s, i + 1)
		elseif c == "}" then
			return obj, i + 1
		else
			error("expected ',' or '}' at " .. i)
		end
	end
end

local function decode_array(s, i)
	local arr = {}
	i = skip_ws(s, i + 1)
	if s:sub(i, i) == "]" then
		return arr, i + 1
	end
	while true do
		local value
		value, i = decode_value(s, i)
		arr[#arr + 1] = value
		i = skip_ws(s, i)
		local c = s:sub(i, i)
		if c == "," then
			i = skip_ws(s, i + 1)
		elseif c == "]" then
			return arr, i + 1
		else
			error("expected ',' or ']' at " .. i)
		end
	end
end

decode_value = function(s, i)
	local c = s:sub(i, i)
	if c == "{" then
		return decode_object(s, i)
	elseif c == "[" then
		return decode_array(s, i)
	elseif c == '"' then
		return decode_string(s, i)
	elseif s:sub(i, i + 3) == "true" then
		return true, i + 4
	elseif s:sub(i, i + 4) == "false" then
		return false, i + 5
	elseif s:sub(i, i + 3) == "null" then
		return nil, i + 4
	elseif c:match("[%-%d]") then
		return decode_number(s, i)
	else
		error("unexpected character '" .. c .. "' at " .. i)
	end
end

function M.decode(s)
	local value = decode_value(s, skip_ws(s, 1))
	return value
end

return M
