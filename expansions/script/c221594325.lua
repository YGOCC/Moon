--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigEvoluteType(c)
	aux.AddEvoluteProc(c,nil,8,aux.FilterBoolFunction(Card.IsSetCard,0xc97),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.FilterBoolFunction(Card.IsCode,id-25,id-24))
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_EXTRA_EVOLUTE_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetOperation(function(tc,tp) Duel.Remove(tc,POS_FACEUP,REASON_MATERIAL+REASON_BIGBANG) end)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cid.sumlimit)
	c:RegisterEffect(e1)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x2c97))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cid.tgcon)
	e1:SetValue(cid.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetTarget(cid.disable)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(cid.cost)
	e4:SetTarget(cid.tg)
	e4:SetOperation(cid.op)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,id)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetTarget(cid.target)
	e3:SetOperation(cid.operation)
	c:RegisterEffect(e3)
end
function cid.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xc97)
end
function cid.tgcon(e)
	return Duel.IsExistingMatchingCard(cid.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function cid.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cid.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and c:IsType(TYPE_EVOLUTE)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveEC(tp,2,REASON_COST) end
	c:RemoveEC(tp,2,REASON_COST)
end
function cid.filter(c)
	return c:IsSetCard(0x8c97) and c:IsSSetable()
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cid.cfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cid.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	Duel.SelectTarget(tp,cid.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then Duel.SSet(tp,tc) end
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cid.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:CheckActivateEffect(false,false,false) and c:IsSetCard(0x8c97)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoDeck(c,nil,0,REASON_EFFECT)==0
		or not c:IsLocation(LOCATION_EXTRA) then return end
	Duel.Hint(HINT_SELECTMSG,tp,566)
	local sg=Duel.SelectMatchingCard(tp,cid.filter1,tp,LOCATION_DECK,0,1,1,nil)
	local tc=sg:GetFirst()
	if not tc then return end
	Duel.BreakEffect()
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS)~=0 or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	elseif bit.band(tpe,TYPE_FIELD)~=0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	tc:CreateEffectRelation(te)
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local etc=g:GetFirst()
	while etc do
		etc:CreateEffectRelation(te)
		etc=g:GetNext()
	end
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	etc=g:GetFirst()
	while etc do
		etc:ReleaseEffectRelation(te)
		etc=g:GetNext()
	end
end
