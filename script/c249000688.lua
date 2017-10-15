--Angelic Summoner of Twilight
function c249000688.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,249000688)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x1E5),1)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK),8,3)
	aux.EnablePendulumAttribute(c,false)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64880894,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,249000688)
	e1:SetCondition(c249000688.drcon)
	e1:SetTarget(c249000688.drtg)
	e1:SetOperation(c249000688.drop)
	c:RegisterEffect(e1)
	--level and rank
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_RANK_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(0xFF)
	c:RegisterEffect(e2)
	--special summon other
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31786629,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c249000688.condition)
	e3:SetCost(c249000688.cost)
	e3:SetTarget(c249000688.target)
	e3:SetOperation(c249000688.operation)
	c:RegisterEffect(e3)
	--pendulum zone draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16178681,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(c249000688.drtg2)
	e4:SetOperation(c249000688.drop2)
	c:RegisterEffect(e4)
end
function c249000688.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c249000688.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c249000688.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		Duel.ShuffleHand(p)
		Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c249000688.spfilter(c)
	return c:IsSetCard(0x1E5) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000688.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000688.ctfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>3
end
function c249000688.rmfilter(c)
	return c:IsSetCard(0x1E5) and c:IsAbleToRemoveAsCost() and ((not c:IsLocation(LOCATION_EXTRA)) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)))
end
function c249000688.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000688.rmfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c249000688.rmfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c249000688.tfilter(c,att,e,tp,lvrk)
	return c:IsAttribute(att) and 
	((c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:GetLevel() > lvrk and c:GetLevel() <= lvrk+3)
	or (c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:GetRank() > lvrk and c:GetRank() <= lvrk+3))
end
function c249000688.filter(c,e,tp)
	local lvrk
	if c:GetLevel() > c:GetRank() then lvrk = c:GetLevel() else lvrk = c:GetRank() end
	return lvrk > 0 and c:IsFaceup() and Duel.IsExistingMatchingCard(c249000688.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp,lvrk)
end
function c249000688.chkfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c249000688.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler() 
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c249000688.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c249000688.filter,tp,LOCATION_MZONE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c249000688.filter,tp,LOCATION_MZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabel(g:GetFirst():GetAttribute())
end
function c249000688.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local att=tc:GetAttribute()
	local lvrk
	if tc:GetLevel() > tc:GetRank() then lvrk = tc:GetLevel() else lvrk = tc:GetRank() end
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c249000688.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp,lvrk):GetFirst()
	if not sc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c249000688.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if sc:IsType(TYPE_XYZ) then
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		if c:GetOverlayGroup():GetCount()>0 then
			local g1=c:GetOverlayGroup()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47660516,0))
			local mg2=g1:Select(tp,1,1,nil)
			local oc=mg2:GetFirst()
			Duel.Overlay(sc,mg2)
			Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		end
		sc:CompleteProcedure()
	else
		sc:SetMaterial(Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()	
	end
end
function c249000688.damval(e,re,val,r,rp,rc)
	return val/2
end
function c249000688.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000688.drop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end