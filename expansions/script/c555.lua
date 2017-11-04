--Blink Procedure
function c555.initial_effect(c)
	if not c555.global_check then
		c555.global_check=true
		AI.Chat("'Arcane' Card Type added to the game.")
		AI.Chat("Please check Token 555 for further details~")
		--Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
		--register
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c555.op)
		Duel.RegisterEffect(e2,0)
	end
end

function c555.filter(c)
	return c.blink==true
end
function c555.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c555.filter,0,LOCATION_EXTRA+LOCATION_DECK,LOCATION_EXTRA+LOCATION_DECK,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_DECK) then Duel.SendtoHand(tc,nil,REASON_RULE) end
		if tc:GetFlagEffect(555)==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(function(e) return e:GetHandler():IsLocation(LOCATION_MZONE,LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_EXTRA) end)
			e1:SetValue(TYPE_FUSION)
			tc:RegisterEffect(e1)
			
			--local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
			local te=tc:GetActivateEffect()
			if te then
				local desc=te:GetDescription()
				local cate=te:GetCategory()
				local code=te:GetCode()
				local prop=te:GetProperty()
				local confunc=te:GetCondition()
				local tgfunc=te:GetTarget()
				local opfunc=te:GetOperation()
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(desc)
				e2:SetCategory(cate)
				if tc:IsType(TYPE_QUICKPLAY+TYPE_TRAP) then
					e2:SetType(EFFECT_TYPE_QUICK_O)
				else
					e2:SetType(EFFECT_TYPE_IGNITION)
				end
				e2:SetRange(LOCATION_EXTRA)
				e2:SetCode(code)
				e2:SetProperty(prop)
				e2:SetCost(c555.blinkcost)
				if tc:IsType(TYPE_TRAP) then
					e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetTurnPlayer()~=tp and e:GetHandler():IsFacedown() and e:GetHandler():CheckActivateEffect(false,false,false)~=nil end)
				else
					e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():IsFacedown() and e:GetHandler():CheckActivateEffect(false,false,false)~=nil end)
				end
				if tgfunc then
					e2:SetTarget(tgfunc)
				end
				e2:SetLabelObject(te)
				--if tc.ctlimit then
				--	e2:SetCountLimit(1,tc.ctlimit)
				--end
				e2:SetCountLimit(1,555)
				e2:SetOperation(c555.blinkop)
				e2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
				tc:RegisterEffect(e2)
				
				if tc.ODDcount then
					local e3=Effect.CreateEffect(c)
					if tc:IsType(TYPE_QUICKPLAY+TYPE_TRAP) then
						e3:SetType(EFFECT_TYPE_QUICK_O)
					else
						e3:SetType(EFFECT_TYPE_IGNITION)
					end
					if tc.ODDrange then
						e3:SetRange(tc.ODDrange)
					else
						e3:SetRange(LOCATION_GRAVE)
					end
					e3:SetCode(EVENT_FREE_CHAIN)
					if tc.ODDproperty then
						e3:SetProperty(tc.ODDproperty)
					end
					--if tc.ODDctlimit then
					--	e3:SetCountLimit(1,tc.ODDctlimit)
					--end
					e3:SetCountLimit(1,555)
					if tc.ODDcategory then
						e3:SetCategory(tc.ODDcategory)
					end
					e3:SetCondition(c555.blinkODDcon)
					e3:SetCost(c555.blinkODDcost)
					e3:SetTarget(c555.blinkODDtg)
					e3:SetOperation(c555.blinkODDop)
					e3:SetReset(RESET_EVENT+EVENT_ADJUST,1)
					tc:RegisterEffect(e3)
				end
			else
				print("Activate Effect Error")
			end
			
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_SETCODE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e4:SetValue(0x555)
			tc:RegisterEffect(e4)
			
			tc:RegisterFlagEffect(555,0,0,1)
		end
		tc=g:GetNext()
	end
end
function c555.matfilter1(c,blink,e,tp,eg,ep,ev,re,r,rp)
	return blink.material1 and blink.material1(c,e,tp,eg,ep,ev,re,r,rp) and c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c555.matfilter2,c:GetControler(),LOCATION_HAND,0,1,c,blink,e,tp,eg,ep,ev,re,r,rp)
end
function c555.matfilter2(c,blink,e,tp,eg,ep,ev,re,r,rp)
	return blink.material2 and blink.material2(c,e,tp,eg,ep,ev,re,r,rp) and c:IsDiscardable()
