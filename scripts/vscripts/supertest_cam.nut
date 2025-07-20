const CAM_LERP = 0.025
const CAM_PITCH = 45
const CAM_YAW = 75
const CAM_MIN_DIST = 1280
const CAM_TARGET_RECALC_RATE = 1.0
const CAM_SOUND_DIST = 0.05
const CAM_SOUND_RADIUS = 550;
::CAM_SOUND_LEVEL <- (40 + (20 * log10(CAM_SOUND_RADIUS / 36.0))).tointeger()

PrecacheSound("cam_move.wav");

function CamThink()
{
	local scope = self.GetScriptScope()
	if(!safeget(scope, "next_recalc_target", null))
	{
		scope["next_recalc_target"] <- 0
		scope["target"] <- null
		scope["sound_playing"] <- true
		scope["base_yaw"] <- self.GetAbsAngles().y
	}

	UpdateTarget()
	if (IsValid(scope["target"]))
	{
		LookAtTarget()
	}
	return -1;
}

function LookAtTarget()
{
	local scope = self.GetScriptScope()
    local dir = scope["target"].EyePosition() - self.GetOrigin();
    dir.Norm();

    local yaw = atan2(dir.y, dir.x) * 180 / PI;
	yaw = ClampAngleAround(yaw, scope["base_yaw"], CAM_YAW)

    local horizontalDist = sqrt(dir.x * dir.x + dir.y * dir.y);
    local pitch = atan2(-dir.z, horizontalDist) * 180 / PI;
	pitch = clamp(pitch, -CAM_PITCH, CAM_PITCH);

	local current_angles = self.GetAbsAngles()
    local angles = QAngle(lerp(current_angles.x, pitch, CAM_LERP), lerp(current_angles.y, yaw, CAM_LERP), 0);
    self.SetAbsAngles(angles);

	if(fabs(current_angles.x-angles.x) > CAM_SOUND_DIST || fabs(current_angles.y-angles.y) > CAM_SOUND_DIST)
	{
		if(!scope["sound_playing"])
		{
			scope["sound_playing"] <- true;
			EmitSoundEx({
				entity = self
				sound_level = CAM_SOUND_LEVEL
				volume = 1
				sound_name = "cam_move.wav"
				pitch = 100
			})
		}
	}
	else
	{
		scope["sound_playing"] <- false;
		EmitSoundEx({
			entity = self
			sound_name = "cam_move.wav"
			flags = SND_STOP
		})
	}
}

function UpdateTarget()
{
	local scope = self.GetScriptScope()
	if (scope["next_recalc_target"] > Time())
		return;

	local target = null;
	local least_distance = CAM_MIN_DIST;
	foreach(player in GetPlayers())
	{
		local player_distance = (player.GetOrigin() - self.GetOrigin()).Length();
		if (player_distance < least_distance)
		{
			target = player;
			least_distance = player_distance;
		}
	}

	scope["next_recalc_target"] <- Time() + CAM_TARGET_RECALC_RATE;
	scope["target"] <- target;
}