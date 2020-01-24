if not banned_list_table then banned_list_table={} end
local string=require('string')
local f=debug.getinfo(1,'S')['source']
Debug.Message(f)
local io=require('io')
local l=io.open(f:sub(f:find("expansions"),-22).."lflist.conf","r")
local ls=l:read("*a")
for id in ls:sub(ls:find("!"),ls:find("!",ls:find("!")+1) and ls:find("!",ls:find("!")+1)-1 or -1):gmatch("([0-9]+) 0") do
	banned_list_table[tonumber(id)]=true
end
l:close()