end
function c555.blinkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c.altblinkcost and c.altblinkcost(e,tp,eg,ep,ev,re,r,rp,chk) then
			return true
		end
		if c.exblinkcost then
			return c.exblinkcost(e,tp,eg,ep,ev,re,r,rp,chk) and Duel.IsExistingMatchingCard(c555.matfilter1,tp,LOCATION_HAND,0,1,nil,c)
		else
			return Duel.IsExistingMatchingCard(c555.matfilter1,tp,LOCATION_HAND,0,1,nil,c)
		end
	end
	e:SetLabel(0)
	if c.altblinkcost and c.altblinkcost(e,tp,eg,ep,ev,re,r,rp,0) then
		--For alternative activation procedures
		--Don't forget to include a MoveToField in the alternative Operation!
		if not Duel.IsExistingMatchingCard(c555.matfilter1,tp,LOCATION_HAND,0,1,nil,c) then
			e:SetLabel(1)
			return c.altblinkcost(e,tp,eg,ep,ev,re,r,rp,chk)
		else
			if Duel.SelectYesNo(tp,aux.Stringid(555,0)) then
				e:SetLabel(1)
			return c.altblinkcost(e,tp,eg,ep,ev,re,r,rp,chk)
			end
		end
	end
	if c.exblinkcost then
		--For extra activation proceedures
		c.exblinkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local mc1=Duel.SelectMatchingCard(tp,c555.matfilter1,tp,LOCATION_HAND,0,1,1,nil,c,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local mc2=Duel.SelectMatchingCard(tp,c555.matfilter2,tp,LOCATION_HAND,0,1,1,mc1,c,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	local mg=Group.FromCards(mc1,mc2)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_DISCARD+REASON_MATERIAL)
	local mc=mg:GetFirst()
	while mc do
		Duel.RaiseSingleEvent(mc,EVENT_CUSTOM+555,e,REASON_DISCARD+REASON_MATERIAL,tp,0,0)
		mc=mg:GetNext()
	end
	if c:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
	end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c555.blinkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  e:GetLabel()==1 and c.altblinkop then
		return c.altblinkop(e,tp,eg,ep,ev,re,r,rp)
	end
	local te=e:GetLabelObject()
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	if c:IsLocation(LOCATION_SZONE) and not c:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_FIELD) then
		--c:CancelToGrave()
		Duel.SendtoGrave(c,REASON_RULE)
		--Duel.Destroy(c,REASON_RULE)
		--Duel.SendtoExtraP(c,tp,REASON_RULE)
		--Duel.SendtoDeck(c,nil,0,REASON_RULE)
		--c:ReverseInDeck()
	end
end

function c555.ODDmatfilter1(c,blink,e,tp,eg,ep,ev,re,r,rp)
	return blink.material1 and blink.material1(c,e,tp,eg,ep,ev,re,r,rp) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c555.ODDmatfilter2,tp,LOCATION_GRAVE,0,1,c,blink,e,tp,eg,ep,ev,re,r,rp)
end
function c555.ODDmatfilter2(c,blink,e,tp,eg,ep,ev,re,r,rp)
	return blink.material2 and blink.material2(c,e,tp,eg,ep,ev,re,r,rp) and c:IsAbleToRemove()
end
function c555.ODDfilter(c)
	return true --c.blink and c:IsFaceup()
end
function c555.blinkODDcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.ODDcount and Duel.IsExistingMatchingCard(c555.ODDfilter,c:GetControler(),0,LOCATION_GRAVE,c.ODDcount,nil)
		and not (c:IsType(TYPE_PENDULUM) and c.ODDrange==LOCATION_EXTRA and not c:IsFaceup())
		--and (not c:IsType(TYPE_TRAP) or (Duel.GetTurnPlayer()~=tp))
end
function c555.blinkODDcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c555.ODDmatfilter1,tp,LOCATION_GRAVE,0,1,c,c,e,tp,eg,ep,ev,re,r,rp)
		and (not c.ODDcost or c.ODDcost(e,tp,eg,ep,ev,re,r,rp,0))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mc1=Duel.SelectMatchingCard(tp,c555.ODDmatfilter1,tp,LOCATION_GRAVE,0,1,1,c,c,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	local mc2=Duel.SelectMatchingCard(tp,c555.ODDmatfilter2,tp,LOCATION_GRAVE,0,1,1,mc1,c,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	local mg=Group.FromCards(mc1,mc2)
	c:SetMaterial(mg)
	Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL)
	Duel.RaiseEvent(mg,EVENT_CUSTOM+555,e,REASON_MATERIAL,rp,ep,ev)
	if c.ODDcost then
		c.ODDcost(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c555.blinkODDtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (not c.ODDtg or c.ODDtg(e,tp,eg,ep,ev,re,r,rp,0)) end
	if c.ODDtg then
		c.ODDtg(e,tp,eg,ep,ev,rer,r,rp,1)
	end
	Duel.SetOperationInfo(0,0x80000000,c,1,tp,0)
end
function c555.blinkODDop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c.ODDop then
		c.ODDop(e,tp,eg,ep,ev,re,r,rp)
	end
end
