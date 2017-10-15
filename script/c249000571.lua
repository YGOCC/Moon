--Auium Extra Extender
function c249000571.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,249000571)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetTarget(c249000571.target)
	e1:SetOperation(c249000571.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(61344030,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c249000571.drcon)
	e2:SetTarget(c249000571.drtg)
	e2:SetOperation(c249000571.drop)
	c:RegisterEffect(e2)
end
function c249000571.tgfilter(c)
	return c:IsSetCard(0x1D1) and c:IsAbleToGrave() and not c:IsCode(249000571)
end
function c249000571.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000571.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c249000571.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c249000571.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		ac=Duel.AnnounceCard(tp)
		sc=Duel.CreateToken(tp,ac)
		while not (sc:IsType(TYPE_FUSION) or sc:IsType(TYPE_SYNCHRO) or sc:IsType(TYPE_XYZ))
		do
			ac=Duel.AnnounceCard(tp)
			sc=Duel.CreateToken(tp,ac)
		end
		Duel.SendtoDeck(sc,nil,0,REASON_RULE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetLabel(ac)
		e1:SetTarget(c249000571.splimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function c249000571.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (not se:GetHandler():IsSetCard(0x1D1)) and c:IsCode(e:GetLabel())
end
function c249000571.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)
		and c:GetPreviousControler()==tp and c:GetReasonPlayer()==1-tp
end
function c249000571.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000571.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end