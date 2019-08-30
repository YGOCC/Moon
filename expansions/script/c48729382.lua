--Judgment Arrows (Scripted by Moon Burst, Desruc, and Lyris.)
local function getID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
    --Activate (0)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --Link Arrows (Top Right, Top Middle, Top Left) (ex0)
    local ex0=Effect.CreateEffect(c)
    ex0:SetType(EFFECT_TYPE_SINGLE)
    ex0:SetCode(EFFECT_LINK_SPELL_KOISHI)
    ex0:SetRange(LOCATION_SZONE)
    ex0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    ex0:SetValue(LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP+LINK_MARKER_TOP_RIGHT)
    c:RegisterEffect(ex0)
    --ATK Up (Damage Calc.) (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCondition(cid.atkcon)
    e1:SetOperation(cid.atkop)
    c:RegisterEffect(e1)
    --Leave Field = Destroy All Mons Linked (2)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_DESTROY_REPLACE)
    e5:SetRange(LOCATION_SZONE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then return true end
        local seq=c:GetSequence()
        local tc,rc,lc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq),Duel.GetFieldCard(tp,LOCATION_MZONE,seq+1),Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1)
        local g=Group.CreateGroup()
        if tc then g=g+tc end
        if seq<4 and rc then g=g+rc end
        if seq>0 and lc then g=g+lc end
        Duel.Destroy(g,REASON_EFFECT)
        return false
    end)
    c:RegisterEffect(e5)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetCondition(function(e,tp)
        local seq=c:GetSequence()
        local g=Group.CreateGroup()
        local tc,rc,lc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq),Duel.GetFieldCard(tp,LOCATION_MZONE,seq+1),Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1)
        if tc and tc:GetLinkMarker()&LINK_MARKER_BOTTOM~=0 then g=g+tc end
        if seq<4 and rc and rc:GetLinkMarker()&LINK_MARKER_BOTTOM_LEFT~=0 then g=g+rc end
        if seq>0 and lc and lc:GetLinkMarker()&LINK_MARKER_BOTTOM_RIGHT~=0 then g=g+lc end
        return #g==0
    end)
    c:RegisterEffect(e4)
end

--ATK Up (Damage Calc.) (1)
function cid.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return (e:GetHandler():GetLinkedGroup():IsContains(a) and a:GetControler()==tp and a:IsType(TYPE_LINK) and a:IsRelateToBattle())
        or (d~=nil and e:GetHandler():GetLinkedGroup():IsContains(d) and d:GetControler()==tp and d:IsType(TYPE_LINK) and d:IsRelateToBattle())
end

function cid.atkop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=Duel.GetAttackTarget()
    if not c or c:IsControler(1-tp) then c=Duel.GetAttacker() end
    local atk=c:GetAttack()*2
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetValue(atk)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
    c:RegisterEffect(e1)
end

--Leave Field = Destroy All Mons Linked (2)
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject():GetLabelObject():Filter(Card.IsLocation,nil,LOCATION_MZONE)
    Duel.Destroy(g,REASON_EFFECT)
    g:DeleteGroup()
end
