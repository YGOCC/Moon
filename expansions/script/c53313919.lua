--Mysterious Accel Dragon
function c53313919.initial_effect(c)
	--Materials: 1 Tuner + 1 non-Tuner Monsters
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	--When this card is Summoned: You can add 1 "Mysterious" monster from your GY to your Hand.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetTarget(c53313919.thtg)
	e2:SetOperation(c53313919.thop)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1)
	--Once per turn: You can choose a number from 1 to 6, target 1 monster you control: Its level becomes equal to the chosen number.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c53313919.lvtg)
	e3:SetOperation(c53313919.op)
	c:RegisterEffect(e3)
	--When this card is targeted by an attack or card effect: You can Banish this card until the End Phase, and for the rest of this turn you take no damage.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetTarget(c53313919.tg)
	e2:SetOperation(c53313919.op1)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		return tg and tg:IsContains(c) and Duel.IsChainNegatable(ev)
	end)
	c:RegisterEffect(e4)
	--When this card leaves the field: You can Special Summon 1 level 4 or lower "Mysterious" monster from your GY.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetTarget(c53313919.sptg)
	e5:SetOperation(c53313919.spop)
	c:RegisterEffect(e5)
end
function c53313919.tgfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcf6) and c:IsType(TYPE_MONSTER)
end
function c53313919.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c53313919.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c53313919.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c53313919.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c53313919.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c53313919.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={}
	local i=1
	local p=1
	local g=Group.CreateGroup()
	local mg=nil
	for i=1,6 do
		mg=Duel.GetMatchingGroup(function(c,lv,e) return c:GetLevel()~=lv and c:IsFaceup() and c:IsCanBeEffectTarget(e) end,tp,LOCATION_MZONE,0,nil,i,e)
		if mg:GetCount()>0 then t[p]=i p=p+1 end
		g:Merge(mg)
	end
	t[p]=nil
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
end
function c53313919.op(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c53313919.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c53313919.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler()
	if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		e:SetLabelObject(rc)
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetOperation(c53313919.retop)
		Duel.RegisterEffect(e1,tp)
	end
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c53313919.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c53313919.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xcf6) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c53313919.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c53313919.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c53313919.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c53313919.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
