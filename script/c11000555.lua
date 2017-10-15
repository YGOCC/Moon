--Popstar Ahri
function c11000555.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(c11000555.chop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11000555,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,11000555)
	e3:SetCondition(c11000555.hspcon)
	e3:SetTarget(c11000555.hsptg)
	e3:SetOperation(c11000555.hspop)
	c:RegisterEffect(e3)
end
function c11000555.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp then return end
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	if de and dp==tp and de:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) then
		local ty=re:GetActiveType()
		local flag=c:GetFlagEffectLabel(11000555)
		if not flag then
			c:RegisterFlagEffect(11000555,RESET_EVENT+0x1fe0000,0,0,ty)
			e:SetLabelObject(de)
		elseif de~=e:GetLabelObject() then
			e:SetLabelObject(de)
			c:SetFlagEffectLabel(11000555,ty)
		else
			c:SetFlagEffectLabel(11000555,bit.bor(flag,ty))
		end
	end
end
function c11000555.hspcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label=c:GetFlagEffectLabel(11000555)
	if label~=nil and label~=0 then
		e:SetLabel(label)
		c:SetFlagEffectLabel(11000555,0)
		return true
	else return false end
end
function c11000555.filter(c,e,tp)
	return c:IsSetCard(0x1FE) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11000555.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11000555.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11000555.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11000555.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end