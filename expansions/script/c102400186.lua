--created & coded by Lyris
--フェイツ・プロヒビトガル
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.activate)
	c:RegisterEffect(e2)
	local e0=e2:Clone()
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCost(cid.cost)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cid.val)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(aux.PandSSetCon(c,0))
	e1:SetOperation(cid.ssetop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetOperation(function(e)
		local c=e:GetHandler()
		if c:GetOriginalType()==TYPE_TRAP then
			c:AddMonsterAttribute(TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT)
			c:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT)
		end
	end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(0)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCode(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	c:RegisterEffect(e3)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.PandSSetCon(c,-1)(c,e,tp,eg,ep,ev,re,r,rp) end
	c:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
	Duel.SSet(c:GetControler(),c,c:GetControler(),false)
end
function cid.ssetop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	c:RegisterEffect(e1,true)
	Duel.SSet(c:GetControler(),c,c:GetControler(),false)
	e1:Reset()
	c:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
end
function cid.cpfilter(c)
	return c:IsSetCard(0xf7a) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and not c:IsCode(id) and c:CheckActivateEffect(false,true,false)~=nil
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cid.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g==0 or Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==0 then return end
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cid.val(e,re,dam,r,rp,rc)
	return dam/2
end
