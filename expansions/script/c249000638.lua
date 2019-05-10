--Adaptive-Angel
function c249000638.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000638.spcon)
	e1:SetOperation(c249000638.spop)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32999573,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c249000638.rcon)
	e2:SetOperation(c249000638.rop)
	c:RegisterEffect(e2)
	if not c249000638.global_check then
		c249000638.global_check=true
		Card.RegisterEffect_249000638 = Card.RegisterEffect
		function Card:RegisterEffect(e)
			local code=self:GetOriginalCode()
			local cardstruct=_G["c" .. code]
			if not cardstruct.c249000638Effect_Table_Exists then
				cardstruct.c249000638Effect_Table_Exists=true
				cardstruct.c249000638Effect_Table_Card=self
				cardstruct.c249000638Effect_Table = {}
				cardstruct.c249000638Effect_Count = 1
			end
			if cardstruct.c249000638Effect_Table_Card==self then
				cardstruct.c249000638Effect_Table[cardstruct.c249000638Effect_Count] = e
				cardstruct.c249000638Effect_Count=cardstruct.c249000638Effect_Count + 1
			end
			self.RegisterEffect_249000638(self,e)
		end
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetDescription(aux.Stringid(30312361,0))
	e3:SetCountLimit(2,249000638)
	e3:SetCost(c249000638.cost)
	e3:SetTarget(c249000638.target2)
	e3:SetOperation(c249000638.operation2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c249000638.condition1)
	e4:SetDescription(1066)
	e4:SetTarget(c249000638.target3)
	c:RegisterEffect(e4)
	--init
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)	
	e5:SetOperation(c249000638.tokenop)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(c249000638.condition2)
	e6:SetTarget(c249000638.target4)
	c:RegisterEffect(e6)	
end
c249000638.targetvalidi=true
c249000638.targetvalidq=true
function c249000638.spfilter(c)
	return c:IsSetCard(0x1E1) and c:IsAbleToDeckAsCost()
end
function c249000638.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000638.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil)
end
function c249000638.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000638.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c249000638.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(249000638+ep)==0 and ep==c:GetControler()
		and bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and ev<=2
