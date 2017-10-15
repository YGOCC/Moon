--Adaptive-Magician
function c249000637.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c249000637.condition)
	e1:SetTarget(c249000637.target)
	e1:SetOperation(c249000637.operation)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32999573,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c249000637.rcon)
	e2:SetOperation(c249000637.rop)
	c:RegisterEffect(e2)
	if not c249000637.global_check then
		c249000637.global_check=true
		Card.RegisterEffect_249000637 = Card.RegisterEffect
		function Card:RegisterEffect(e)
			local code=self:GetOriginalCode()
			local cardstruct=_G["c" .. code]
			if not cardstruct.c249000637Effect_Table_Exists then
				cardstruct.c249000637Effect_Table_Exists=true
				cardstruct.c249000637Effect_Table = {}
				cardstruct.c249000637Effect_Count = 1
			end
			cardstruct.c249000637Effect_Table[cardstruct.c249000637Effect_Count] = e
			cardstruct.c249000637Effect_Count=cardstruct.c249000637Effect_Count + 1
			self.RegisterEffect_249000637(self,e)
		end
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2,249000637)
	e3:SetCost(c249000637.cost)
	e3:SetTarget(c249000637.target2)
	e3:SetOperation(c249000637.operation2)
	c:RegisterEffect(e3)
end
c249000637.adaptive_validation=true
function c249000637.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetDrawCount(tp)>0
end
function c249000637.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c249000637.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	_replace_count=_replace_count+1
	if _replace_count<=_replace_max and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c249000637.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(249000637+ep)==0
		and bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0)	and ev==1
end
function c249000637.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(249000637,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c249000637.costfilter(c)
	return c:IsSetCard(0x1E1) and c:IsAbleToRemoveAsCost()
end
function c249000637.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000637.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000637.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000637.tgfilter(c,e)
	if not c:IsType(TYPE_EFFECT) then return false end
	local code=c:GetOriginalCode()
	local cardstruct=_G["c" .. code]
	if cardstruct.adaptive_validation then return false end
	local i=1
	for i=1,cardstruct.c249000637Effect_Count do
		local etemp=cardstruct.c249000637Effect_Table[i]
		if etemp and etemp:IsHasType(EFFECT_TYPE_IGNITION) then 	
			local conf=etemp:GetCondition() 	
			local tef=etemp:GetTarget()
			local cof=etemp:GetCost()
			if not conf or conf(e,tp,eg,ep,ev,re,r,rp) then
				if not tef or tef(e,tp,eg,ep,ev,re,r,rp,0,nil) then
					if not cof or cof(e,tp,eg,ep,ev,re,r,rp,0) then return true end
				end
			end
		end
	end	
	return false
end
function c249000637.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000637.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil,e) end
	local tc=Duel.SelectMatchingCard(tp,c249000637.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,e):GetFirst()
	local code=tc:GetOriginalCode()
	local cardstruct=_G["c" .. code]
	local t={}
	local desc_t = {}
	local i=1
	local p=1
	for i=1,cardstruct.c249000637Effect_Count do
		local etemp=cardstruct.c249000637Effect_Table[i]
		if etemp and etemp:IsHasType(EFFECT_TYPE_IGNITION) then
			local conf=etemp:GetCondition()	
			local tef=etemp:GetTarget()
			local cof=etemp:GetCost()
			if not conf or conf(e,tp,eg,ep,ev,re,r,rp) then
				if not tef or tef(e,tp,eg,ep,ev,re,r,rp,0,nil) then
					if not cof or cof(e,tp,eg,ep,ev,re,r,rp,0) then
						t[p]=etemp desc_t[p]=etemp:GetDescription() p=p+1
					end
				end
			end
		end
	end
	local index=1
	if p < 2 then return end
	if p > 2 then 
		index=Duel.SelectOption(tp,table.unpack(desc_t)) + 1
	end
	local te=t[index]
	Duel.ClearTargetCard()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	e:SetLabelObject(te)
	local co=te:GetCost()
	if co then co(e,tp,eg,ep,ev,re,r,rp,1) end
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	if tc:IsLocation(LOCATION_GRAVE) then Duel.Remove(tc,POS_FACEUP,REASON_COST) end
end
function c249000637.operation2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end