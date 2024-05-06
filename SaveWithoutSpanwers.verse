using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation/Tags }
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

#Gloomcraft Code https://gloomcraft.site/Shop.html
#Gloomcraft Video https://www.youtube.com/watch?v=pLnpfoXFR3c&t=77s

#Verse Documentation https://dev.epicgames.com/documentation/en-us/uefn/using-persistable-data-in-verse



TextForUI< localizes>(InText : string) : message = "Coins: {InText}"

player_data := class< final>< persistable>{
    Gold : int = 0

    #Initialize Stats for current players
    InitializeAllPlayers(Players:[]player):void=
        for(Player: Players):
            InitializePlayer(Player)

    #Initialize for one player
    InitializePlayer(Player:player):void=
        if:
            not Data[Player]
            set Data[Player] = player_data{}
}

player_data_update< constructor>(OldStat:player_data)< transacts> := player_data {
    Gold := OldStat.Gold
}

var Data:weak_map(player, player_data) = map{}


# A Verse-authored creative device that can be placed in a level
Persist_without_SaveDevice := class(creative_device):

    
    var NonSpawnerPlayerWay :player_data=player_data{}
 
    @editable Increase : button_device = button_device{}

    @editable Decrease : button_device = button_device{}

    InitPlayers():void=
        AllPlayers := GetPlayspace().GetPlayers()
        NonSpawnerPlayerWay.InitializeAllPlayers(AllPlayers)
        
    UpdateValues(PlayerObj : player)< suspends>: void = {
        CoinsBlock : text_block = text_block {DefaultTextColor := MakeColorFromHex("#38c92a")}

        if (PlayerUi := GetPlayerUI[PlayerObj]) {
            MyCanvas : canvas = canvas:
                Slots := array:
                    canvas_slot:
                        Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.25}, Maximum := vector2{X := 0.5, Y := 0.25}}
                        Alignment := vector2{X := 0.5, Y := 0.0}
                        SizeToContent := true
                        Widget := CoinsBlock
            PlayerUi.AddWidget(MyCanvas)
        }

        loop:
            Sleep(0.1)
            if (PlayerData := Data[PlayerObj]) {
                CoinsBlock.SetText(TextForUI(ToString(PlayerData.Gold)))
            }
    }

    IncreaseGold(Agent : agent) : void = {
        if (PlayerObj := player[Agent]) {
            if (PlayerData := Data[PlayerObj]) {
                if:
                    OldData := Data[PlayerObj]

                    set Data[PlayerObj] = player_data{
                        player_data_update< constructor>(OldData)
                        Gold := OldData.Gold + 1 
                    }
                then:
                    Print("Gold Increased")
                    spawn{UpdateValues(PlayerObj)}
            }
        }
    }

    DecreaseGold(Agent : agent) : void = {
        if (PlayerObj := player[Agent]) {
            if (PlayerData := Data[PlayerObj]) {
                if:
                    OldData := Data[PlayerObj]

                    set Data[PlayerObj] = player_data{
                        player_data_update< constructor>(OldData)
                        Gold := OldData.Gold - 1 
                    }
                then:
                    Print("Gold Decreased")
                    spawn{UpdateValues(PlayerObj)}
            }
        }
    }


    # Runs when the device is started in a running game
    OnBegin< override>()< suspends>:void=
        
        InitPlayers()
        
        Increase.InteractedWithEvent.Subscribe(IncreaseGold)

        Decrease.InteractedWithEvent.Subscribe(DecreaseGold)
