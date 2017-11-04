--Wandering Reaper
local ref=_G['c'..18917019]
function ref.initial_effect(c)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
	
	--Mill
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(ref.dkcon)
	e1:SetTarget(ref.dktg)
	e1:SetOperation(ref.dkop)
	c:RegisterEffect(e1)
	--Force Send
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(ref.grtg)
	e2:SetOperation(ref.grop)
	c:RegisterEffect(e2)
end

ref.bloom = true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,269)
	Duel.CreateToken(1-tp,269)
end
function ref.material(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end

function ref.dkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+269
		and e:GetHandler():GetMaterial():GetCount()>0
end
function ref.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	local lv=0
	local tc=mg:GetFirst()
	while tc do
		lv = lv+tc:GetLevel()
		tc=mg:GetNext()
	end
	if chk==0 then return lv>0 and Duel.IsPlayerCanDiscardDeck(tp,lv) and Duel.IsPlayerCanDiscardDeck(1-tp,lv) end
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,lv)
end
function ref.dkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g1=Duel.GetDecktopGroup(tp,ct)
	local g2=Duel.GetDecktopGroup(1-tp,ct)
	g1:Merge(g2)
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g1,REASON_EFFECT)
end

function ref.grfilter(c)
	return c:IsAbleToGrave()
end
function ref.atkfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_GRAVE)
end
function ref.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.grfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(ref.grfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil)
	end
end
function ref.grop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.grfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(1-tp,ref.grfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoGrave(g2,REASON_EFFECT)
			g:Merge(g2)
			g=g:Filter(ref.atkfilter,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(g:GetCount()*500)
				e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				e:GetHandler():RegisterEffect(e1)
			end
		end
	end
end
