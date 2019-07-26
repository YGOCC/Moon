--Starlignment of the Earth - Haruna
--Scripted by: XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLevel,4),2,2)
	--protection
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(cid.prttg)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cid.thcost)
	e1:SetTarget(cid.thtg)
	e1:SetOperation(cid.thop)
	c:RegisterEffect(e1)
	--extra effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(cid.eop)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2x)
	local e2y=e2:Clone()
	e2y:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2y)
end
--filters
function cid.prttg(e,c)
	return c:IsType(TYPE_XYZ) and c:IsRank(4)
end
--search
function cid.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cid.thfilter(c)
	return c:IsSetCard(0x2595) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cid.hcheck(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			local og=g:Filter(cid.hcheck,nil,tp)
			if #og<=0 then return end
			Duel.ConfirmCards(1-tp,og)
			for tc in aux.Next(og) do
				--prevent hand effects
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetValue(cid.actlimit)
				e1:SetLabel(tc:GetOriginalCode())
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
--SECONDARY-LEVEL EFFECT: prevent hand effects
function cid.actlimit(e,re,tp)
	return re:GetHandler():GetOriginalCode()==e:GetLabel() and bit.band(re:GetRange(),LOCATION_HAND)>0
end
--extra effects
function cid.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	if opt==0 then
		--special summon xyz
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetCountLimit(1,id+100)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(cid.xyztg)
		e1:SetOperation(cid.xyzop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	else
		--reveal xyz
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1,id+200)
		e1:SetCost(cid.ptcost)
		e1:SetTarget(cid.pttg)
		e1:SetOperation(cid.ptop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end
--spsummon
function cid.xyzmat(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2595) and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
end
function cid.xyzfilter(c,e,tp)
	return c:IsRank(4) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and cid.xyzmat(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.xyzmat,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil)
		and Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(cid.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cid.xyzmat,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	local gchk=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #gchk>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,gchk,#gchk,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cid.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g==1 then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local og=Duel.GetOperatedGroup():GetFirst()
				local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
				if og:IsFaceup() and og:IsType(TYPE_XYZ) and #tg>0 then
					Duel.Overlay(og,tg)
				end
			end
		end
	end
end
--reveal xyz
function cid.costfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not c:IsRank(4) or not c:IsType(TYPE_XYZ) or not c:IsType(TYPE_EFFECT) or c:IsFaceup() or c:IsSetCard(0x2595) 
		or not Duel.IsExistingMatchingCard(cid.rmfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetCode()) then return false 
	end
	local check=0
	local egroup={c:IsHasEffect(EFFECT_DEFAULT_CALL)}
	for _,te1 in ipairs(egroup) do
		local ce=te1:GetLabelObject()
		if type(ce)~="userdata" then
			Debug.Message(tostring(type(ce)))
		end
		if not ce or ce==nil or type(ce)~="userdata" or ce:GetType()==nil then
			Debug.Message("reset")
			te1:Reset()
			if ce then
				ce:Reset()
			end
		else
			local cost,tg=ce:GetCost(),ce:GetTarget()
			if (ce:IsHasType(EFFECT_TYPE_IGNITION) or ce:IsHasType(EFFECT_TYPE_TRIGGER_O) or ce:IsHasType(EFFECT_TYPE_TRIGGER_F) or ce:IsHasType(EFFECT_TYPE_QUICK_O) or ce:IsHasType(EFFECT_TYPE_QUICK_F))
				and bit.band(ce:GetRange(),LOCATION_MZONE)~=0 and cost and not cost(e,tp,eg,ep,ev,re,r,rp,0) and (not tg or tg==nil or (tg and tg(e,tp,eg,ep,ev,re,r,rp,0))) then
					check=check+1
			end
		end
	end
	return check>0
end
function cid.rmfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function cid.chkflag(c,e)
	return c:GetFlagEffect(id)>0 and c:IsRelateToEffect(e) and c:GetOverlayCount()>0
end
function cid.tgxyz(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(cid.matxyz,1,nil)
end
function cid.matxyz(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2595)
end
function cid.ptcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cid.pttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.tgxyz(chkc) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local checkmaster=0
		local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		if #g<=0 then return false end
		for tc in aux.Next(g) do
			if cid.costfilter(tc,e,tp,eg,ep,ev,re,r,rp) then
				checkmaster=checkmaster+1
			end
		end
		return checkmaster>0 and Duel.IsExistingTarget(cid.tgxyz,tp,LOCATION_MZONE,0,2,nil)
	end
	e:SetLabel(0)
	local c=e:GetHandler()
	local ed=Group.CreateGroup()
	ed:KeepAlive()
	local g0=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	if #g0<=0 then return end
	for tc0 in aux.Next(g0) do
		if cid.costfilter(tc0,e,tp,eg,ep,ev,re,r,rp) then
			ed:AddCard(tc0)
		end
	end
	if #ed<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=ed:Select(tp,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		local rv=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tcg=Duel.SelectTarget(tp,cid.tgxyz,tp,LOCATION_MZONE,0,2,2,nil)
		if #tcg>0 then
			Duel.ClearTargetCard()
			local tc=tcg:GetFirst()
			while tc do
				tc:RegisterFlagEffect(id,RESET_CHAIN,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
				tc:CreateEffectRelation(e)
				tc=tcg:GetNext()
			end
			local flag,desc=1,{}
			local egroup={rv:IsHasEffect(EFFECT_DEFAULT_CALL)}
			for _,te1 in ipairs(egroup) do
				local ce=te1:GetLabelObject()
				if type(ce)~="userdata" then
					Debug.Message(tostring(type(ce)))
				end
				if not ce or ce==nil or type(ce)~="userdata" or ce:GetType()==nil then
					Debug.Message("reset")
					te1:Reset()
					if ce then
						ce:Reset()
					end
				else 
					local cost,tg=ce:GetCost(),ce:GetTarget()
					if (ce:IsHasType(EFFECT_TYPE_IGNITION) or ce:IsHasType(EFFECT_TYPE_TRIGGER_O) or ce:IsHasType(EFFECT_TYPE_TRIGGER_F) or ce:IsHasType(EFFECT_TYPE_QUICK_O) or ce:IsHasType(EFFECT_TYPE_QUICK_F))
						and bit.band(ce:GetRange(),LOCATION_MZONE)>0 and cost and not cost(e,tp,eg,ep,ev,re,r,rp,0) and (not tg or tg==nil or (tg and tg(e,tp,eg,ep,ev,re,r,rp,0))) then
							local eflag=Effect.CreateEffect(c)
							eflag:SetType(EFFECT_TYPE_FIELD)
							eflag:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
							eflag:SetCode(EFFECT_DEFAULT_CALL)
							eflag:SetTargetRange(1,1)
							eflag:SetLabel(id+flag)
							eflag:SetLabelObject(ce)
							--eflag:SetCondition(function (e,tp,eg,ep,ev,re,r,rp) return false end)
							eflag:SetReset(RESET_CHAIN)
							Duel.RegisterEffect(eflag,tp)
							if ce:GetDescription() then
								table.insert(desc,ce:GetDescription())
							else
								table.insert(desc,aux.Stringid(id,0))
							end
							flag=flag+1
						
					end
				end
			end
			if #desc>0 then
				local opt=Duel.SelectOption(tp,table.unpack(desc))+1
				if opt>0 then
					local egroup2={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DEFAULT_CALL)}
					for _,te2 in ipairs(egroup2) do
						if type(te2)~="userdata" then
							Debug.Message(tostring(type(te2)))
						end
						if not te2 or te2==nil or type(te2)~="userdata" or te2:GetType()==nil then
							Debug.Message("reset")
							te2:Reset()
							if te2 then
								te2:Reset()
							end
						else
							if te2:GetLabel()==id+opt then
								local effect=te2:GetLabelObject()
								local tgt=effect:GetTarget()
								if tgt then tgt(e,tp,eg,ep,ev,re,r,rp,1) end
								effect:SetLabelObject(e:GetLabelObject())
								e:SetLabelObject(effect)
								Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
							end
						end
					end
				end
			end
		end
	end
end
function cid.ptop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local tc=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE):Filter(cid.chkflag,nil,e)
	if not te then return end
	if #tc<=1 then return end
	local gg=Group.CreateGroup()
	for tt in aux.Next(tc) do
		gg:Merge(tt:GetOverlayGroup())
	end
	if Duel.SendtoGrave(gg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		local rg=Duel.GetMatchingGroup(cid.rmfilter,tp,LOCATION_EXTRA,0,nil,te:GetHandler():GetCode())
		if #rg>0 then
			if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local fid=c:GetFieldID()
				local og=Duel.GetOperatedGroup()
				local oc=og:GetFirst()
				local turnp=1
				if Duel.GetTurnPlayer()~=tp then
					turnp=2
				end
				while oc do
					oc:RegisterFlagEffect(id+300,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,turnp,fid)
					oc:RegisterFlagEffect(id+301,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,turnp,Duel.GetTurnCount())
					oc=og:GetNext()
				end
				og:KeepAlive()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(og)
				e1:SetCondition(cid.retcon)
				e1:SetOperation(cid.retop)
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,turnp)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function cid.retfilter(c,fid,turn)
	return c:GetFlagEffectLabel(id+300)==fid and c:GetFlagEffectLabel(id+301)~=turn
end
function cid.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(cid.retfilter,1,nil,e:GetLabel(),Duel.GetTurnCount()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cid.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(cid.retfilter,nil,e:GetLabel(),Duel.GetTurnCount())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.SendtoDeck(tc,tc:GetPreviousControler(),0,REASON_EFFECT)
		tc=sg:GetNext()
	end
end