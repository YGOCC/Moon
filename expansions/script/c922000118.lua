--Orcadragon - Penelope
local m=922000118
local cm=_G["c"..m]
local id=m
function cm.initial_effect(c)
	--(1) When a "Orcadragon" monster is Special Summoned to the field: You can Special Summon this card.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--(2) When a "Orcadragon" card is sent to the GY: draw 1 card and if you do, increase this cards ATK by 200 for each "Orcadragon" monster in your hand.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.atkcon)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
end
--(1)
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	 local c=eg:GetFirst()
	return c:IsOnField() and c:IsSetCard(0x904)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--(2)
function cm.cfilter(c,tp)
	return c:IsSetCard(0x904) and c:GetPreviousControler()==tp 
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter,1,nil,tp) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
		Duel.BreakEffect()
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(cm.value)
		c:RegisterEffect(e1)
	end
end
function cm.value(e,c)
	local g=Duel.GetMatchingGroup(cm.addfilter,c:GetControler(),LOCATION_HAND,0,nil)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	return ct*200
end
function cm.addfilter(e,tp,eg,ep,ev,re,r,rp)
	return e:IsSetCard(0x904) and e:IsType(TYPE_MONSTER)
end
