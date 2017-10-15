--Bigbang Procedure
function c624.initial_effect(c)
	if not c624.global_check then
		c624.global_check=true
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c624.op)
		Duel.RegisterEffect(e2,0)
	end
end
function c624.filterx(c)
	return c.bigbang
end
function c624.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c624.filterx,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(624)==0 then
			if not tc.relay then tc:SetStatus(STATUS_NO_LEVEL,true) end
			local e0=Effect.CreateEffect(tc)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e0:SetCode(EFFECT_SPSUMMON_CONDITION)
			if tc.bigbang_only then
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			else
				e0:SetRange(LOCATION_EXTRA)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
			end
			e0:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e0:SetValue(function(e,se,sp,st) return bit.band(st,0x100000)==0x100000 end)
			tc:RegisterEffect(e0)
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetDescription(aux.Stringid(624,0))
			e1:SetRange(LOCATION_EXTRA)
			e1:SetValue(0x100000)
			e1:SetCondition(c624.sumcon)
			e1:SetOperation(c624.sumop)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e2:SetValue(TYPE_XYZ)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(624,RESET_EVENT+EVENT_ADJUST,0,1)  
		end
		tc=g:GetNext()
	end
	if Duel.GetFlagEffect(0,47594939)==0 and Duel.IsExistingMatchingCard(c624.nlrfilter,tp,0xff,0xff,1,nil) then
		local g=Duel.GetMatchingGroup(c624.amafilter,tp,0xdf,0xdf,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
		Duel.SendtoDeck(g,nil,-2,REASON_RULE)
		Duel.RegisterFlagEffect(0,47594939,0,0,1)
	end
end
function c624.amafilter(c)
	return c:GetOriginalCode()==47594939
end
function c624.nlrfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsStatus(STATUS_NO_LEVEL)
end
function c624.matfilter1(c,f,rc,gn,min,tp)
	local mg=Duel.GetMatchingGroup(c624.matfilter2,tp,LOCATION_MZONE,0,c,f)
	return c:IsFaceup() and c:IsRace(rc)
		and mg:CheckWithSumEqual(Card.GetLevel,gn,min,99)
end
function c624.matfilter2(c,f)
	return not f or f(c)
end
function c624.sumcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local gn=c.generation_o
	if c.relay then gn=c:GetRank() end
	local min=1
	if c.material_minct then min=c.material_minct end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-min and Duel.IsExistingMatchingCard(c624.matfilter1,tp,LOCATION_MZONE,0,1,nil,c.material,c.bbmatrc,gn,min,tp)
end
function c624.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local f=c.material
	local gn=c.generation_o
	if c.relay then gn=c:GetRank() end
	local min=1
	if c.material_minct then min=c.material_minct end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(624,1))
	local sg1=Duel.SelectMatchingCard(tp,c624.matfilter1,tp,LOCATION_MZONE,0,1,1,nil,f,c.bbmatrc,gn,min,tp)
	local mc=sg1:GetFirst()
	local mg=Duel.GetMatchingGroup(c624.matfilter2,tp,LOCATION_MZONE,0,mc,f)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(624,1))
	local sg2=mg:SelectWithSumEqual(tp,Card.GetLevel,gn,min,99)
	sg1:Merge(sg2)
	c:SetMaterial(sg1)
	Duel.SendtoGrave(sg1,REASON_MATERIAL+0x40000000)
end
