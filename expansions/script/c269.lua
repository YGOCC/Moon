--Seedling/Bloom Summoning Proceedure
local ref=_G['c'..269]
function ref.initial_effect(c)
	if not ref.global_check then
		ref.global_check=true
		--Register Bloom
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(ref.bloomop)
		Duel.RegisterEffect(e2,0)
	end
end

function ref.bloomfilter(c)
	return c.bloom
end
function ref.bloomop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(ref.bloomfilter,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(269)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetDescription(aux.Stringid(269,0))
			e1:SetRange(LOCATION_EXTRA)
			e1:SetValue(269)
			e1:SetCondition(ref.sumcon)
			e1:SetOperation(ref.sumop)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e2:SetValue(TYPE_FUSION)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(269,RESET_EVENT+EVENT_ADJUST,0,1) 	
		end
		tc=g:GetNext()
	end
end
function ref.matfilter(c,bloom)
	return (c.seedling or c:IsHasEffect(270)) and c:IsFaceup() and c:IsHasEffect(269)
		and bloom.material and bloom.material(c)
end
function ref.sumcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(ref.matfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function ref.sumop(e,tp,eg,ep,ev,re,r,rp,c,og)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(269,1))
	local mat=Duel.SelectMatchingCard(tp,ref.matfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	c:SetMaterial(mat)
	Duel.SendtoGrave(mat,REASON_MATERIAL+269)
end
