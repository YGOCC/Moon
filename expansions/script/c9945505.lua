--Zodiakieri Sagittarius
function c9945505.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9945505.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9945505,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9945505)
	e2:SetTarget(c9945505.destg)
	e2:SetOperation(c9945505.desop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9945505,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c9945505.cost)
	e3:SetTarget(c9945505.actg)
	e3:SetCountLimit(3,9945460)
	e3:SetOperation(c9945505.acop)
	c:RegisterEffect(e3)
end
function c9945505.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x12D7)
end

function c9945505.desfilter(c)
	return c:IsDestructable()
end
function c9945505.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c9945505.desfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c9945505.desfilter,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.IsExistingMatchingCard(c9945505.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9945505.desfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c9945505.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c9945505.desfilter,tp,0,LOCATION_SZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end

function c9945505.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(9945505)==0 end
	e:GetHandler():RegisterFlagEffect(9945505,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c9945505.filter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not (te:IsActivatable(c:GetControler()) or (c:IsHasEffect(EFFECT_CANNOT_TRIGGER) and not c:IsFaceup() and not (c:IsStatus(STATUS_SET_TURN) and c:IsType(TYPE_QUICKPLAY)))) or not c:IsSetCard(0x12D7) then return false end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	if te:GetCode()==EVENT_FREE_CHAIN then
		return (not condition or condition(te,c:GetControler(),eg,ep,ev,re,r,rp)) 
			and (not cost or cost(te,c:GetControler(),eg,ep,ev,re,r,rp,0))
			and (not target or target(te,c:GetControler(),eg,ep,ev,re,r,rp,0))
	elseif te:GetCode()==EVENT_CHAINING then
		return (not condition or condition(te,c:GetControler(),Group.FromCards(e:GetHandler()),tp,0,e,r,tp)) 
			and (not cost or cost(te,c:GetControler(),Group.FromCards(e:GetHandler()),tp,0,e,r,tp,0))
			and (not target or target(te,c:GetControler(),Group.FromCards(e:GetHandler()),tp,0,e,r,tp,0))
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		return res and (not condition or condition(te,c:GetControler(),teg,tep,tev,tre,tr,trp)) 
			and (not cost or cost(te,c:GetControler(),teg,tep,tev,tre,tr,trp,0))
			and (not target or target(te,c:GetControler(),teg,tep,tev,tre,tr,trp,0))
	end
	return c:IsSetCard(0x12D7) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsFaceup()
		and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_SZONE) and c:IsFacedown())) 
end


function c9945505.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945505.filter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
end
function c9945505.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c9945505.filter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil):GetFirst()
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	if bit.band(tpe,TYPE_FIELD)~=0 and not tc:IsType(TYPE_FIELD) and not tc:IsFacedown() then
		local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
		if Duel.IsDuelType(DUEL_OBSOLETE_RULING) then
			if fc then Duel.Destroy(fc,REASON_RULE) end
			fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc and Duel.Destroy(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		else
			fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc and Duel.SendtoGrave(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		end
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if tc and tc:IsFacedown() then Duel.ChangePosition(tc,POS_FACEUP) end
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	tc:CreateEffectRelation(te)
	if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
		tc:CancelToGrave(false) 	
	end
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then
		local etc=g:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc=g:GetNext()
		end
	end
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	if etc then	
		etc=g:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=g:GetNext()
		end
	end
end