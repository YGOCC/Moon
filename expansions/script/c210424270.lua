--Moon Burst: Holder of Power
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
local id2=id+1000000
function cid.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,cid.lfilter,2,2)
    c:EnableReviveLimit()
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    --atk up
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BECOME_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(cid.atkcon)
    e3:SetOperation(cid.atkop)
    c:RegisterEffect(e3)
	--Art swap
	local exx=Effect.CreateEffect(c)
	exx:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	exx:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	exx:SetCode(EVENT_ADJUST)
	exx:SetRange(LOCATION_MZONE)
	exx:SetCondition(cid.artcon)
	exx:SetOperation(cid.artop)
	c:RegisterEffect(exx)
	--Art swap
	local exx2=Effect.CreateEffect(c)
	exx2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	exx2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	exx2:SetCode(EVENT_ADJUST)
	exx2:SetRange(LOCATION_MZONE)
	exx2:SetCondition(cid.artcon2)
	exx2:SetOperation(cid.artop2)
	c:RegisterEffect(exx2)
end
--Art swap
function cid.artcon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
  return (c:GetOriginalCode()==id or c:GetOriginalCode()==id2) and
  e:GetHandler():GetAttack()>=c:GetTextAttack()+1200
end
function cid.artop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=id2
	c:SetEntityCode(tcode,true)
	--c:ReplaceEffect(tcode,0,0)
	--	Duel.SetMetatable(c,_G["c"..tcode])
end
function cid.artcon2(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
  return (c:GetOriginalCode()==id or c:GetOriginalCode()==id2) and 
  e:GetHandler():GetAttack()<c:GetTextAttack()+1200
end
function cid.artop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=id
	c:SetEntityCode(tcode,true)
--	c:ReplaceEffect(tcode,0,0)
--	Duel.SetMetatable(c,_G["c"..tcode])
end
function cid.lfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666)
end
function cid.filter2(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x666)
end
function cid.atkcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(cid.filter2,1,nil,tp)
end
function cid.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(300)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
end