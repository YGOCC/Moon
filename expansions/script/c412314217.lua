--created by Jake, coded by Lyris, art from Cardfight!! Vanguard's "Fighting Spirit Revenger, Macart"
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e1:SetTarget(cid.drtg)
	e1:SetOperation(cid.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_HANDES)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
end
function cid.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function cid.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local ct=Duel.GetMatchingGroupCount(cid.filter,tp,LOCATION_MZONE,0,nil)
	if ct>3 then ct=3 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cid.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER),Duel.GetMatchingGroupCount(cid.filter,tp,LOCATION_MZONE,0,nil)
	if d>3 then d=3 end
	Duel.Draw(p,d,REASON_EFFECT)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cid.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x613) and c:IsAbleToDeck()
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		local dg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if #dg>0 and Duel.SelectYesNo(tp,1108) then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
