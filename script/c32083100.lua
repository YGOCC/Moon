--c32083100
function c32083100.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetDescription(aux.Stringid(32083100,0))
	e1:SetCondition(c32083100.condition)
	e1:SetTarget(c32083100.target)
	e1:SetOperation(c32083100.operation)
	c:RegisterEffect(e1)
		--copy	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)	
	e2:SetOperation(c32083100.op)
	c:RegisterEffect(e2)
end
function c32083100.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function c32083100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32083100.operation(e,tp,eg,ep,ev,re,r,rp)
Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
end
function c32083100.filter(c)
	return c:IsSetCard(0x7D53) and c:IsType(TYPE_MONSTER)
end
function c32083100.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local wg=Duel.GetMatchingGroup(c32083100.filter,c:GetControler(),LOCATION_REMOVED,0,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
		c:CopyEffect(code, RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1) 	
		end	
		wbc=wg:GetNext()
	end		
end