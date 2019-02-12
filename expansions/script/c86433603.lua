--Counterfaker
--Script by XGlitchy30
function c86433603.initial_effect(c)
	--copy spell
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80433603,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,80433603)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c86433603.thtg)
	e1:SetOperation(c86433603.thop)
	c:RegisterEffect(e1)
	--copy trap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80433603,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81433603)
	e2:SetCondition(c86433603.trapreplacecon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c86433603.thtg2)
	e2:SetOperation(c86433603.thop2)
	c:RegisterEffect(e2)
end
--filters
function c86433603.spellfilter(c,tp)
	return c:IsType(TYPE_SPELL) and not c:IsType(TYPE_FIELD) and Duel.IsExistingMatchingCard(c86433603.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetType())
end
function c86433603.trapfilter(c,tp)
	return c:IsType(TYPE_TRAP) and Duel.IsExistingMatchingCard(c86433603.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetType())
end
function c86433603.thfilter(c,typ)
	return c:GetType()==typ and c:IsSSetable()
end
--copy spell
function c86433603.replacecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(87433600)<=0
end
function c86433603.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c86433603.spellfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c86433603.spellfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c86433603.spellfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
end
function c86433603.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c86433603.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetType())
		local tg=g:GetFirst()
		if tg then
			Duel.SSet(tp,tg)
			Duel.ConfirmCards(1-tp,tg)
			tg:RegisterFlagEffect(87433600,RESET_EVENT+EVENT_CUSTOM+11111,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
			--remember copied card
			local rem=Effect.CreateEffect(e:GetHandler())
			rem:SetDescription(aux.Stringid(86433603,3))
			rem:SetType(EFFECT_TYPE_FIELD)
			rem:SetCode(EFFECT_SPSUMMON_PROC_G)
			rem:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			rem:SetRange(LOCATION_SZONE)
			rem:SetLabel(tc:GetOriginalCode())
			rem:SetCondition(c86433603.remcon)
			rem:SetOperation(c86433603.remop)
			rem:SetValue(SUMMON_TYPE_SPECIAL+1)
			tg:RegisterEffect(rem)
			local resetr=Effect.CreateEffect(e:GetHandler())
			resetr:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			resetr:SetCode(EVENT_ADJUST)
			resetr:SetLabelObject(rem)
			resetr:SetCondition(c86433603.resetconcon)
			resetr:SetOperation(c86433603.resetop)
			Duel.RegisterEffect(resetr,tp)
			--cancel original effects
			local egroup0={tg:IsHasEffect(EFFECT_DEFAULT_CALL)}
			for _,te0 in ipairs(egroup0) do
				local ce=te0:GetLabelObject()
				if not ce then
					te0:Reset()
				end
				if ce then
					local con=ce:GetCondition()
					if con then
						ce:SetCondition(aux.ModifyCon(con,c86433603.replacecon))
					else
						ce:SetCondition(c86433603.replacecon)
					end
				end
			end
			--replace effects
			local egroup={tc:IsHasEffect(EFFECT_DEFAULT_CALL)}
			for _,te1 in ipairs(egroup) do
				local ce=te1:GetLabelObject()
				if not ce then
					te1:Reset()
				end
				if ce then
					local e1=ce:Clone()
					tg:RegisterEffect(e1)
					local reset=Effect.CreateEffect(e:GetHandler())
					reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					reset:SetCode(EVENT_ADJUST)
					reset:SetLabelObject(e1)
					reset:SetCondition(c86433603.resetconcon)
					reset:SetOperation(c86433603.resetop)
					Duel.RegisterEffect(reset,tp)
					local reset2=reset:Clone()
					reset2:SetLabelObject(tg)
					reset2:SetCondition(c86433603.resetconcon2)
					reset2:SetOperation(c86433603.resetflag)
					Duel.RegisterEffect(reset2,tp)
				end
			end
		end
	end
end
--copy trap
function c86433603.trapreplacecon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()==1-tp
end
function c86433603.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c86433603.trapfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c86433603.trapfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c86433603.trapfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
end
function c86433603.thop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c86433603.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetType())
		local tg=g:GetFirst()
		if tg then
			Duel.SSet(tp,tg)
			Duel.ConfirmCards(1-tp,tg)
			tg:RegisterFlagEffect(87433600,RESET_EVENT+EVENT_CUSTOM+1111,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
			--enable activation during the same turn it was set
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			tg:RegisterEffect(e0)
			--cancel original effects
			local egroup0={tg:IsHasEffect(EFFECT_DEFAULT_CALL)}
			for _,te0 in ipairs(egroup0) do
				local ce=te0:GetLabelObject()
				if not ce then
					te0:Reset()
				end
				if ce then
					local con=ce:GetCondition()
					if con then
						ce:SetCondition(aux.ModifyCon(con,c86433603.replacecon))
					else
						ce:SetCondition(c86433603.replacecon)
					end
				end
			end
			--replace effects
			local egroup={tc:IsHasEffect(EFFECT_DEFAULT_CALL)}
			for _,te1 in ipairs(egroup) do
				local ce=te1:GetLabelObject()
				if not ce then
					te1:Reset()
				end
				if ce then
					local e1=ce:Clone()
					tg:RegisterEffect(e1)
					local reset=Effect.CreateEffect(e:GetHandler())
					reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					reset:SetCode(EVENT_ADJUST)
					reset:SetLabelObject(e1)
					reset:SetCondition(c86433603.resetconcon)
					reset:SetOperation(c86433603.resetop)
					Duel.RegisterEffect(reset,tp)
					local reset2=reset:Clone()
					reset2:SetLabelObject(tg)
					reset2:SetCondition(c86433603.resetconcon2)
					reset2:SetOperation(c86433603.resetflag)
					Duel.RegisterEffect(reset2,tp)
				end
			end
		end
	end
end
--reset functions
function c86433603.remcon(e,c)
	if c==nil then return true end
	return e:GetLabel()~=0
end
function c86433603.remop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_CARD,c:GetControler(),e:GetLabel())
	return
end
function c86433603.resetconcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject():GetHandler()
	return not c:IsOnField() and not c:IsStatus(STATUS_CHAINING)
end
function c86433603.resetconcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	return not c:IsOnField() and not c:IsStatus(STATUS_CHAINING)
end
function c86433603.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	c:Reset()
	e:Reset()
end
function c86433603.resetflag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	c:ResetFlagEffect(87433600)
	e:Reset()
end