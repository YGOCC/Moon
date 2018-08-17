--Lancebreak!
local ref=_G['c'..28916050]
local id=28916050
function ref.initial_effect(c)
	aux.AddEquipProcedure(c,nil,ref.actfilter,nil,nil,nil,ref.ssop,nil,1)
	--statup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--GY Equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(ref.eqtg)
	e4:SetOperation(ref.eqop)
	c:RegisterEffect(e4)
end
function ref.actfilter(c)
	return c:IsRace(RACE_MACHINE)
end

--Activate
function ref.setfilter(c)
	return (c:IsSetCard(1848+1) or c:IsCode(63851864)) and not c:IsForbidden()
end
function ref.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(ref.setfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SSet(tp,sg:GetFirst())
		Duel.ConfirmCards(1-tp,sg)
	end
end

--Special Summon
function ref.ssfilter(c,e,tp)
	return c:IsSetCard(0x1738) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) --and (not c:IsType(TYPE_TUNER))
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(ref.ssfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end

--GY Equip
function ref.eqfilter(c,ec)
	return c:IsSetCard(0xc2) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and ec:CheckEquipTarget(c) and not ec:IsForbidden()
end
function ref.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(ref.eqfilter,1,nil,e:GetHandler()) end
end
function ref.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	local g=eg:Filter(ref.eqfilter,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.Equip(tp,c,tc)
	end
end
