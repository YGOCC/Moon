--Double Draw - Skill
local cXXXX = c66666667
function cXXXX.initial_effect(c)
	--Predraw/Remove
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetOperation(cXXXX.ops)
	c:RegisterEffect(e1)
	--Draw Skill
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCost(cXXXX.drcost)
	e2:SetOperation(cXXXX.drop)
	c:RegisterEffect(e2)
	--No Disable
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetCode(EFFECT_CANNOT_TO_DECK)
	eb:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(eb)
	local ec=eb:Clone()
	ec:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(ec)
	local ed=eb:Clone()
	ed:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(ed)
	local ee=eb:Clone()
	ee:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(ee)
end
function cXXXX.ops(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.DisableShuffleCheck()
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	if c:GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(c:GetControler(),1,REASON_RULE)
	end
end
function cXXXX.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 end
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp-100)
	Duel.PayLPCost(tp,lp-100)
end
function cXXXX.drop(e,tp,eg,ep,ev,re,r,rp)
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local s=p2-p1
	if s<0 then s=p1-p2 end
	local d=math.floor(s/1000)
	Duel.Draw(tp,d,REASON_EFFECT)
end
