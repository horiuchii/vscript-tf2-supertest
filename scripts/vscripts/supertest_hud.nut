::hud_text <- SpawnEntityFromTable("game_text",
{
    x = -1
    y = -1
    color = "255 255 255"
    holdtime = 0.3
    fadein = 0
    fadeout = 0.05
    message = " "
});

::CTFPlayer.SendGameText <- function(x, y, channel, color, message)
{
    if(GetButtons() & IN_SCORE)
        return;

    hud_text.AcceptInput("AddOutput", "x " + x, this, this);
    hud_text.AcceptInput("AddOutput", "y " + y, this, this);
    hud_text.AcceptInput("AddOutput", "channel " + channel, this, this);
    hud_text.AcceptInput("AddOutput", "color " + color, this, this);

    SetPropString(hud_text, "m_iszMessage", message);
    hud_text.AcceptInput("Display", "", this, this);
}

::CTFPlayer.ClearText <- function()
{
    for (local i = 0; i < 6; i++)
    {
        SendGameText(-1, -1, i, "255 255 255", " ");
    }
}