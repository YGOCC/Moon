--Xyz-Eyes Priestess
function c249000346.initial_effect(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c249000346.retcon)
	e1:SetTarget(c249000346.rettg)
	e1:SetOperation(c249000346.retop)
	c:RegisterEffect(e1)
	--XYZ
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,249000346)
	e2:SetCondition(c249000346.condition)
	e2:SetCost(c249000346.cost)
	e2:SetTarget(c249000346.target)
	e2:SetOperation(c249000346.operation)
	c:RegisterEffect(e2)
end
function c249000346.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c249000346.retfilter(c)
	return c:IsSetCard(0x4073) and not c:IsCode(249000346) and c:IsAbleToHand()
end
function c249000346.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c249000346.retfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000346.retfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c249000346.retfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c249000346.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c249000346.confilter2(c,rkmin,rkmax)
	return c:GetRank() >= rkmin and c:GetRank() <= rkmax 
end
function c249000346.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000346.confilter2,tp,LOCATION_EXTRA,0,1,nil,1,4)
	and Duel.IsExistingMatchingCard(c249000346.confilter2,tp,LOCATION_EXTRA,0,1,nil,5,6)
	and Duel.IsExistingMatchingCard(c249000346.confilter2,tp,LOCATION_EXTRA,0,1,nil,7,99)
end
function c249000346.cfilter(c)
	return c:IsSetCard(0x4073) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c249000346.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000346.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c249000346.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c249000346.filter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)
end
function c249000346.lvfilter(c,lv)
	return c:GetLevel()==lv
end
function c249000346.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local g1=Duel.GetMatchingGroup(c249000346.filter,tp,LOCATION_HAND,0,nil,e)
		local g2=Duel.GetMatchingGroup(c249000346.filter,tp,LOCATION_HAND,0,nil,e)
		local gg=g1:GetFirst()
		local lv=0
		local mg1=Group.CreateGroup()
		local mg2=nil
		while gg do
			lv=gg:GetLevel()
			mg2=g2:Filter(c249000346.lvfilter,gg,lv)
			if mg2:GetCount()>0 then
				mg1:Merge(mg2)
				mg1:AddCard(gg)
			end		
			gg=g1:GetNext()
		end
		if mg1:GetCount()>1 and Duel.IsExistingMatchingCard(c249000346.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		return true
		else
		return false
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000346.xyzfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c249000346.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g1=Duel.GetMatchingGroup(c249000346.filter,tp,LOCATION_HAND,0,nil,e)
	local g2=Duel.GetMatchingGroup(c249000346.filter,tp,LOCATION_HAND,0,nil,e)
	local gg=g1:GetFirst()
	local lv=0
	local mg1=Group.CreateGroup()
	local mg2=nil
	while gg do
		lv=gg:GetLevel()
		mg2=g2:Filter(c249000346.lvfilter,gg,lv)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			mg1:AddCard(gg)
		end		
		gg=g1:GetNext()
	end
	if mg1:GetCount()>1 and Duel.IsExistingMatchingCard(c249000346.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		local tg1=mg1:Select(tp,1,1,nil):GetFirst()			
		local tg2=mg1:FilterSelect(tp,c249000346.lvfilter,1,1,tg1,tg1:GetLevel())
		tg2:AddCard(tg1)			
		if tg2:GetCount()<2 then return end
		local xyzg=Duel.GetMatchingGroup(c249000346.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:RandomSelect(tp,1):GetFirst()	
			if Duel.SpecialSummonStep(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
				Duel.Overlay(xyz,tg2)
				Duel.SpecialSummonComplete()
				xyz:CompleteProcedure()	
			end				
		end		
	end	
end