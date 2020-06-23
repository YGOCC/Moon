--Lich-Lord Xe'enafae
local cid,id=GetID()
function cid.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cid.ffilter,5,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Prevent Activation
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(cid.aclimit)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9163835,5))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(cid.cpcon)
	e3:SetTarget(cid.cptg)
	e3:SetOperation(cid.cpop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(cid.cpcon1)
	c:RegisterEffect(e4)
end
function cid.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_ZOMBIE) and (not sg or sg:IsExists(Card.IsFusionSetCard,1,nil,0x2e7))
end
function cid.aclimit(e,re,tp)
	return re:GetHandler():IsRace(RACE_ZOMBIE) and re:IsActiveType(TYPE_MONSTER)
end
function cid.cfilter(c)
	return c:IsCode(911630827)
end
function cid.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.cfilter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,1,nil) and not Duel.IsPlayerAffectedByEffect(tp,911630825)
end
function cid.cpcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.cfilter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerAffectedByEffect(tp,911630825)
end
function cid.copytg(c)
	return c:IsRace(RACE_ZOMBIE) and not c:IsCode(id)
end
function cid.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc~=e:GetHandler() and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and cid.copytg(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.copytg,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cid.copytg,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,2,2,e:GetHandler())
end
function cid.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg and c:IsRelateToEffect(e) and c:IsFaceup() then
		for tc in aux.Next(tg) do
			local code=tc:GetOriginalCode()
			local cid1=0
			if not tc:IsType(TYPE_TRAPMONSTER) then
				cid1=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			end
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCountLimit(1)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetLabel(cid1)
			e2:SetOperation(cid.rstop)
			c:RegisterEffect(e2)
		end
	end
end
function cid.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end