if not banned_list_table then banned_list_table={} end
local io,string=require'io',require'string'
local ls=io.open("expansions/lflist.conf"):read("*a")
for id in ls:sub(ls:find("!"),ls:find("!",ls:find("!")+1) and ls:find("!",ls:find("!")+1)-1 or -1):gmatch("([0-9]+) 0") do
	banned_list_table[tonumber(id)]=true
end
