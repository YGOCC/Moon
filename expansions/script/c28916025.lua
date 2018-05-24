--Delivery
local ref=_G['c'..28916025]
local id=28916025
function ref.initial_effect(c)
	--Without Tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(ref.ntcon)
	c:RegisterEffect(e1)
	--Quick Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(ref.sumcon)
	e2:SetCost(ref.sumcost)
	e2:SetTarget(ref.sumtg)
	e2:SetOperation(ref.sumop)
	c:RegisterEffect(e2)
	--Destruction Replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(ref.reptg)
	e3:SetValue(ref.repval)
	e3:SetOperation(ref.repop)
	c:RegisterEffect(e3)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e3:SetLabelObject(g)
end

--Without Tribute
function ref.nonfilter(c)
	return c:IsFacedown() or not c:IsAttribute(ATTRIBUTE_FIRE)
end
function ref.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and c:GetLevel()>4
		and not Duel.IsExistingMatchingCard(ref.nonfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

--Quick Summon
function ref.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function ref.cfilter(c)
	return c:IsSetCard(1847) and c:IsAbleToRemoveAsCost()
end
function ref.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_GRAVE,0,2,nil)
		and c:GetFlagEffect(id)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function ref.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil) or c:IsMSetable(true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function ref.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pos=0
	if c:IsSummonable(true,nil) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,nil) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,c,true,nil)
	else
		Duel.MSet(tp,c,true,nil)
	end
end

--Destruction Replace
function ref.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_FAIRY)
end
function ref.repcfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemove()
end
function ref.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(ref.repfilter,nil,tp)
	if chk==0 then return #g>0 end
	local cg=Duel.GetMatchingGroup(ref.repcfilter,tp,LOCATION_GRAVE,0,nil)
	if #g>0 and #cg>0 and Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local rg=e:GetLabelObject()
		rg:Clear()
		if #g==1 then
			g:GetFirst():RegisterFlagEffect(id,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			scg=cg:Select(tp,1,1,nil)
			rg:Merge(scg)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local repg=g:Select(tp,1,cg:GetCount(),nil)
			local rtc=repg:GetFirst()
			while rtc do
				rtc:RegisterFlagEffect(id,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
				rtc=repg:GetNext()
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSS_REMOVE)
			local scg=cg:Select(tp,#repg,#repg,nil)
			rg:Merge(scg)
		end

		return true
	else return false end

end
function ref.rfilter(c)
	return c:GetFlagEffect(id)>0
end
function ref.repval(e,c)
	return ref.rfilter(c)
end
function ref.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g==nil or #g<=0 then return end
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end