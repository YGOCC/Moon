if not banned_list_table then banned_list_table={} end
local io,string=require('io'),require('string')
Debug.Message("hi")
local l=io.popen("dir /B /S expansions\\*lflist.conf")
for lf in l:lines() do
	Debug.Message(lf)
	local fd=lf:find("expansions")
	if fd then
		lf=".\\"..lf:sub(fd,-1)
		Debug.Message(lf)
		local f=io.open(lf:gsub(debug.getinfo(3,'S')['source'],""),"r")
		local ls=f:read("a*")
		Debug.Message(ls)
		for id in ls:sub(ls:find("!"),ls:find("!",ls:find("!")+1) and ls:find("!",ls:find("!")+1)-1 or -1):gmatch("([0-9]+) 0") do
			Debug.Message(id)
			banned_list_table[tonumber(id)]=true
		end
		f:close()
	end
end
l:close()
