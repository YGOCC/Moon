--Mysterious Cryophoenix
function c5332378.initial_effect(c)
    if not c5332378.global_check then
	--pandemonium
        local ge2=Effect.CreateEffect(c)
        ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge2:SetCode(EVENT_ADJUST)
        ge2:SetCountLimit(1)
        ge2:SetLabel(326)
        ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
        ge2:SetOperation(c5332378.chk)
        Duel.RegisterEffect(ge2,0)
    end
end
c5332378.pandemonium=true
c5332378.pandemonium_lscale=3 --x = Left Pandemonium Scale
c5332378.pandemonium_rscale=8 --y = Right Pandemonium Scale
function c5332378.chk(e,tp,eg,ep,ev,re,r,rp)
    Duel.CreateToken(tp,e:GetLabel())
    Duel.CreateToken(1-tp,e:GetLabel())
end
