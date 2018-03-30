--Gaia Knight, the Paladin of the Earth
--Script by XGlitchy30
function c37200210.initial_effect(c)
	--field limit
	c:SetUniqueOnField(1,0,37200210)
	--spsummon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c37200210.spproc)
	c:RegisterEffect(e1)
	--synchro/xyz lv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c37200210.synchro)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c37200210.xyz)
	c:RegisterEffect(e3)
	--extra damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37200210,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c37200210.damcon)
	e3:SetTarget(c37200210.damtg)
	e3:SetOperation(c37200210.damop)
	c:RegisterEffect(e3)
	--safe attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c37200210.aclimit)
	e4:SetCondition(c37200210.actcon)
	c:RegisterEffect(e4)
	--charge boost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetCondition(c37200210.charge)
	e5:SetValue(1000)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(37200210,4))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c37200210.sccon)
	e6:SetTarget(c37200210.sctg)
	e6:SetOperation(c37200210.scop)
	c:RegisterEffect(e6)
	--direct attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_DIRECT_ATTACK)
	e7:SetCondition(c37200210.dircon)
	c:RegisterEffect(e7)
	end
--filters
function c37200210.attribute(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c37200210.search(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand()
end
--spsummon procedure
function c37200210.spproc(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and Duel.IsExistingMatchingCard(c37200210.attribute,tp,LOCATION_MZONE,0,1,nil)
end
--extra deck material
function c37200210.synchro(e,c)
	local lv=e:GetHandler():GetLevel()
	return 7*65536+lv
end
function c37200210.xyz(e,c,rc)
	return 0x70000+e:GetHandler():GetLevel()
end
--extra damage
function c37200210.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
	and Duel.IsExistingMatchingCard(c37200210.attribute,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c37200210.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetBaseAttack()/2
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c37200210.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--safe attack
function c37200210.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c37200210.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsAttribute(ATTRIBUTE_EARTH)
	and Duel.IsExistingMatchingCard(c37200210.attribute,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
--charge boost
function c37200210.charge(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
		and e:GetHandler():GetSequence()+Duel.GetAttackTarget():GetSequence()==4
		and Duel.IsExistingMatchingCard(c37200210.attribute,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil)
end
--search
function c37200210.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37200210.attribute,tp,LOCATION_MZONE,LOCATION_MZONE,4,nil)
end
function c37200210.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200210.search,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c37200210.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c37200210.search,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--direct attack
function c37200210.dircon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37200210.attribute,tp,LOCATION_MZONE,LOCATION_MZONE,5,nil)
end