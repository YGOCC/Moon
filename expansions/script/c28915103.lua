--Blazedrive Evopet
local ref=_G['c'..28915103]
local id=28915103
function ref.initial_effect(c)
	--Temp Banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(ref.rmcon)
	e1:SetTarget(ref.rmtg)
	e1:SetOperation(ref.rmop)
	c:RegisterEffect(e1)
	--Extra Material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_EXTRA_EVOLUTE_MATERIAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(ref.matcon)
	e2:SetOperation(ref.matop)
	c:RegisterEffect(e2)
end

--Temp Banish
function ref.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function ref.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanRelease(tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c:GetBattleTarget(),1,0,0)
end
function ref.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if Duel.Release(c,REASON_EFFECT) and tc:IsRelateToBattle() and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(ref.retcon)
		e1:SetOperation(ref.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function ref.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id)~=0
end
function ref.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

--Extra Material
function ref.matcon(c,ec,mode)
	if mode==1 then local tp=c:GetControler() return Duel.IsExistingMatchingCard(ref.xfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,id)==0 end
	return true
end
function ref.xfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function ref.matop(c,ec,tp)
	Duel.Remove(c,POS_FACEUP,REASON_MATERIAL+0x10000000)
	Duel.RegisterFlagEffect(c:GetControler(),id,RESET_PHASE+PHASE_END,0,1)
end