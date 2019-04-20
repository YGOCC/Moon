--Moon Burst: Holder of Power
local card = c210424270
local m=210424270
local cm=_G["c"..m]
cm.dfc_front_side=210424279
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function card.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,card.lfilter,2,2)
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
    e3:SetCondition(card.atkcon)
    e3:SetOperation(card.atkop)
    c:RegisterEffect(e3)
		--shift
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(card.accon)
	e4:SetOperation(card.acop)
	c:RegisterEffect(e4)

end
function card.accon(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return e:GetHandler():IsAttackAbove(3000)
end
function card.acop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
Senya.TransformDFCCard(c)
	end
function card.lfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666)
end
function card.filter2(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x666)
end
function card.atkcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(card.filter2,1,nil,tp)
end
function card.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(300)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
end
