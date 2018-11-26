#include <YSI\y_ini>

#define DIALOG_REG 0
#define DIALOG_LOG 1
static trys = 2;

#define PATH "/accounts/%s.ini"

enum PlayerInfo
{
	playerPassword[64],
	playerMoneyBank,
	playerMoney,
	playerTypeAccount,
	Float:playerPosX,
	Float:playerPosY,
	Float:playerPosZ,
}

forward LoadUser_data(playerid, name[], value[]);
public LoadUser_data(playerid, name[], value[])
{
	INI_Int("Password", Info[playerid][playerPassword]);
	INI_Int("MoneyBank", Info[playerid][playerMoneyBank]);
	INI_Int("Money", Info[playerid][playerMoney]);
	INI_Int("TypeAccount", Info[playerid][playerTypeAccount]);
	INI_Float("PosX", Info[playerid][playerPosX]);
	INI_Float("PosY", Info[playerid][playerPosY]);
	INI_Float("PosZ", Info[playerid][playerPosZ]);
}

stock UserPath(playerid)
{
	new string[128], pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string), PATH, pname);
	return string;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(fexist(UserPath(playerid)))
	{
	    INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
	    ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_INPUT, "La cuenta ya a sido registrada", "Porfavor ingrese su contraseña", "Ingresar", "Salir");
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_INPUT, "Te damos la bienvenida a este RolePlay", "Porfavor elija su contraseña", "Registrarme", "Salir");
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid==DIALOG_REG)
        {
            if (!response) return Kick(playerid);
            if(response)
            {
                if(!strlen(inputtext))
				{
					if(!try == 0)
					{
						return ShowPlayerDialog(playerid, DIALOGO_REG, DIALOG_STYLE_INPUT, "Fallo en el registro/nQuedan 2 intentos", "Contraseña:", "Registrar", "Cancelar");
						trys--;
					}
					Kick(playerid);
				}
				new INI:File = INI_Open(UserPath(playerid));
                INI_SetTag(File,"data");
                INI_WriteString(File,"Password",inputtext);
                INI_WriteInt(File,"MoneyBank",0);
                INI_WriteInt(File,"Money",8000);
                INI_WriteInt(File,"TypeAccount",0);
                INI_WriteFloat(File,"PosX",1958.33);
                INI_WriteFloat(File,"PosY",1343.12);
                INI_WriteFloat(File,"PosZ",15.36);
                INI_Close(File);
		    	Info[playerid][jDinero]=8000;
		    	Info[playerid][jAdmin]=0;
		    	Info[playerid][jPosX]=1958.33;
		   		Info[playerid][jPosY]=1343.12;
		    	Info[playerid][jPosZ]=15.36;
                SetPlayerSkin(playerid, 26);
                SpawnPlayer(playerid);
            }
        }

        if(dialogid==DIALOG_LOG)
        {
            if ( !response ) return Kick ( playerid );
            if( response )
            {
            	if(strcmp(inputtext, Info[playerid][jContra], true) == 0)
                {
                    INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
                    GivePlayerMoney(playerid, Info[playerid][jDinero]);
                    SpawnPlayer(playerid);
                }
                else
                {
                    ShowPlayerDialog(playerid, DIALOGO_LOG, DIALOG_STYLE_INPUT,"Fallo en el ingreso","Contraseña:","Ingresar","Cancelar");
                }
                return 1;
            }
        }
	return 1;
}

stock SaveAccount(playerid)
{
	new INI:File = INI_Open(UserPath(playerid));
	INI_SetTag(File,"data");
	INI_WriteString(File,"Password",Info[playerid][jContra]);
	INI_WriteInt(File,"MoneyBank",Info[playerid][jDinero]);
    INI_WriteInt(File,"Money",Info[playerid][jDinero]);
	INI_WriteInt(File,"TypeAccount",Info[playerid][jAdmin]);
	GetPlayerPos(playerid,Info[playerid][jPosX], Info[playerid][jPosY], Info[playerid][jPosZ]);
    INI_WriteFloat(File,"PosX",Info[playerid][jPosX]);
	INI_WriteFloat(File,"PosY",Info[playerid][jPosY]);
	INI_WriteFloat(File,"PosZ",Info[playerid][jPosZ]);
 	INI_Close(File);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SaveAccount(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerPos(playerid, Info[playerid][playerPosX], Info[playerid][playerPosY], Info[playerid][playerPosZ]);
	return 1;
}
