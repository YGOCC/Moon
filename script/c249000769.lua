--Extra-Esper Prodigy
function c249000769.initial_effect(c)
	if aux.AddXyzProcedure then
		if not c249000769_AddXyzProcedure then
			c249000769_AddXyzProcedure=aux.AddXyzProcedure
			aux.AddXyzProcedure = function (c,f,lv,ct,alterf,desc,maxct,op)
				local code=c:GetOriginalCode()
				local mt=_G["c" .. code]
				mt.xyz_minct=ct
				if maxct then mt.xyz_maxct=maxct else mt.xyz_maxct=ct end
				if f then mt.xyz_filter=f end
				c249000769_AddXyzProcedure(c,f,lv,ct,alterf,desc,maxct,op)
			end
		end
	end
	if aux.AddLinkProcedure then
		if not c249000769_AddLinkProcedure then
			c249000769_AddLinkProcedure=aux.AddLinkProcedure
			aux.AddLinkProcedure = function (c,f,min,max)
				local code=c:GetOriginalCode()
				local mt=_G["c" .. code]
				mt.link_minct=min
				if max then mt.link_maxct=max else mt.xyz_maxct=99 end
				if f then mt.link_filter=f end
				c249000769_AddLinkProcedure(c,f,min,max)
			end
		end
	end
	--use as only material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c249000769.cost)
	e1:SetOperation(c249000769.matop)
	c:RegisterEffect(e1)
	--level change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetDescription(aux.Stringid(88581108,0))
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c249000769.atttar)
	e2:SetOperation(c249000769.attop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c249000769.effcon)
	e3:SetOperation(c249000769.effop)
	c:RegisterEffect(e3)
end
function c249000769.costfilter(c)
	return c:IsSetCard(0x1F0) and c:IsAbleToRemoveAsCost()
end
function c249000769.costfilter2(c)
	return c:IsSetCard(0x1F0) and not c:IsPublic()
end
function c249000769.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000769.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	or Duel.IsExistingMatchingCard(c249000769.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler())) end
	local option
	if Duel.IsExistingMatchingCard(c249000769.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler())  then option=0 end
	if Duel.IsExistingMatchingCard(c249000769.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) then option=1 end
	if Duel.IsExistingMatchingCard(c249000769.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	and Duel.IsExistingMatchingCard(c249000769.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000769.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000769.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000769.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(2490007691,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_MZONE)	
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetOperation(c249000769.op)
		c:RegisterEffect(e1)
	end
end
function c249000769.filterx(c)
	return c:IsType(TYPE_XYZ) and c.xyz_minct and c.xyz_minct>0
end
function c249000769.filterL(c)
	return c:IsType(TYPE_LINK) and c.link_minct and c.link_minct>0
end
function c249000769.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c249000769.filterx,c:GetControler(),LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(2490007692)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetDescription(95)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_EXTRA)
			e1:SetValue(SUMMON_TYPE_XYZ)
			e1:SetCondition(c249000769.xyzcon)
			e1:SetOperation(c249000769.xyzop)
			e1:SetLabelObject(c)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(2490007692,RESET_EVENT+EVENT_ADJUST,0,1) 	
		end
		tc=g:GetNext()
	end
	g=Duel.GetMatchingGroup(c249000769.filterL,c:GetControler(),LOCATION_EXTRA,LOCATION_EXTRA,nil)
		local tc=g:GetFirst()
		while tc do
		if tc:GetFlagEffect(2490007692)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetDescription(95)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_EXTRA)
			e1:SetValue(SUMMON_TYPE_LINK)
			e1:SetCondition(c249000769.linkcon)
			e1:SetOperation(c249000769.linkop)
			e1:SetLabelObject(c)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(2490007692,RESET_EVENT+EVENT_ADJUST,0,1) 	
		end
		tc=g:GetNext()
	end
end
function c249000769.xyzcon(e,c,og)
	if c==nil then return true end
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	local tp=c:GetControler()
	local rk=c:GetRank()
	local matcard=e:GetLabelObject()
	if mt.xyz_filter then 
		if not mt.xyz_filter(matcard) then return false end
	end
	return Duel.GetLocationCountFromEx(tp,tp,matcard)>0 and matcard:IsXyzLevel(c,rk) and matcard:GetFlagEffect(2490007692)~=0
end
function c249000769.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local c=e:GetHandler()
	local matcard=e:GetLabelObject()
	Duel.SendtoGrave(matcard,REASON_RULE)
	c:SetMaterial(Group.FromCards(matcard))
	Duel.Overlay(c,matcard)
end
function c249000769.linkcon(e,c,og)
	if c==nil then return true end
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	local tp=c:GetControler()
	local matcard=e:GetLabelObject()
	if mt.link_filter then
		if not mt.link_filter(matcard) then return false end
	end
	return Duel.GetLocationCountFromEx(tp,tp,matcard)>0 and matcard:IsLevelAbove(5) and matcard:GetFlagEffect(2490007692)~=0
end
function c249000769.linkop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local c=e:GetHandler()
	local matcard=e:GetLabelObject()
	Duel.SendtoGrave(matcard,REASON_RULE)
	c:SetMaterial(Group.FromCards(matcard))
	Duel.SendtoGrave(Group.FromCards(matcard),REASON_MATERIAL+REASON_LINK)
end
function c249000769.attfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000769.atttar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) or (chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup())) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(c249000769.attfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c249000769.attfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c249000769.attop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and (tc:IsFaceup() or tc:IsLocation(LOCATION_GRAVE)) and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(tc:GetAttribute())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(tc:GetRace())
		c:RegisterEffect(e2)
	end
end
function c249000769.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c249000769.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(8696773,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c249000769.matcon2)
	e1:SetTarget(c249000769.mattg2)
	e1:SetOperation(c249000769.matop2)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c249000769.matcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c249000769.mattg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c249000769.matop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
