local _, CVARs = ...

C_Timer.After(0, function()
	SetCVar("autoLootDefault", 1)
	SetCVar("floatingCombatTextCombatDamage ", 1)
end)