end
function c249000638.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(249000638,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c249000638.costfilter(c)
	return c:IsSetCard(0x1E1) and c:IsAbleToRemoveAsCost()
end
function c249000638.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000638.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000638.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000638.tgfilter(c,e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not c:IsType(TYPE_EFFECT) then return false end
	local code=c:GetOriginalCode()
	local cardstruct=_G["c" .. code]
	c249000638.targetvalidi=false
	local i=1
	for i=1,cardstruct.c249000638Effect_Count do
		local etemp=cardstruct.c249000638Effect_Table[i]
		if etemp and etemp:IsHasType(EFFECT_TYPE_IGNITION) and e:GetHandler():IsLocation(etemp:GetRange()) then 	
			local conf=etemp:GetCondition() 	
			local tef=etemp:GetTarget()
			local cof=etemp:GetCost()
			if not conf or conf(e,tp,eg,ep,ev,re,r,rp) then
				if not tef or tef(e,tp,eg,ep,ev,re,r,rp,0,nil) then
					c249000638.targetvalidi=true
					if not cof or cof(e,tp,eg,ep,ev,re,r,rp,0) then	return true end
				end
			end
		end
	end
	c249000638.targetvalidi=true
	return false
end
function c249000638.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if c249000638.targetvalidi==false then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c249000638.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil,e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	local tc=Duel.SelectMatchingCard(tp,c249000638.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,e,tp,eg,ep,ev,re,r,rp,chk,chkc):GetFirst()
	local code=tc:GetOriginalCode()
	local cardstruct=_G["c" .. code]
	local t={}
	local desc_t = {}
	local i=1
	local p=1
	for i=1,cardstruct.c249000638Effect_Count do
		local etemp=cardstruct.c249000638Effect_Table[i]
		if etemp and etemp:IsHasType(EFFECT_TYPE_IGNITION) and e:GetHandler():IsLocation(etemp:GetRange()) then
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
function c249000638.operation2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c249000638.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c249000638.tgfilter2(c,e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not c:IsType(TYPE_EFFECT) then return false end
	local code=c:GetOriginalCode()
	local cardstruct=_G["c" .. code]
	c249000638.targetvalidq=false
	local i=1
	for i=1,cardstruct.c249000638Effect_Count do
		local etemp=cardstruct.c249000638Effect_Table[i]
		if etemp and etemp:IsHasType(EFFECT_TYPE_QUICK_O) and e:GetHandler():IsLocation(etemp:GetRange()) and (etemp:GetCode()==EVENT_FREE_CHAIN or (etemp:GetCode()==EVENT_ATTACK_ANNOUNCE and Duel.GetAttacker()) or (etemp:GetCode()~=EVENT_ATTACK_ANNOUNCE and Duel.GetCurrentChain()>0)) then
			local conf=etemp:GetCondition() 	
			local tef=etemp:GetTarget()
			local cof=etemp:GetCost()
			if not conf or conf(e,tp,eg,ep,ev,re,r,rp) then
				if not tef or tef(e,tp,eg,ep,ev,re,r,rp,0,nil) then
					c249000638.targetvalidq=true
					if not cof or cof(e,tp,eg,ep,ev,re,r,rp,0) then	return true end
				end
			end
		end
	end
	c249000638.targetvalidq=true
	return false
end
function c249000638.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if c249000638.targetvalidq==false then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c249000638.tgfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil,e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	local tc=Duel.SelectMatchingCard(tp,c249000638.tgfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,e,tp,eg,ep,ev,re,r,rp,chk,chkc):GetFirst()
	local code=tc:GetOriginalCode()
	local cardstruct=_G["c" .. code]
	local t={}
	local desc_t = {}
	local i=1
	local p=1
	for i=1,cardstruct.c249000638Effect_Count do
		local etemp=cardstruct.c249000638Effect_Table[i]
		if etemp and etemp:IsHasType(EFFECT_TYPE_QUICK_O) and e:GetHandler():IsLocation(etemp:GetRange()) and (etemp:GetCode()==EVENT_FREE_CHAIN or (etemp:GetCode()==EVENT_ATTACK_ANNOUNCE and Duel.GetAttacker())) then
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
function c249000638.tokenop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xFF,0xFF,nil)
	local tc=g:GetFirst()
	while tc do
		local temp=Duel.CreateToken(tp,tc:GetOriginalCode())
		local code=temp:GetOriginalCode()
		local cardstruct=_G["c" .. code]
		if cardstruct.initial_effect then cardstruct.initial_effect(temp) end
		tc=g:GetNext()
	end
end
function c249000638.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function c249000638.tgfilter3(c,e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not c:IsType(TYPE_EFFECT) then return false end
	local code=c:GetOriginalCode()
	local cardstruct=_G["c" .. code]
	c249000638.targetvalidq=false
	local i=1
	for i=1,cardstruct.c249000638Effect_Count do
		local etemp=cardstruct.c249000638Effect_Table[i]
		if etemp and etemp:IsHasType(EFFECT_TYPE_QUICK_O) and e:GetHandler():IsLocation(etemp:GetRange()) and (etemp:GetCode()==EVENT_CHAINING and Duel.GetCurrentChain()>0) then
			local conf=etemp:GetCondition() 	
			local tef=etemp:GetTarget()
			local cof=etemp:GetCost()
			if not conf or conf(e,tp,eg,ep,ev,re,r,rp) then
				if not tef or tef(e,tp,eg,ep,ev,re,r,rp,0,nil) then
					c249000638.targetvalidq=true
					if not cof or cof(e,tp,eg,ep,ev,re,r,rp,0) then	return true end
				end
			end
		end
	end
	c249000638.targetvalidq=true
	return false
end
function c249000638.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if c249000638.targetvalidq==false then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c249000638.tgfilter3,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil,e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	local tc=Duel.SelectMatchingCard(tp,c249000638.tgfilter3,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,e,tp,eg,ep,ev,re,r,rp,chk,chkc):GetFirst()
	local code=tc:GetOriginalCode()
	local cardstruct=_G["c" .. code]
	local t={}
	local desc_t = {}
	local i=1
	local p=1
	for i=1,cardstruct.c249000638Effect_Count do
		local etemp=cardstruct.c249000638Effect_Table[i]
		if etemp and etemp:IsHasType(EFFECT_TYPE_QUICK_O) and e:GetHandler():IsLocation(etemp:GetRange()) and (etemp:GetCode()==EVENT_CHAINING and Duel.GetCurrentChain()>0) then
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