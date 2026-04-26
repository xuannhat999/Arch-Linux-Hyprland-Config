-- ~/.config/yazi/init.lua
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end
require("starship"):setup({
	count_separator = " ",
})
require("fs-usage"):setup({
	position = { parent = "Header", align = "RIGHT", order = 2000 },
	format = "both",

	bar = true,

	warning_threshold = 90,

	style_label = {
		fg = "",
		bold = true,
	},
	style_normal = {
		fg = "#89b4fa",
	},
	style_warning = {},
	padding = { open = "", close = "" },
})
require("recycle-bin"):setup()
