--Creation Vortex
function c88880042.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--(1) All "CREATION" monsters you control gain 200 ATK for  each card in either players GY.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x889))
	e1:SetValue(c88880042.atkval)
	c:RegisterEffect(e1)
	--(2) Once per turn, if you control at least 1 "CREATION" monster (Quick Effect): draw 1 card for each "CREATION" card you control, then, gain LP equal to the amount of All "CREATION" cards you drew multiplied by 300.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c88880042.dratg)
	e2:SetOperation(c88880042.draop)
	c:RegisterEffect(e2)
	--(3) Once per turn, if a "CREATION" Xyz Monster would use an Xyz Material (Quick Effect): you can send 1 "CREATION" card from your hand to the GY instead.
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88880042,0))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c88880042.rcon)
	e3:SetOperation(c88880042.rop)
	c:RegisterEffect(e3)
	
end
--(1) All "CREATION" monsters you control gain 200 ATK for each card in either players GY.
function c88880042.atkfilter(c)
	return c:IsLocation(LOCATION_GRAVE)
end
function c88880042.atkval(e,c)
	return Duel.GetMatchingGroupCount(c88880042.atkfilter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*100
end
--(2) Once per turn, if you control at least 1 "CREATION" monster (Quick Effect): draw 1 card for each "CREATION" card you control, then, gain LP equal to the amount of All "CREATION" cards you drew multiplied by 300.
function c88880042.filter(c)
	return c:IsSetCard(0x889)
end
function c88880042.dratg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c88880042.filter,tp,LOCATION_ONFIELD,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c88880042.draop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c88880042.filter,tp,LOCATION_ONFIELD,0,nil)
	local ct1=g:GetClassCount(Card.GetCode)
	local ct2=Duel.Draw(p,ct1,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Recover(p,ct2*300,REASON_EFFECT)
end
--(3) Once per turn, if a "CREATION" Xyz Monster would use an Xyz Material (Quick Effect): you can send 1 "CREATION" card from your hand to the GY instead.
function c88880042.rfilter(e,c)
	return e:IsSetCard(0x889)
end
function c88880042.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(88880042+ep)==0
		and bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ)
		and re:GetHandler():GetOverlayCount()>=ev-1
		and re:GetHandler():IsSetCard(0x889)
		and Duel.IsExistingMatchingCard(c88880042.rfilter,tp,LOCATION_HAND,0,1,nil)
end
function c88880042.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	Duel.DiscardHand(tp,c88880042.rfilter,1,1,REASON_COST+REASON_DISCARD)
	if ct>1 then
		re:GetHandler():RemoveOverlayCard(tp,ct-1,ct-1,REASON_COST)
	end
	e:GetHandler():RegisterFlagEffect(88880042+ep,RESET_PHASE+PHASE_END,0,1)
end