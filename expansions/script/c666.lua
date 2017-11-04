function c666.initial_effect(c)
	if not c666.global_check then
		c666.global_check=true
		c666.trans_point={}
 		c666.trans_point[0]=0
 		c666.trans_point[1]=0
		--register
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c666.op)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SPSUMMON)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCondition(c666.ctcon)
		e3:SetOperation(c666.ctop)
		Duel.RegisterEffect(e3,0)
	end
end
function c666.filter(c)
	return c.transform
end
function c666.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c666.filter,0,LOCATION_EXTRA+LOCATION_DECK,LOCATION_EXTRA+LOCATION_DECK,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_DECK) then Duel.SendtoHand(tc,nil,REASON_RULE) end
		if tc:GetFlagEffect(666)==0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_SPSUMMON_PROC)
			e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetDescription(aux.Stringid(666,0))
			e2:SetRange(LOCATION_EXTRA)
			e2:SetValue(0x6661)
			e2:SetCondition(c666.sumcon)
			e2:SetOperation(c666.sumop)
			e2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e2)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetTarget(function(e) return e:GetHandler():IsLocation(LOCATION_MZONE,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA) end)
			e2:SetValue(TYPE_SYNCHRO)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(666,0,0,1)
		end
		tc=g:GetNext()
	end
end
function c666.matfilter(c,ipr)
	return ipr.material1 and ipr.material1(c) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c666.matfilter2,c:GetControler(),LOCATION_MZONE,0,1,c,ipr)
end
function c666.matfilter2(c,ipr)
	return ipr.material2 and ipr.material2(c)
	and c:IsFaceup() and c:IsAbleToRemove()
end
function c666.sumcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c666.matfilter,tp,LOCATION_MZONE,0,1,nil,c) and Duel.IsExistingMatchingCard(c666.matfilter2,tp,LOCATION_MZONE,0,1,nil,c)
end
function c666.sumop(e,tp,eg,ep,ev,re,r,rp,c,og)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(666,1))
	local mg=Duel.SelectMatchingCard(tp,c666.matfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(666,2))
	local mg2=Duel.SelectMatchingCard(tp,c666.matfilter2,tp,LOCATION_MZONE,0,1,1,mg:GetFirst(),c)
	
	if og then
		local og=mg:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
	end
	Duel.Overlay(c,mg)
	c:SetMaterial(mg2)
	Duel.Remove(mg2,POS_FACEUP,REASON_MATERIAL+0x4b0000)--transformation material
end

function c666.ctfilter(c)
	return c:GetSummonType()==0x6661
end
function c666.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c666.ctfilter,1,nil)
end
function c666.ctop(e,tp,eg,ep,ev,re,r,rp)
	c666.trans_point[rp]=c666.trans_point[rp]+1
	e:GetHandler():SetTurnCounter(c666.trans_point[rp])
end