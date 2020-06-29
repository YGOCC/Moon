--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigEvoluteType(c)
	aux.AddEvoluteProc(c,nil,8,aux.OR(aux.FilterBoolFunction(Card.IsSetCard,0xc97),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK)),aux.FilterBoolFunction(Card.IsCode,id-25,id-24),1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_EXTRA_EVOLUTE_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetOperation(function(tc,tp) Duel.Remove(tc,POS_FACEUP,REASON_MATERIAL+REASON_BIGBANG) end)
	c:RegisterEffect(e0)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_BE_EVOLUTE_MATERIAL)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(0xfd,0)
	e6:SetValue(function(e,tc) if tc==nil then return true end return tc==e:GetHandler() end)
	c:RegisterEffect(e6)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetTargetRange(1,0)
	e5:SetTarget(cid.sumlimit)
	c:RegisterEffect(e5)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x6c97))
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
function cid.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3c97)
end
function cid.tgcon(e)
	return Duel.IsExistingMatchingCard(cid.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
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
	return c:IsSetCard(0xac97) and c:IsSSetable()
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
function cid.filter1(c,ft)
	if (c:GetType()&TYPE_EQUIP+TYPE_CONTINUOUS~=0 or c:IsHasEffect(EFFECT_REMAIN_FIELD))
		and ft<=0 then return false end
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:CheckActivateEffect(false,false,false) and c:IsSetCard(0xac97)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoDeck(c,nil,0,REASON_EFFECT)==0
		or not c:IsLocation(LOCATION_EXTRA) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,566)
	local sg=Duel.SelectMatchingCard(tp,cid.filter1,tp,LOCATION_DECK,0,1,1,nil,ft)
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
	if ft<=0 then Duel.ConfirmCards(1-tp,tc) end
	Duel.MoveToField(tc,tp,tp,tc:IsType(TYPE_FIELD) and LOCATION_FZONE or LOCATION_SZONE,POS_FACEUP,true)
	tc:CancelToGrave(tpe&TYPE_FIELD~=0)
	tc:CreateEffectRelation(te)
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then for etc in aux.Next(g) do etc:CreateEffectRelation(te) end end
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	if g then for etc in aux.Next(g) do etc:ReleaseEffectRelation(te) end end
	if not tc:IsOnField() then Duel.SendtoGrave(tc,REASON_RULE) end
end
