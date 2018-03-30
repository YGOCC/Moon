--Towards the Beginning
--Script by XGlitchy30
function c37200258.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37200258+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c37200258.cost)
	e1:SetTarget(c37200258.target)
	e1:SetOperation(c37200258.activate)
	c:RegisterEffect(e1)
end
--filters
function c37200258.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c37200258.spfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==lv
end
function c37200258.rmfilter(c,fid)
	return c:GetFlagEffectLabel(37200258)==fid
end
function c37200258.rtfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
--Activate
function c37200258.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200258.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c37200258.costfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		local op=Duel.GetOperatedGroup()
		e:SetLabel(op:GetCount())
	end
end
function c37200258.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lv=Duel.GetMatchingGroup(c37200258.costfilter,tp,LOCATION_GRAVE,0,nil) 
		return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c37200258.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv:GetCount()) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c37200258.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	local fid=c:GetFieldID()
	if Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c37200258.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		local sp=g:GetFirst()
		if Duel.SpecialSummonStep(sp,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sp:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			sp:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCountLimit(1)
			e3:SetCondition(c37200258.rmcon)
			e3:SetOperation(c37200258.rmop)
			e3:SetLabel(fid)
			e3:SetLabelObject(sp)
			Duel.RegisterEffect(e3,tp)
			sp:RegisterFlagEffect(37200258,RESET_EVENT+0x1fe0000,0,1,fid)
			Duel.SpecialSummonComplete()
		end
		local material=Effect.CreateEffect(sp)
		material:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		material:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		material:SetCode(EVENT_BE_MATERIAL)
		material:SetCondition(c37200258.effectcon)
		material:SetTarget(c37200258.effecttg)
		material:SetOperation(c37200258.effectop)
		material:SetReset(RESET_EVENT+0x1fe0000)
		sp:RegisterEffect(material)
	end
end
function c37200258.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(37200258)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c37200258.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetLabelObject(),POS_FACEUP,REASON_EFFECT)
end
--material effects
function c37200258.effectcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c37200258.effecttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c37200258.effectop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rm=Duel.GetMatchingGroup(c37200258.rtfilter,tp,LOCATION_REMOVED,0,nil)
	if rm:GetCount()>0 then
		Duel.SendtoDeck(rm,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end