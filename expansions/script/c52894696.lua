--Sacrifice to the Furies
--Scripted by Kedy
--Concept by XStutzX
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cod.condition)
	e1:SetTarget(cod.target)
	e1:SetOperation(cod.activate)
	c:RegisterEffect(e1)
end

--Monster Filter
cod.fit_monster={52894692}

--Ritual Summon
function cod.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf06a)
end
function cod.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cod.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cod.mfilter1(c)
	return c:GetLevel()>0
end
function cod.filter(c,e,tp,m1,m2,ft)
	if not c:IsCode(52894692) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if mg:IsContains(c) then mg:RemoveCard(c) end
	local og=mg:Filter(Card.IsControler,nil,1-tp)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,8,1,99,c)
			or og:IsExists(cod.glvfilter,1,nil,tp,mg,c,c:GetLevel())
	else
		return ft>-1 and mg:IsExists(cod.mfilterf,1,nil,tp,mg,og,c)
	end
end
function cod.mfilterf(c,tp,mg,og,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,8,0,99,rc)
			or og:IsExists(cod.glvfilter,1,nil,tp,mg,rc,rc:GetLevel()-c:GetRitualLevel(rc))
	else return false end
end
function cod.glvfilter(c,tp,mg,rc,lv)
	local lv2=lv-c:GetRitualLevel(rc)
	return mg:CheckWithSumEqual(Card.GetRitualLevel,lv2,0,99,rc)
end
function cod.selcheck(c,tp,mg1,og,mat1,rc)
	local mat=mat1:Clone()
	local mg=mg1:Clone()
	mat:AddCard(c)
	if c:IsControler(1-tp) and c:IsLocation(LOCATION_GRAVE) then
		mg:Sub(og)
	else
		mg:RemoveCard(c)
	end
	local sum=mat:GetSum(Card.GetRitualLevel,rc)
	local lv=rc:GetLevel()-sum
	return rc:IsLevelAbove(sum) and mg:CheckWithSumEqual(Card.GetRitualLevel,lv,0,99,rc)
end
function cod.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(cod.mfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(cod.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function cod.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(cod.mfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cod.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if mg:IsContains(tc) then mg:RemoveCard(tc) end
		local mat=Group.CreateGroup()
		local lv=tc:GetLevel()
		local og=mg:Filter(Card.IsControler,nil,1-tp)
		if ft<=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:FilterSelect(tp,cod.mfilterf,1,1,nil,tp,mg,og,tc):GetFirst()
			lv=lv-mat2:GetRitualLevel(tc)
			mat:AddCard(mat2)
			mg:RemoveCard(mat2)
		end
		while lv~=0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local tg=mg:FilterSelect(tp,cod.selcheck,1,1,nil,tp,mg,og,mat,tc):GetFirst()
			mat:AddCard(tg)
			if tg:IsControler(1-tp) and tg:IsLocation(LOCATION_GRAVE) then
				mg:Sub(og)
			else
				mg:RemoveCard(tg)
			end
			lv=lv-tg:GetRitualLevel(tc)
		end	
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
