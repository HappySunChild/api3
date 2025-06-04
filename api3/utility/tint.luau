local stdio = require "@lune/stdio"

local RESET = stdio.color "reset"

local function tint(text: string, color: stdio.Color, style: stdio.Style?)
	local tinted = stdio.color(color) .. text

	if style then
		tinted = stdio.style(style) .. tinted .. RESET
	end

	return tinted .. RESET
end

return tint
