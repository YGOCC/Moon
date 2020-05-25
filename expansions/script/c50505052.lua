--Gazing Shadow
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cid=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cid
end
local id,cid=getID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cid.aclimit1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(cid.econ1)
	e3:SetValue(cid.elimit)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetOperation(cid.aclimit3)
	c:RegisterEffect(e4)
	local e6=e3:Clone()
	e6:SetCondition(cid.econ2)
	e6:SetTargetRange(0,1)
	c:RegisterEffect(e6)
    --Direct Attacks
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetTargetRange(0,1)
    c:RegisterEffect(e7)
    --Direct Effects
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e8:SetCode(EVENT_CHAIN_ACTIVATING)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(cid.tgcon)
    e8:SetTarget(cid.tgtg)
    e8:SetOperation(cid.tgop)
    c:RegisterEffect(e8)
end
function cid.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) then return end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function cid.econ1(e)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function cid.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) then return end
	e:GetHandler():RegisterFlagEffect(id+1,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function cid.econ2(e)
	return e:GetHandler():GetFlagEffect(id+1)~=0
end
function cid.elimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)
end
--Effect Redirect
function cid.tgcon(e,tp,eg,ep,ev,re,r,rp)
    if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    e:SetLabelObject(g)
    return g and g:FilterCount(Card.IsOnField,nil)>0
end

function cid.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tf=re:GetTarget()
    local tg=e:GetLabelObject()
    if chkc then return false end
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.HintSelection(Group.FromCards(re:GetHandler()))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,#tg,nil)
end
function cid.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if #g>0 then
        Duel.ChangeTargetCard(ev,g)
    end
end