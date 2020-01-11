if not banned_list_table then banned_list_table={} end
local io,string=require('io'),require('string')
local l=io.popen("dir /B /S .\\*lflist.conf")
for lf in l:lines() do
	local f=io.open(lf:gsub(debug.getinfo(3,'S')['source'],""),"r")
	local ls=f:read("a*")
	for id in ls:sub(ls:find("!"),ls:find("!",ls:find("!")+1) and ls:find("!",ls:find("!")+1)-1 or -1):gmatch("([0-9]+) 0") do
		banned_list_table[tonumber(id)]=true
	end
	f:close()
end
l:close()
