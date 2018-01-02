--Kitseki Nurturesse
--Script by XGlitchy30
function c88523898.initial_effect(c)
	--link procedure
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x215a),2,2)
	c:EnableReviveLimit()
	--level/ctype change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88523898,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c88523898.chgcost)
	e1:SetOperation(c88523898.chgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c88523898.effectcon)
	e2:SetOperation(c88523898.effectop)
	c:RegisterEffect(e2)
end
local pack={}
	pack[1]={
		88513898
	}
	pack[2]={
		88523898
	}
--filters
function c88523898.rvfilter1(c,tp)
	local lv1=c:GetLevel()
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x215a) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c88523898.rvfilter2,tp,LOCATION_HAND,0,1,c,lv1)
end
function c88523898.rvfilter2(c)
	local lv2=c:GetLevel()
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x215a) and not c:IsPublic()
end
--level/ctype change
function c88523898.chgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88523898.rvfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c88523898.rvfilter1,tp,LOCATION_HAND,0,1,1,nil,tp)
	local lv1=g1:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,c88523898.rvfilter2,tp,LOCATION_HAND,0,1,1,g1:GetFirst())
	local lv2=g2:GetFirst():GetLevel()
	g1:Merge(g2)
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
	e:SetLabel(lv1+lv2)
end
function c88523898.chgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pos=c:GetPosition()
	local seq=c:GetSequence()
	local lv=e:GetLabel()
	local syn=Group.CreateGroup()
	----------
	if c:IsFaceup() and not c:IsType(TYPE_SYNCHRO) then
		Duel.Exile(c,REASON_RULE)
		local cpack=pack[1]
		local alias=cpack[math.random(#cpack)]
		syn:AddCard(Duel.CreateToken(tp,alias))
	--PREVIOUS VERSION------------------------
	--	Duel.DisableShuffleCheck()
	--	Duel.SendtoDeck(syn,nil,0,REASON_RULE)
	--	Duel.SpecialSummon(syn:GetFirst(),0,tp,tp,true,false,pos)
	-------------------------------------------
		Duel.MoveToField(syn:GetFirst(),tp,tp,LOCATION_MZONE,pos,true)
		Duel.MoveSequence(syn:GetFirst(),seq)
		syn:GetFirst():RegisterFlagEffect(88523898,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		--name change
		local name=Effect.CreateEffect(c)
		name:SetType(EFFECT_TYPE_SINGLE)
		name:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		name:SetCode(EFFECT_ADD_CODE)
		name:SetValue(88523898)
		name:SetReset(RESET_EVENT+0x1fe0000)
		syn:GetFirst():RegisterEffect(name)
		--level change
		local lev=Effect.CreateEffect(c)
		lev:SetType(EFFECT_TYPE_SINGLE)
		lev:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		lev:SetCode(EFFECT_CHANGE_LEVEL)
		lev:SetValue(lv)
		lev:SetReset(RESET_EVENT+0x1fe0000)
		syn:GetFirst():RegisterEffect(lev)
		--synchro material
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BE_MATERIAL)
		e2:SetCondition(c88523898.effectcon)
		e2:SetOperation(c88523898.effectop)
		syn:GetFirst():RegisterEffect(e2)
		--copy effect
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(88523898,0))
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(c88523898.chgcon_syn)
		e1:SetCost(c88523898.chgcost)
		e1:SetOperation(c88523898.chgop)
		syn:GetFirst():RegisterEffect(e1)
		--leave field fixes
		local fx2=Effect.CreateEffect(c)
		fx2:SetDescription(aux.Stringid(40854197,0))
		fx2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		fx2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
		fx2:SetCode(EVENT_TO_GRAVE)
		fx2:SetOperation(c88523898.reboot)
		syn:GetFirst():RegisterEffect(fx2)
		local fx3=fx2:Clone()
		fx3:SetCode(EVENT_REMOVE)
		syn:GetFirst():RegisterEffect(fx3)
		local fx4=fx2:Clone()
		fx4:SetCode(EVENT_TO_DECK)
		syn:GetFirst():RegisterEffect(fx4)
		----------------------------------
	elseif c:IsFaceup() and c:IsType(TYPE_SYNCHRO) then
		local levsyn=Effect.CreateEffect(c)
		levsyn:SetType(EFFECT_TYPE_SINGLE)
		levsyn:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		levsyn:SetCode(EFFECT_CHANGE_LEVEL)
		levsyn:SetValue(lv)
		levsyn:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(levsyn)
	else return end
end	
--gain effect
function c88523898.effectcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c88523898.effectop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sync=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88523898,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c88523898.deckcon)
	e1:SetTarget(c88523898.decktg)
	e1:SetOperation(c88523898.deckop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	sync:RegisterEffect(e1)
end	
--deck destruction
function c88523898.deckcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c88523898.decktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c88523898.deckop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
end	
--leave field
function c88523898.reboot(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetLocation()
	local pos=c:GetPosition()
	local rg=Group.CreateGroup()
	local cpack=pack[2]
	local original=cpack[math.random(#cpack)]
	rg:AddCard(Duel.CreateToken(tp,original))
	local rcd=rg:GetFirst()
	Duel.Exile(c,REASON_RULE)
	if loc==LOCATION_GRAVE then
		Duel.SendtoGrave(rcd,REASON_RULE)
	elseif loc==LOCATION_REMOVED and pos==POS_FACEUP then
		Duel.Remove(rcd,POS_FACEUP,REASON_EFFECT)
	elseif loc==LOCATION_REMOVED and pos==POS_FACEDOWN then
		Duel.Remove(rcd,POS_FACEDOWN,REASON_EFFECT)
	elseif loc==LOCATION_EXTRA then
		Duel.SendtoDeck(rcd,nil,2,REASON_EFFECT)
	else return end
end
-- last fixes (FINALLY!!!)
function c88523898.chgcon_syn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(88523898)==0
end