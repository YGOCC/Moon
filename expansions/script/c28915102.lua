--Evoconnect Peer
local ref=_G['c'..28915102]
local id=28915102
function ref.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,ref.lcheck)
	c:EnableReviveLimit()
	--ATK Gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(ref.atkval)
	c:RegisterEffect(e3)
	--Effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(ref.effcon)
	e1:SetTarget(ref.efftg)
	e1:SetOperation(ref.effop)
	c:RegisterEffect(e1)
	----Material Check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(ref.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end

--Link Summon
function ref.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end

--ATK Gain
function ref.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1088)*100
end

--Material Check
function ref.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_EVOLUTE) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
--Effects
function ref.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function ref.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if (e:GetLabel()==1) then
		--Debug.Message("Used an Evolute as Material!")
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	end
end
function ref.ssfilter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.effop(e,tp,eg,ep,ev,re,r,rp)
	aux.AddECounter(tp,3)
	--Revive
	--Debug.Message("Material, Target: "..tostring(e:GetLabel()==1)..","..tostring(Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)))
	if (e:GetLabel()==1) and Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,ref.ssfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end