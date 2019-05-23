--Orcadragon - Ryuko Crimson
local m=922000119
local cm=_G["c"..m]
local id=m
function cm.initial_effect(c)
	--Pendulum Effects
	aux.EnablePendulumAttribute(c)
	--(p1) While you do not have "Orcadragon - Ascended Ryuko Crimson" in your other Pendulum Zone: you cannot Pendulum Summon monsters, except "Orcadragon" monster.
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ep1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ep1:SetTargetRange(1,0)
	ep1:SetCondition(cm.spcon)
	ep1:SetTarget(cm.splimit)
	c:RegisterEffect(ep1)
	--(p2) Once per turn, you can target 1 "Orcadragon" card in your GY: add that target to your hand.
	local ep2=Effect.CreateEffect(c)
	ep2:SetCategory(CATEGORY_TOHAND)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetTarget(cm.addtg)
	ep2:SetOperation(cm.addop)
	ep2:SetCountLimit(1)
	c:RegisterEffect(ep2)
	--Monster Effects
	--(1) When this card is Normal Summoned: you can special Summon 1 "Orcadragon" monster from your hand.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--(2) Once per turn, when a card you control is destroyed: draw 1 card.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.drcon)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
--Pendulum Effects
--(p1)
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),id-6)
end
function cm.filter(c)
	return c:IsSetCard(0x904)
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	if not (bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM) then return end
	return not cm.filter(c)
end
--(p2)
function cm.addfilter(c,e,tp)
	return c:IsSetCard(0x904) and c:IsAbleToHand(c)
end
function cm.addtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(cm.addfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.addfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.addop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--Monster Effects
--(1)
function cm.filter(c,e,tp)
	return c:IsSetCard(0x904) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--(2)
function cm.cfilter(c,tp)
	return c:IsSetCard(0x904) and c:GetPreviousControler()==tp 
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter,1,nil,tp) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end