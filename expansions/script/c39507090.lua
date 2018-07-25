--Chronologist Token
Card=Card or {}
local cod=Card

--Link Marker List
cod.link_list={
LINK_MARKER_BOTTOM_LEFT,
LINK_MARKER_BOTTOM,
LINK_MARKER_BOTTOM_RIGHT,
LINK_MARKER_LEFT,
LINK_MARKER_RIGHT,
LINK_MARKER_TOP_LEFT,
LINK_MARKER_TOP,
LINK_MARKER_TOP_RIGHT}

--Message List
cod.msg_list={
aux.Stringid(39507090,0), --Bottom Left
aux.Stringid(39507090,1), --Bottom
aux.Stringid(39507090,2), --Bottom Right
aux.Stringid(39507090,3), --Left
aux.Stringid(39507090,4), --Right
aux.Stringid(39507090,5), --Top Left
aux.Stringid(39507090,6), --Top
aux.Stringid(39507090,7)} --Top Right

--Link Check
--Checks what Link Markers are "on"
--Pass anything through ... to check for what Link Markers are "off"
function Card.LinkCheck(c,...)
    local off=1
    local arg={...}
    local lk={}
    local ops={}
    local link,msg=cod.link_list,cod.msg_list
    for i=1,#link do
        if #arg==0 then
            if c:IsLinkMarker(link[i]) then
                ops[off]=msg[i]
                lk[off-1]=link[i]
                off=off+1
            end
        else
            if not c:IsLinkMarker(link[i]) then
                ops[off]=msg[i]
                lk[off-1]=link[i]
                off=off+1
            end
        end
    end
    if off==1 then return false end
    return lk,ops
end


--Rotated Link Marker Value
--c for card
--ct for number to rotate by
function Card.RLinkVal(c,ct)
    local off=1
    local val=0
    local link=cod.link_list
    for i=1,#link do
        if c:IsLinkMarker(link[i]) then
            if link[i+ct]==nil then
                val=val+link[i-(i-ct)]
            else
                val=val+link[i+ct]
            end
        off=off+1
        end
    end
    if off==1 then return false end
    return val
end