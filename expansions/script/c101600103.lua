--The Call of Signers
function c101600103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetTarget(c101600103.target)
	e1:SetOperation(c101600103.activate)
	e1:SetCountLimit(1,101600113+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e1)
end
function c101600103.str(c)
	if not (c:GetLevel()==8 and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_SYNCHRO)) then return end
	return c:IsSetCard(0xa3)
end
function c101600103.arc(c)
	if not (c:GetLevel()==8 and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_SYNCHRO)) then return end
	return c:IsSetCard(0x45)
end
function c101600103.bw(c)
	if not (c:GetLevel()==8 and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_SYNCHRO)) then return end
	return c:IsCode(9012916,101600112)
end
function c101600103.af(c)
	if not (c:GetLevel()==7 and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_SYNCHRO)) then return end
	return c:IsCode(25862681,101600113)
end
function c101600103.pwr1(c)
	if not (c:GetLevel()==7 and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_SYNCHRO)) then return end
	return c:IsSetCard(0xc2) or c:IsCode(101600114,25165047)
end
function c101600103.pwr2(c)
	if not (c:GetLevel()==8 and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_SYNCHRO)) then return end
	return c:IsSetCard(0xc2) or c:IsCode(101600114,25165047)
end
function c101600103.pwr3(c)
	if not (c:GetLevel()==8 and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_SYNCHRO)) then return end
	return c:IsSetCard(0xc2) or c:IsCode(101600114,25165047)
end
function c101600103.pwr4(c)
	if not (c:GetLevel()==7 and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_SYNCHRO)) then return end
	return c:IsSetCard(0xc2) or c:IsCode(101600114,25165047)
end
function c101600103.br(c)
	if not (c:GetLevel()==7 and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_SYNCHRO)) then return end
	return c:IsCode(73580471,101600115)
end
function c101600103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local str=Duel.GetMatchingGroup(c101600103.str,tp,LOCATION_EXTRA,0,nil)
	local arc=Duel.GetMatchingGroup(c101600103.arc,tp,LOCATION_EXTRA,0,nil)
	local bw=Duel.GetMatchingGroup(c101600103.bw,tp,LOCATION_EXTRA,0,nil)
	local af=Duel.GetMatchingGroup(c101600103.af,tp,LOCATION_EXTRA,0,nil)
	local pwr1=Duel.GetMatchingGroup(c101600103.pwr1,tp,LOCATION_EXTRA,0,nil)
	local pwr2=Duel.GetMatchingGroup(c101600103.pwr2,tp,LOCATION_EXTRA,0,nil)
	local pwr3=Duel.GetMatchingGroup(c101600103.pwr3,tp,LOCATION_EXTRA,0,nil)
	local pwr4=Duel.GetMatchingGroup(c101600103.pwr4,tp,LOCATION_EXTRA,0,nil)
	local pwr=Group.CreateGroup()
	pwr:Merge(pwr1)
	pwr:Merge(pwr2)
	pwr:Merge(pwr3)
	pwr:Merge(pwr4)
	local br=Duel.GetMatchingGroup(c101600103.br,tp,LOCATION_EXTRA,0,nil)
	-- Debug.Message("str: "..str:GetCount().." arc: "..arc:GetCount().." bw: "..bw:GetCount().." af: "..af:GetCount().."pwr: "..pwr:GetCount().." br: "..br:GetCount())
	if chk==0 then return str:GetCount()>0 and arc:GetCount()>0 and bw:GetCount()>0 and af:GetCount()>0 and pwr:GetCount()>0 and br:GetCount()>0
		and Duel.IsExistingMatchingCard(function(c) return c:IsCode(101600116) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,nil)
	end
	local g=Group.CreateGroup()
	if str:GetCount()==1 then
		g:AddCard(str:GetFirst())
	else
		local add=str:Select(tp,1,1,nil):GetFirst()
		g:AddCard(add)
	end
	if arc:GetCount()==1 then
		g:AddCard(arc:GetFirst())
	else
		local add=arc:Select(tp,1,1,nil):GetFirst()
		g:AddCard(add)
	end
	if bw:GetCount()==1 then
		g:AddCard(bw:GetFirst())
	else
		local add=bw:Select(tp,1,1,nil):GetFirst()
		g:AddCard(add)
	end
	if af:GetCount()==1 then
		g:AddCard(af:GetFirst())
	else
		local add=af:Select(tp,1,1,nil):GetFirst()
		g:AddCard(add)
	end
	if br:GetCount()==1 then
		g:AddCard(br:GetFirst())
	else
		local add=br:Select(tp,1,1,nil):GetFirst()
		g:AddCard(add)
	end
	if pwr:GetCount()==1 then
		g:AddCard(pwr:GetFirst())
	else
		local add=pwr:Select(tp,1,1,nil):GetFirst()
		g:AddCard(add)
	end
	local tc=g:GetFirst()
	for i=1,6 do
		Duel.ConfirmCards(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		tc=g:GetNext()
	end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c) return c:IsCode(101600116) end)
	Duel.RegisterEffect(e1,tp)
end
function c101600103.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.GetFirstMatchingCard(function(c) return c:IsCode(101600116) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,nil)
	local chk=Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	if chk<=0 then return end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(function(e,c)return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DRAGON) end)
	Duel.RegisterEffect(e3,tp)
end
