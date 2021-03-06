--Prominence
function c511002449.initial_effect(c)
	aux.AddEquipProcedure(c)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511000319,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c511002449.destg)
	e3:SetOperation(c511002449.desop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(78586116,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(511002449)
	e4:SetTarget(c511002449.destg2)
	e4:SetOperation(c511002449.desop2)
	c:RegisterEffect(e4)
end
function c511002449.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec and ec:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ec,1,0,0)
end
function c511002449.desop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec and ec:IsLocation(LOCATION_MZONE) and Duel.Destroy(ec,REASON_EFFECT)>0 then
		Duel.RaiseSingleEvent(e:GetHandler(),511002449,e,0,0,0,0,0)
	end
end
function c511002449.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	local dam=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)*400
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c511002449.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		local dam=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)*500
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
