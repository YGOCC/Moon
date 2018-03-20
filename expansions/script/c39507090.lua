--Chronologist Token
function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end
local id,cod=ID()
cod.link_list={
LINK_MARKER_BOTTOM_LEFT,
LINK_MARKER_BOTTOM,
LINK_MARKER_BOTTOM_RIGHT,
LINK_MARKER_LEFT,
LINK_MARKER_RIGHT,
LINK_MARKER_TOP_LEFT,
LINK_MARKER_TOP,
LINK_MARKER_TOP_RIGHT}

cod.msg_list={
aux.Stringid(39507090,0),
aux.Stringid(39507090,1),
aux.Stringid(39507090,2),
aux.Stringid(39507090,3),
aux.Stringid(39507090,4),
aux.Stringid(39507090,5),
aux.Stringid(39507090,6),
aux.Stringid(39507090,7)}

local function cod.lchk(c)
    local off=1
    local lk={}
    local ops={}
    local opval={}
    local link,msg=cod.link_list,cod.msg_list
    for i=1,8 do
        if c:IsLinkMarker(link[i]) then
            ops[off]=msg[i]
            opval[off-1]=i
            lk[off-1]=link[i]
            off=off+1
        end
    end
    if off==1 then return false end
    return lk,ops
end
local function cod.nlchk(c)
    local off=1
    local lk={}
    local ops={}
    local opval={}
    local link=cod.link_list
    local msg=cod.msg_list
    for i=1,8 do
        if not c:IsLinkMarker(link[i]) then
            ops[off]=msg[i]
            opval[off-1]=i
            lk[off-1]=link[1]
            off=off+1
        end
    end
    if off==1 then return false end
    return lk,ops
end