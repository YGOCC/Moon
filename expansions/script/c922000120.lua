--Orcadragon - Silvrey
local m=922000120
local cm=_G["c"..m]
local id=m
function cm.initial_effect(c)
	--Pendulum Effects
	aux.EnablePendulumAttribute(c)
	--(p1) Monsters you control, except "Orcadragon" monsters, cannot declare an attack. 
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD)
	ep1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetTargetRange(LOCATION_MZONE,0)
	ep1:SetTarget(cm.atktarget)
	c:RegisterEffect(ep1)
	--(p2) Once per turn, you can Destroy this card and if you do, draw 2 cards.
	local ep2=Effect.CreateEffect(c)
	ep2:SetCategory(CATEGORY_DRAW)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetTarget(cm.drtg)
	ep2:SetOperation(cm.drop)
	ep2:SetCountLimit(1)
	c:RegisterEffect(ep2)
	--Monster Effects
	--(1) You can tribute this card: Special Summon, 1 "Orcadragon" monster from your hand or GY, except "Orcadragon - Silvrey", then, if that card was a level 8 or higher monster: draw 1 card. This effect of "Orcadragon - Silvrey" can only be activated once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2,id)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--(2) Once per turn, you can banish this card face-up card in your Extra Deck: draw 1 card for each level 4 or lower "Orcadragon" monster you control.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(2,id)
	e2:SetCondition(cm.drcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.dr1tg)
	e2:SetOperation(cm.dr1op)
	c:RegisterEffect(e2)
end
--Pendulum Effects
--(p1)
function cm.atktarget(e,c)
	return not c:IsSetCard(0x904)
end
--(p2)
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND)
		e1:SetTarget(cm.destg)
		e1:SetOperation(cm.desop)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetRange(LOCATION_REMOVED+LOCATION_ONFIELD)
		c:RegisterEffect(e2)
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
		return h1
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
--Monster Effects
--(1)
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x904) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetTargetPlayer(tp)
	local tg=Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,tg,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if g:GetFirst():GetLevel()==8 and Duel.IsPlayerCanDraw(tp,1) then
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
		end
	end
end
--(2)
function cm.drcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP)
end
function cm.dfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x904) and c:IsLevelBelow(4)
end
function cm.dr1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.dfilter,tp,LOCATION_MZONE,0,nil)
		local ct=Duel.GetMatchingGroupCount(cm.dfilter,tp,LOCATION_MZONE,0,nil)
		e:SetLabel(ct)
		return ct>0 and Duel.IsPlayerCanDraw(tp,ct)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function cm.dr1op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(cm.dfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.GetMatchingGroupCount(cm.dfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Draw(p,ct,REASON_EFFECT)
end