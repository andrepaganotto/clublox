local Utils = {}

local _type = type
local _pairs = pairs

local function _deepCopy(orig, cache)
	if _type(orig) ~= "table" then
		return orig
	end
	if cache[orig] then
		return cache[orig]
	end

	local cp = {}
	cache[orig] = cp
	for k, v in _pairs(orig) do
		-- recurse on both key and value
		cp[_deepCopy(k, cache)] = _deepCopy(v, cache)
	end
	return cp
end

function Utils.copyTable(table)
	return _deepCopy(table, {})
end

return Utils
